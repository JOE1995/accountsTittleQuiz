//
//  ResultViewController.swift
//  accountsTittleQuiz
//
//  Created by 矢吹祐真 on 2016/09/25.
//  Copyright © 2016年 矢吹祐真. All rights reserved.
//

import UIKit
import Social
import NCMB

class ResultViewController: UIViewController {

    var correctAnswer:Int!
    var presentArray:[String] = []
    var choices:[String] = ["資産","負債","資本","収益","費用"]
    
    var sumScore:Int = 0
    var numberOfPlayer = 0
    
    @IBOutlet var scoreLabel:UILabel!
    @IBOutlet var answerLabel:UILabel!
    @IBOutlet var test:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

    
        //test.backgroundColor = UIColor.cloudsColor()
        scoreLabel.text = ("得点は\(correctAnswer*10)点です")
        let number = Int(presentArray[1])!-1
        answerLabel.text = ("「\(presentArray[0])」は「\(choices[number])」です")
        
        // GameScoreクラスを検索するクエリを作成
        let query = NCMBQuery(className: "GameScore")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        //print(object.objectId)
                        print(object.objectForKey("username")!)
                        print(object.objectForKey("score")!)
                        self.sumScore = self.sumScore + Int(object.objectForKey("score")! as! NSNumber)
                        self.numberOfPlayer += 1
                        print("今\(self.numberOfPlayer)人目")
                        print("合計\(self.sumScore)")
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    
    }
    
    override func viewDidAppear(animated: Bool) {
        print("平均\(sumScore/numberOfPlayer)")
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Facebook投稿メソッド
    @IBAction func postFacebook(sender: AnyObject) {
        //Facebook投稿用定数を作成
        let fbVC:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        //投稿テキストを設定
        fbVC.setInitialText("得点は\(correctAnswer*10)点でした！")
        //投稿画像を設定
        fbVC.addImage(UIImage(named: "icon2.png"))
        //投稿コントローラーを起動
        self.presentViewController(fbVC, animated: true, completion: nil)
    }
    //Twitter投稿メソッド
    @IBAction func postTwitter(sender: AnyObject) {
        //Twitter投稿用定数を作成
        let twVC:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        //投稿テキストを設定
        twVC.setInitialText("得点は\(correctAnswer*10)点でした！")
        //投稿画像を設定
        twVC.addImage(UIImage(named: "icon2.png"))
        //投稿コントローラーを起動
        self.presentViewController(twVC, animated: true, completion: nil)
    }
    
    //ホーム画面に戻る
    @IBAction func toHome(sender: AnyObject){
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

}
