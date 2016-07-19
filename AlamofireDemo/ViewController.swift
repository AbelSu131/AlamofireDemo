//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by AbelSu on 16/7/8.
//  Copyright © 2016年 AbelSu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

class Book:NSObject{
    var title = ""
    var subtitle = ""
    var image = ""
}

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var tableView:UITableView?
    
    let URLString = "https://api.douban.com/v2/book/search"
    var books = [Book]()
    //var leftBtn:UIButton?//左边的按钮
    //var rightBtn:UIBarButtonItem?//右边的UIBarItem
    //预制数据
    var listTeams:NSMutableArray?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        Alamofire.request(.GET, URLString, parameters: ["tag":"Swift","count":10]).validate().responseJSON{(resp) -> Void in
            if let error = resp.result.error{
                print(error)
                
            }else if let value = resp.result.value, jsonArray = JSON(value)["books"].array{
                for json in jsonArray{
                    
                    let book = Book()
                    book.title = json["title"].string ?? ""
                    book.subtitle = json["subtitle"].string ?? ""
                    book.image = json["image"].string ?? ""
                    self.books.append(book)
                    
                }
                self.tableView?.reloadData()
            }
        }
        
        initView()
        
    }
    
    //初始化tableView
    func initView(){
        self.tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain)//也可用.Plain代替
        
        //设置tableView的数据源
        self.tableView!.dataSource = self
        
        //设置tableView的委托
        self.tableView!.delegate = self
        self.view.addSubview(self.tableView!)
    }
    
    
    //返回组数的代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
   
    //返回行数的代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
   
    //返回每一行cell的代理方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell! = (tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell?)!
        if (cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
            //设置cell的选中样式
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        }
        let book = books[indexPath.row]
        
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.subtitle
        cell.imageView?.kf_setImageWithURL(NSURL(string: book.image) ?? NSURL())
        
        return cell
        
      

    }
 
 
 
}

