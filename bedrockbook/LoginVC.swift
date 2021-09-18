//
//  LoginVC.swift
//  bedrockbook
//
//  Created by QUANG on 7/27/18.
//  Copyright © 2018 Nguyenxloc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 150, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with Facebook")
        
        showEmailAddress()
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signInAndRetrieveData(with: credentials) { (userData, err) in
            if let err = err {
                print("Something's wrong: ", err)
                return
            }
            print("Sucessfully log firebase through facebook: ", userData?.user.uid ?? "")
            userUid = userData?.user.uid ?? ""
            userDefaults.set(userUid, forKey: defaultsKeys.userUid)
            print(userData?.user.displayName ?? "")
            userName = userData?.user.displayName ?? ""
            
            userDefaults.set(userName, forKey: defaultsKeys.userName)
            userDefaults.set(userUid, forKey: defaultsKeys.userUid)
            
            self.moveToMainVC()
        }
    }
    
    func moveToMainVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UINavigationController = storyboard.instantiateViewController(withIdentifier: "mainVC") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
}
