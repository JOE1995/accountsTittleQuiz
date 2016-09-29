//
//  ViewController.swift
//  accountsTittleQuiz
//
//  Created by 矢吹祐真 on 2016/09/24.
//  Copyright © 2016年 矢吹祐真. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController {
    
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
//        label.text = String(name)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

   
}

