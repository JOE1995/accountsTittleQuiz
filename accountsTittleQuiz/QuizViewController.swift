//
//  QuizViewController.swift
//  accountsTittleQuiz
//
//  Created by 矢吹祐真 on 2016/09/24.
//  Copyright © 2016年 矢吹祐真. All rights reserved.
//

import UIKit
import LTMorphingLabel
import NCMB

class QuizViewController: UIViewController {
    
    var quizArrray:[String] = []
    var presentArray:[String] = []
    var choices:[String] = ["資産","負債","資本","収益","費用"]
    
    var number:Int!
    var correctAnswer:Int = 0
    var numberOfQuiz:Int = 1
    
    var name:String!
    
    var hasBeenTheBestScore:Int = 0
    
  
    @IBOutlet var label:LTMorphingLabel!
    @IBOutlet var choice1:UIButton!
    @IBOutlet var choice2:UIButton!
    @IBOutlet var choice3:UIButton!
    @IBOutlet var choice4:UIButton!
    @IBOutlet var choice5:UIButton!
    @IBOutlet var choice6:UIButton!
    @IBOutlet var choice7:UIButton!
    
    @IBOutlet var test:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nameUd = NSUserDefaults.standardUserDefaults()
        name = (nameUd.objectForKey("password") as? String)!
        
        
        //test.backgroundColor = UIColor.cloudsColor()
//        choice1.backgroundColor = UIColor.whiteColor()
//        choice2.backgroundColor = UIColor.whiteColor()
//        choice3.backgroundColor = UIColor.whiteColor()
//        choice4.backgroundColor = UIColor.whiteColor()
//        choice5.backgroundColor = UIColor.whiteColor()
//        choice6.backgroundColor = UIColor.whiteColor()
//        choice7.backgroundColor = UIColor.whiteColor()
     

        // Do any additional setup after loading the view.
        
        do {
            //CSVファイルのパスを取得する。
            let csvPath = NSBundle.mainBundle().pathForResource("list", ofType: "csv")
            
            //CSVファイルのデータを取得する。
            let csvData = try String(contentsOfFile:csvPath!, encoding:NSUTF8StringEncoding)
            
            //改行区切りでデータを分割して配列に格納する。
            quizArrray = csvData.componentsSeparatedByString("\n")
            number = Int(arc4random_uniform(UInt32(quizArrray.count)))
            print("number:\(number)")
            presentArray = quizArrray[number].componentsSeparatedByString(",")
            print("presentArrayに入っているのは\(presentArray)")
            quizArrray.removeAtIndex(number)
            label.morphingEffect = .Anvil
            label.text = presentArray[0]
//            choice1.setTitle(choices[0], forState: .Normal)
//            choice2.setTitle(choices[1], forState: .Normal)
//            choice3.setTitle(choices[2], forState: .Normal)
//            choice4.setTitle(choices[3], forState: .Normal)
//            choice5.setTitle(choices[4], forState: .Normal)
            
        } catch {
            print(error)
        }

        print("\(numberOfQuiz)問目")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(animated: Bool) {
//        test.backgroundColor = UIColor.sunflowerColor()
//        
//        UIView.animateWithDuration(
//            30, // アニメーションの時間(秒)
//            animations: {() -> Void  in
//                // アニメーションする処理
//                self.test.backgroundColor = UIColor.alizarinColor()
//        })
//    }
    
    func showQuiz(){
        
        numberOfQuiz = numberOfQuiz + 1
        print("\(numberOfQuiz)問目")
        
        presentArray.removeAll()
        
        number = Int(arc4random_uniform(UInt32(quizArrray.count)))
        print("number:\(number)")
        presentArray = quizArrray[number].componentsSeparatedByString(",")
        print("presentArrayに入っているのは\(presentArray)")
        quizArrray.removeAtIndex(number)
        
        label.morphingEffect = .Scale
        label.text = presentArray[0]
//        choice1.setTitle(choices[0], forState: .Normal)
//        choice2.setTitle(choices[1], forState: .Normal)
//        choice3.setTitle(choices[2], forState: .Normal)
//        choice4.setTitle(choices[3], forState: .Normal)
//        choice5.setTitle(choices[4], forState: .Normal)
        
     
        
//        number = Int(arc4random_uniform(UInt32(quizArrray.count)))
//        print("number:\(number)")
//        presentArray = quizArrray[number].componentsSeparatedByString(",")
//        print("presentArrayに入っているのは\(presentArray)")
//        quizArrray.removeAtIndex(number)
    
    }
    
    @IBAction func choiceAnswer(sender:UIButton){
        
        choice1.enabled = false
        choice2.enabled = false
        choice3.enabled = false
        choice4.enabled = false
        choice5.enabled = false
        choice6.enabled = false
        choice7.enabled = false
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.choice1.enabled = true
            self.choice2.enabled = true
            self.choice3.enabled = true
            self.choice4.enabled = true
            self.choice5.enabled = true
            self.choice6.enabled = true
            self.choice7.enabled = true
        })
        
