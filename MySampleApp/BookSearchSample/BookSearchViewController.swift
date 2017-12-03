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

class BookSearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let provider = MoyaProvider<GoogleBookAPI>()
    var items: [Volume] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        provider.request(.volumes(query: "ドラえもん")) { result in
            switch result {
            case .success(let response):
                let data = response.data
                
                let str = String(data: data, encoding: .utf8)
                let statusCode = response.statusCode
                
                if case 200..<300 = statusCode {
                    let volumesResponse = try! JSONDecoder().decode(VolumesResponse.self, from: data)
                    self.items += volumesResponse.items
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension BookSearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = items[indexPath.row]
        let imageView = cell.viewWithTag(1) as! UIImageView
        let titleLabel = cell.viewWithTag(2) as! UILabel

        var imageURL: URL?
        if let imageLinks = item.volumeInfo.imageLinks {
            imageURL = URL(string: imageLinks.thumbnail.convertHttps())
        }
        imageView.kf.setImage(with: imageURL)
        titleLabel.text = item.volumeInfo.title

        return cell
    }

}

extension BookSearchViewController: UITableViewDelegate {

}
