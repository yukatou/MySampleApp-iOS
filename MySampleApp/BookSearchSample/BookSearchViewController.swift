//
//  BookSearchViewController.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/03.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import UIKit
import Moya
import Kingfisher
import RxSwift
import RxCocoa

class BookSearchViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: BookSearchViewModel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = BookSearchViewModel()

        // Do any additional setup after loading the view.

        viewModel.items.asObservable()
            .filter { !$0.isEmpty }
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                let imageView = cell.viewWithTag(1) as! UIImageView
                let titleLabel = cell.viewWithTag(2) as! UILabel
                imageView.kf.setImage(with: element.volumeInfo.imageURL())
                titleLabel.text = element.volumeInfo.title
            }
            .disposed(by: disposeBag)


        tableView.rx.modelSelected(Volume.self)
            .subscribe(onNext: { [unowned self] item in
                self.performSegue(withIdentifier: "toBookSearchDetailSegue", sender: item)
            })
            .disposed(by: disposeBag)

        viewModel.fetchItems(query: "ドラえもん")
//            .observeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toBookSearchDetailSegue" {
            if let vc = segue.destination as? BookSearchDetailViewController {
                vc.viewModel = BookSearchDetailViewModel(item: sender as! Volume)
            }
        }
    }
}

//extension BookSearchViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = viewModel.items[indexPath.row]
//        performSegue(withIdentifier: "toBookSearchDetailSegue", sender: item)
//    }
//
//}

