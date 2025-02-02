//
//  AppDelegate.swift
//  accountsTittleQuiz
//
//  Created by 矢吹祐真 on 2016/09/24.
//  Copyright © 2016年 矢吹祐真. All rights reserved.
//

import UIKit
import NCMB


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyboard: UIStoryboard = StoryboardHelper.adjust()
        window!.rootViewController = storyboard.instantiateInitialViewController()! as UIViewController
        self.window?.makeKeyAndVisible()
        
        
        NCMB.setApplicationKey("3d114916631adc5c30e9fb0594068c28f8a959b7b788092234bb21c0a41ef562", clientKey: "efe1e94198591414ae4cedf736958b1d7684be615616b2cdb0de6e4e1529f6d9")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

