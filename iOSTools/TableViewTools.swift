//
//  TableViewTools.swift
//  iOSTools
//
//  Created by qiuweniOS on 2018/6/7.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

extension UITableView {
    var ytt: YTTTableView {
        return YTTTableView(self)
    }
}

class YTTTableView {

    var tableView: UITableView
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
    }
    
    func loadNibCell<T>(_ cellNibName: String, indentifier: String, class: T.Type) -> T? {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: indentifier) as? T {
            return cell
        }
        if let cell = Bundle.main.loadNibNamed(cellNibName, owner: nil, options: nil)?.first as? T {
            return cell
        }
        
        return nil
    }
}

