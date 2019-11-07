//
//  TableViewTools.swift
//  iOSTools
//
//  Created by CuiXg on 2018/6/7.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

extension UITableView {
    var ytt: YTTTableView {
        return YTTTableView(self)
    }
}

struct YTTTableView {

    private var tableView: UITableView
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
    }
    
    /// 加载 xib 创建的 cell
    ///
    /// - Parameters:
    ///   - cellNibName: nib(xib 文件) 名称
    ///   - indentifier: cell 唯一标识
    ///   - class: cell 类型
    /// - Returns: 创建好的 cell
    func loadNibCell<T: UITableViewCell>(_ cellNibName: String, indentifier: String, class: T.Type) -> T? {
        // 需要注册 cell 或在 xib 填写 indentifier
        if let cell = tableView.dequeueReusableCell(withIdentifier: indentifier) as? T {
            return cell
        }
        if let cell = Bundle.main.loadNibNamed(cellNibName, owner: nil, options: nil)?.first as? T {
            cell.selectionStyle = .none
            return cell
        }
        
        return nil
    }
    
    
    /// 注册过的 cell 创建方法
    ///
    /// - Parameters:
    ///   - indentifier:  cell 标识
    ///   - indexPath: cell 的序列号
    ///   - class: cell 的类型
    /// - Returns: 创建好的 cell
    func loadCell<T: UITableViewCell>(_ indentifier: String, indexPath: IndexPath, class: T.Type) -> T {
        // 需要注册 cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath) as? T {
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = T(style: .default, reuseIdentifier: indentifier)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    /// cell 创建方法, 可以未注册
    ///
    /// - Parameters:
    ///   - indentifier:  cell 标识
    ///   - indexPath: cell 的序列号
    ///   - class: cell 的类型
    /// - Returns: 创建好的 cell
    func loadCell<T: UITableViewCell>(_ indentifier: String, class: T.Type) -> T {
        // 需要注册 cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: indentifier) as? T {
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = T(style: .default, reuseIdentifier: indentifier)
            cell.selectionStyle = .none
            return cell
        }
    }
    

}

