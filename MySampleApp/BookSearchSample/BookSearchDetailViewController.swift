//
//  BookSearchDetailViewController.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/11.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookSearchDetailViewController: UIViewController {

    var viewModel: BookSearchDetailViewModel!
    let disposeBag = DisposeBag()

    @IBOutlet weak var favoriteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteButton.rx.tap.subscribe(onNext: {
            print("test")
        }).disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
