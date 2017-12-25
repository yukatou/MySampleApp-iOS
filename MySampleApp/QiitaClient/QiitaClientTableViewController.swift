//
//  QiitaClientTableViewController.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/24.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class QiitaClientTableViewController: UITableViewController {

    let qiitaClient = QiitaClient()

    let disposeBag = DisposeBag()

    var items: Variable<[QiitaItem]> = Variable([])

    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = nil
        tableView.dataSource = nil

        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)

        searchBar.text = "RxSwift"

        items.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self))
            { (row, element, cell) in
                let titleLabel = cell.viewWithTag(1) as! UILabel
                titleLabel.text = element.title
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(QiitaItem.self)
            .subscribe(onNext: { [unowned self] item in
                let vc = UIAlertController(title: item.id, message: item.title, preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [searchBar] in
                searchBar?.showsCancelButton = true
            })
            .disposed(by: disposeBag)

        searchBar.rx.textDidEndEditing
            .subscribe(onNext: { [searchBar] in
                searchBar?.showsCancelButton = true
            })
            .disposed(by: disposeBag)


        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [searchBar] in
                searchBar?.resignFirstResponder()
                searchBar?.showsCancelButton = false
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(
            searchQuery, isRefreshing.startWith(true)) { query, _ -> String in
                return query
            }
            .flatMapLatest { [unowned self] query in
                return self.qiitaClient.rx.fetch(query: query)
            }
            .do(onNext: { [refreshControl] _ in
                refreshControl?.endRefreshing()
            })
            .subscribe(onNext: { [unowned self] items in
                self.items.value = items
            })
            .disposed(by: disposeBag)
    }

    private lazy var searchQuery: Observable<String> = {
        return searchBar.rx.text.orEmpty
            .filter { $0.count > 3 }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }()

    private lazy var isRefreshing: Observable<Bool> = {
        if let refreshControl = self.refreshControl {
            return refreshControl.rx.controlEvent(.valueChanged)
                .map { refreshControl.isRefreshing }
        }
        return .just(false)
    }()

}
