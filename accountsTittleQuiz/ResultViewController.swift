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

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var correctAnswer:Int!
    var presentArray:[String] = []
    var choices:[String] = ["資産","負債","資本","収益","費用"]
    
    var sumScore:Int = 0
    var numberOfPlayer = 0
    
    @IBOutlet var scoreLabel:UILabel!
    @IBOutlet var answerLabel:UILabel!
    @IBOutlet var area:UIView!
    @IBOutlet var highScoreLabel:UIImageView!
    
    var isHighScore:Bool!
    
    //0~100
    var g:CGFloat = 0
    //100~200
    var f:CGFloat = 0
    //200~300
    var e:CGFloat = 0
    //300~400
    var d:CGFloat = 0
    //400~500
    var c:CGFloat = 0
    //500~600
    var b:CGFloat = 0
    //600~
    var a:CGFloat = 0

    // 「rankingTableView」ランキングを表示するテーブル
    @IBOutlet weak var rankingTableView: UITableView!
    // ランキング取得数
    var rankingNumber = 100
    // 取得したデータを格納する配列
    var rankingArray: Array<NCMBObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        highScoreLabel.hidden = true
        if isHighScore == true{
            highScoreLabel.hidden = false
        }
        
        //test.backgroundColor = UIColor.cloudsColor()
        scoreLabel.text = String(correctAnswer*10)
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
                        let score = CGFloat(object.objectForKey("score")! as! NSNumber)
                        self.sumScore = self.sumScore + Int(object.objectForKey("score")! as! NSNumber)
                        self.numberOfPlayer += 1
                        print("今\(self.numberOfPlayer)人目")
                        print("合計\(self.sumScore)")
                        if score < 100{
                            self.g = self.g + 1
                        } else if score < 200{
                            self.f = self.f + 1
                        } else if score < 300{
                            self.e = self.e + 1
                        } else if score < 400{
                            self.d = self.d + 1
                        } else if score < 500{
                            self.c = self.c + 1
                        } else if score < 600{
                            self.b = self.b + 1
                        } else{
                            self.a = self.a + 1
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        // 保存したデータの検索と取得
        checkRanking()
    
    }
    
    override func viewDidAppear(animated: Bool) {
        print("平均\(sumScore/numberOfPlayer)")
        drawLineGraph()
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
            cell.backgroundColor = UIColor.hoge()
        }else{
            cell.backgroundColor = UIColor.hogehoge()
            
        }
        
        
        return cell
    }
    
    
    //以下グラフ用コード
    func drawLineGraph() {
        let stroke1 = LineStroke(graphPoints: [g, f, e, d, c, b, a])
        print(g,f,e, d, c, b, a)
    
        
        stroke1.color = UIColor.cyanColor()
        
        let graphFrame = LineStrokeGraphFrame(strokes: [stroke1])
        
        let lineGraphView = UIView(frame: CGRect(x: 0, y: 20, width: area.frame.width, height: area.frame.height))
        lineGraphView.backgroundColor = UIColor.grayColor()
        lineGraphView.addSubview(graphFrame)
        
        area.addSubview(lineGraphView)
    }
    
    

}


protocol GraphObject {
    var area: UIView { get }
}

extension GraphObject {
    var area: UIView {
        return self as! UIView
    }
    
    func drawLine(from: CGPoint, to: CGPoint) {
        let linePath = UIBezierPath()
        
        linePath.moveToPoint(from)
        linePath.addLineToPoint(to)
        
        linePath.lineWidth = 0.5
        
        let color = UIColor.whiteColor()
        color.setStroke()
        linePath.stroke()
        linePath.closePath()
    }
}

protocol GraphFrame: GraphObject {
    var strokes: [GraphStroke] { get }
}

extension GraphFrame {
    // 保持しているstrokesの中で最大値
    var yAxisMax: CGFloat {
        return strokes.map{ $0.graphPoints }.flatMap{ $0 }.flatMap{ $0 }.maxElement()!
    }
    
    // 保持しているstrokesの中でいちばん長い配列の長さ
    var xAxisPointsCount: Int {
        return strokes.map{ $0.graphPoints.count }.maxElement()!
    }
    
    // X軸の点と点の幅
    var xAxisMargin: CGFloat {
        return area.frame.width/CGFloat(xAxisPointsCount)
    }
}

class LineStrokeGraphFrame: UIView, GraphFrame {
    var strokes = [GraphStroke]()
    
    convenience init(strokes: [GraphStroke]) {
        self.init()
        self.strokes = strokes
    }
    
    override func didMoveToSuperview() {
        if self.superview == nil { return }
        self.frame.size = self.superview!.frame.size
        self.area.backgroundColor = UIColor.clearColor()
        
        strokeLines()
    }
    
    func strokeLines() {
        for stroke in strokes {
            self.addSubview(stroke as! UIView)
        }
    }
    
    override func drawRect(rect: CGRect) {
        drawTopLine()
        drawBottomLine()
        drawVerticalLines()
    }
    
    func drawTopLine() {
        self.drawLine(
            CGPoint(x: 0, y: frame.height),
            to: CGPoint(x: frame.width, y: frame.height)
        )
    }
    
    func drawBottomLine() {
        self.drawLine(
            CGPoint(x: 0, y: 0),
            to: CGPoint(x: frame.width, y: 0)
        )
    }
    
    func drawVerticalLines() {
        for i in 1..<xAxisPointsCount {
            let x = xAxisMargin*CGFloat(i)
            self.drawLine(
                CGPoint(x: x, y: 0),
                to: CGPoint(x: x, y: frame.height)
            )
        }
    }
}


protocol GraphStroke: GraphObject {
    var graphPoints: [CGFloat?] { get }
}

extension GraphStroke {
    var graphFrame: GraphFrame? {
        return ((self as! UIView).superview as? GraphFrame)
    }
    
    var graphHeight: CGFloat {
        return area.frame.height
    }
    
    var xAxisMargin: CGFloat {
        return graphFrame!.xAxisMargin
    }
    
    var yAxisMax: CGFloat {
        return graphFrame!.yAxisMax
    }
    
    // indexからX座標を取る
    func getXPoint(index: Int) -> CGFloat {
        return CGFloat(index) * xAxisMargin
    }
    
    // 値からY座標を取る
    func getYPoint(yOrigin: CGFloat) -> CGFloat {
        let y: CGFloat = yOrigin/yAxisMax * graphHeight
        return graphHeight - y
    }
}


class LineStroke: UIView, GraphStroke {
    var graphPoints = [CGFloat?]()
    var color = UIColor.whiteColor()
    
    convenience init(graphPoints: [CGFloat?]) {
        self.init()
        self.graphPoints = graphPoints
    }
    
    override func didMoveToSuperview() {
        if self.graphFrame == nil { return }
        self.frame.size = self.graphFrame!.area.frame.size
        self.area.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let graphPath = UIBezierPath()
        
        graphPath.moveToPoint(
            CGPoint(x: getXPoint(0), y: getYPoint(graphPoints[0] ?? 0))
        )
        
        for graphPoint in graphPoints.enumerate() {
            if graphPoint.element == nil { continue }
            let nextPoint = CGPoint(x: getXPoint(graphPoint.index),
                                    y: getYPoint(graphPoint.element!))
            graphPath.addLineToPoint(nextPoint)
        }
        
        graphPath.lineWidth = 2.0
        color.setStroke()
        graphPath.stroke()
        graphPath.closePath()
    }
}



