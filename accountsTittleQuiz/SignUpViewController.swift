//
//  SignUpViewController.swift
//  SwiftLoginApp
//
//  Created by Natsumo Ikeda on 2016/05/26.
//  Copyright © 2016年 NIFTY Corporation. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController, UITextFieldDelegate {
    // User Name
    @IBOutlet weak var userNameTextField: UITextField!
    // Password
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var passwordTextField_second: UITextField!
    
    // errorLabel
    @IBOutlet weak var errorLabel: UILabel!
    
    var name:String!
    let nameUd = NSUserDefaults.standardUserDefaults()
    var thisIsNotFirstTime:Bool = false
    
    // 画面表示時に実行される
    override func viewDidLoad() {
        super.viewDidLoad()
        // Passwordをセキュリティ入力に設定
//        self.passwordTextField.secureTextEntry = true
//        self.passwordTextField_second.secureTextEntry = true

        userNameTextField.placeholder = "ユーザー名"
        errorLabel.text = ""
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        thisIsNotFirstTime = userAlreadyExist()
        print("これは初回ではない\(thisIsNotFirstTime)")
        if thisIsNotFirstTime != false{
            name = (nameUd.objectForKey("password") as? String)!
            print("username:\(name)")
            signUpDone()
        }
    }
    
    //Userdefaultsにobject(ユーザー名)が保存されていればtrueを返す
    func userAlreadyExist() -> Bool {
        
        if (nameUd.objectForKey("password") != nil) {
            return true
        }
        
        return false
    }
    
    // SignUpボタン押下時の距離
    @IBAction func signUpBtn(sender: UIButton) {
        
        //TextFieldをnameに入れておく(Userdefaultsに後で保存するため)
        self.name = self.userNameTextField.text!
        print(self.name)
        
        // キーボードを閉じる
        closeKeyboad()
        
        // 入力確認
        if self.userNameTextField.text!.isEmpty
        {
            self.errorLabel.text = "名前を入力してください"
            // TextFieldを空に
            self.cleanTextField()
            
            return
            
        }
        
        //NCMBUserのインスタンスを作成
        let user = NCMBUser()
        //ユーザー名を設定
        user.userName = self.userNameTextField.text
        //パスワードを設定
        user.password = "password"//self.passwordTextField.text
        
        //会員の登録を行う
        user.signUpInBackgroundWithBlock{(error: NSError!) in


            // TextFieldを空に
            self.cleanTextField()
            
            if error != nil {
                // 新規登録失敗時の処理
                self.errorLabel.text = "そのユーザー名はすでに使われております"
                print("ログインに失敗しました:\(error.code)")
                
                
            } else {
                // 新規登録成功時の処理
                self.performSegueWithIdentifier("signUpDone", sender: self)
                print("ログインに成功しました:\(user.objectId)")
                
            }
            
        }
        
        //Userdefaultsにnameを保存
        nameUd.setObject(name, forKey: "password")
        //Userdefaultsに保存されてか確認
        name = (nameUd.objectForKey("password") as? String)!
        print("username:\(name)で登録Done")
        
    }
    
    // 背景タップするとキーボードを隠す
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
    }
    
    // TextFieldを空にする
    func cleanTextField(){
        userNameTextField.text = ""
//        passwordTextField.text = ""
//        passwordTextField_second.text = ""
        
    }
    
    // errorLabelを空にする
    func cleanErrorLabel(){
        errorLabel.text = ""
        
    }
    
    // キーボードを閉じる
    func closeKeyboad(){
        userNameTextField.resignFirstResponder()
//        passwordTextField.resignFirstResponder()
//        passwordTextField_second.resignFirstResponder()
        
    }
    
    func signUpDone(){
        performSegueWithIdentifier("signUpDone", sender: nil)
        print("SignUpDone")
    }
    
}