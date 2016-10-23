//
//  ViewController.swift
//  accountsTittleQuiz
//
//  Created by 矢吹祐真 on 2016/09/24.
//  Copyright © 2016年 矢吹祐真. All rights reserved.
//

import UIKit
import NCMB
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    

    @IBOutlet var label:UILabel!
    
    var name:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.cloudsColor()

        let nameUd = NSUserDefaults.standardUserDefaults()
        name = (nameUd.objectForKey("password") as? String)!
//        label.text = String(name
        
        
        // AdMob広告設定
        var bannerView: GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize:kGADAdSizeBanner)
        bannerView.frame.origin = CGPointMake(0, self.view.frame.size.height - bannerView.frame.height)
        bannerView.frame.size = CGSizeMake(self.view.frame.width, bannerView.frame.height)
        // AdMobで発行された広告ユニットIDを設定
        bannerView.adUnitID = "ca-app-pub-1517101049342722/5843621696"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
        // テスト用の広告を表示する時のみ使用（申請時に削除）
         gadRequest.testDevices = ["6252A56D-58DD-4DDB-A80B-21F57DA3CF32"]
        bannerView.loadRequest(gadRequest)
        self.view.addSubview(bannerView)
        print(bannerView.frame.height)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

   
}

