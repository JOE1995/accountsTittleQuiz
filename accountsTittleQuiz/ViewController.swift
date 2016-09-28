//
//  ViewController.swift
//  accountsTittleQuiz
//
//  Created by 矢吹祐真 on 2016/09/24.
//  Copyright © 2016年 矢吹祐真. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 「rankingTableView」ランキングを表示するテーブル
    @IBOutlet weak var rankingTableView: UITableView!
    // ランキング取得数
    var rankingNumber = 5
    // 取得したデータを格納する配列
    var rankingArray: Array<NCMBObject> = []
    
//    @IBOutlet var startButton:UIButton!
    @IBOutlet var label:UILabel!
    
    var name:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.cloudsColor()

        let nameUd = NSUserDefaults.standardUserDefaults()
        name = (nameUd.objectForKey("password") as? String)!
        label.text = String(name)
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        // 保存したデータの検索と取得
        checkRanking()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        checkRanking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    // 【mBaaS】保存したデータの検索と取得
    func checkRanking() {
        
        // GameScoreクラスを検索するクエリを作成
        let query = NCMBQuery(className: "GameScore")
        // scoreの降順でデータを取得するように設定する
        query.addDescendingOrder("score")
        // 検索件数を設定
        query.limit = Int32(rankingNumber)
        // データストアを検索
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                // 検索に失敗した場合の処理
                print("検索に失敗しました。エラーコード：\(error.code)")
            } else {
                // 検索に成功した場合の処理
                print("検索に成功しました。")
                // 取得したデータを格納
                self.rankingArray = objects as! Array
                
                self.rankingNumber = objects.count
                
                // テーブルビューをリロード
                self.rankingTableView.reloadData()
            }
        }
        

    }
    
    // rankingTableViewのセルの数を指定
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankingNumber
    }
    
    // rankingTableViewのセルの内容を設定
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // キーを「cell」としてcellデータを取得
        let cell = rankingTableView.dequeueReusableCellWithIdentifier("rankingTableCell", forIndexPath: indexPath)
        var object: NCMBObject?
        // 「表示件数」＜「取得件数」の場合のobjectを作成
        if indexPath.row < rankingArray.count {
            object = self.rankingArray[indexPath.row]
        }
        
        // 順位の表示
        let ranking = cell.viewWithTag(1) as! UILabel
        ranking.text = "\(indexPath.row+1)位"
        ranking.textColor = UIColor.whiteColor()
        
        if let unwrapObject = object {
            // 名前の表示
            let name = cell.viewWithTag(2) as! UILabel
            name.text = "\(unwrapObject.objectForKey("username"))さん"
            name.textColor =  UIColor.whiteColor()
            // スコアの表示
            let score = cell.viewWithTag(3) as! UILabel
            score.text = "\(unwrapObject.objectForKey("score"))点"
            score.textColor = UIColor.whiteColor()
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.belizeHoleColor()
        }else{
            cell.backgroundColor = UIColor.pomergranateColor()

        }
        
        
        return cell
    }

   
}