        if Int(presentArray[1]) == sender.tag{
            
            print("正解！")
            
            correctAnswer = correctAnswer + 1
            if correctAnswer >= quizArrray.count{
                performSegueToResult()
            }
            showQuiz()
            
        } else {
            
            //次の画面に遷移する前に名前とスコアを保存
            self.saveScore(name, score: correctAnswer*10
            )
            
            
            // 1秒遅延
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.performSegueToResult()
            }
        }
        
    }

    
    func performSegueToResult(){
        performSegueWithIdentifier("toResult", sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toResult"{
            let resultView = segue.destinationViewController as! ResultViewController
            resultView.correctAnswer = self.correctAnswer
            resultView.presentArray = self.presentArray
        
        }
    }
    
    
    // 【mBaaS】データの保存
    func saveScore (name: String, score: Int) {
        
        
        // 今回がハイスコアか確かめる
        
        //getScoreメソッドを使い、今までの最高点を定数に入れる
        hasBeenTheBestScore = getScore(name)
        print(hasBeenTheBestScore)
        
        //ハイスコアを出した場合のみ、scoreを更新する
        if hasBeenTheBestScore < correctAnswer*10 {
        
        updateScore()
          
        /*
        保存ではなくて、更新を使うので一旦コメントアウト。getScoreメソッドで使う。
        // 保存先クラスを作成
        let obj = NCMBObject(className: "GameScore")
        // 値を設定
        obj.setObject(name, forKey: "username")
        obj.setObject(score, forKey: "score")
        // 保存を実施
        obj.saveInBackgroundWithBlock{(error: NSError!) -> Void in
            if (error != nil) {
                // 保存に失敗した場合の処理
                print("保存に失敗しました。エラーコード:\(error.code)")
            }else{
                // 保存に成功した場合の処理
                print("保存に成功しました。objectId:\(obj.objectId)")
            
            }
        }
        */
            
        }
        
    }
    
    func getScore(name:String) -> Int {
        var score:Int = 0
        
        let query = NCMBQuery(className: "GameScore")
        query.whereKey("username", equalTo: name)
        var results:[AnyObject] = []
        do {
            results = try query.findObjects()
        } catch  let error1 as NSError  {
            print("\(error1)")
            return score
        }
        if results.count > 0 {
            let result = results[0] as? NCMBObject
            score = Int((result?.objectForKey("score"))! as! NSNumber)
        }   // scoreをgetできなかった(データストアにない)場合は、今回のスコアを保存をする
            else {
            // 保存先クラスを作成
            let obj = NCMBObject(className: "GameScore")
            // 値を設定
            obj.setObject(name, forKey: "username")
            obj.setObject(score, forKey: "score")
            // 保存を実施
            obj.saveInBackgroundWithBlock{(error: NSError!) -> Void in
                if (error != nil) {
                    // 保存に失敗した場合の処理
                    print("保存に失敗しました。エラーコード:\(error.code)")
                }else{
                    // 保存に成功した場合の処理
                    print("保存に成功しました。objectId:\(obj.objectId)")
                    
                }
            }
 
        }
        return score
        
    }
    
    func updateScore() {
        
        let query = NCMBQuery(className: "GameScore")
        query.whereKey("username", equalTo: name)
        var results:[AnyObject] = []
        do {
            results = try query.findObjects()
        } catch  let error1 as NSError  {
            print("\(error1)")
            return
        }
        if results.count > 0 {
            let obj = results[0] as! NCMBObject
            
            obj.setObject(correctAnswer*10,forKey:"score")
            
            obj.saveInBackgroundWithBlock({(error) in
                if error != nil {print("Save error : ",error)}
            })
            
        }
    }

}

class MaterialButton: UIButton {
    private let tapEffectView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        // ボタン自体を角丸にする
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        // 円を描画
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.grayColor().CGColor
        shapeLayer.path = UIBezierPath(ovalInRect: tapEffectView.bounds).CGPath
        tapEffectView.layer.addSublayer(shapeLayer)
        tapEffectView.hidden = true
        
        addSubview(tapEffectView)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let point = touches.first?.locationInView(self) {
            tapEffectView.frame.origin = point
            
            tapEffectView.alpha = 0.8
            tapEffectView.hidden = false
            tapEffectView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            UIView.animateWithDuration(0.5,
                                       animations: {
                                        self.tapEffectView.alpha = 0.1
                                        self.tapEffectView.transform = CGAffineTransformMakeScale(300.0, 300.0)
            }) { finished in
                self.tapEffectView.hidden = true
                self.tapEffectView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
        }
    }
}
