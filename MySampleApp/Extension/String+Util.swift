//
//  String+Util.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/03.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import Foundation

extension String {
    
    func convertHttps() -> String {
        if self.hasPrefix("http://") {
            return self.replacingOccurrences(of: "http", with: "https")
        }
        
        return self
    }
}
