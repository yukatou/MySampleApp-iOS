//
//  BookSearchViewModel.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/05.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class BookSearchViewModel {

    private let provider = MoyaProvider<GoogleBookAPI>()
    let items: Variable<[Volume]> =  Variable([])

    init() {
    }

    func fetchItems(query: String) -> Observable<Void> {

        return Observable.create { observer in
            let task = self.provider.request(.volumes(query: query)) { [unowned self] result in
                switch result {
                case .success(let response):
                    let data = response.data
                    if case 200..<300 = response.statusCode {
                        let volumesResponse = try! JSONDecoder().decode(VolumesResponse.self, from: data)
                        self.items.value = volumesResponse.items

                        observer.onNext(())
                        observer.onCompleted()
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
    func numberOfSections() -> Int {
        return 1
    }
    
//    func numberOfRowsInSection(_ section: Int) -> Int {
//        return items.value.count
//    }
//
//    func getItem(index: Int) -> Volume {
//        return items.value[index]
//    }
//
//    func titleForRow(atIndex index: Int) -> String {
//        let item = items.value[index]
//        return item.volumeInfo.title
//    }
//
//    func imageURLForRow(atIndex index: Int) -> URL? {
//        let item = items.value[index]
//        var imageURL: URL?
//
//        if let imageLinks = item.volumeInfo.imageLinks {
//            imageURL = URL(string: imageLinks.thumbnail.convertHttps())
//        }
//
//        return imageURL
//    }
}
