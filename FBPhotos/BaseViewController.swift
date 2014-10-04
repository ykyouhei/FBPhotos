//
//  BaseViewController.swift
//  FBPhotos
//
//  Created by kyo__hei on 2014/10/04.
//  Copyright (c) 2014年 kyo__hei. All rights reserved.
//

import UIKit
import Accounts

/**
*  ログイン後の画面のベースクラス
*/
class BaseViewController: UIViewController {
    
    /**************************************************************************/
    // MARK: - Properties
    /**************************************************************************/
    
    var account: ACAccount!
    
    /**************************************************************************/
    // MARK: - View Life Cycle
    /**************************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleAccountStoreDidChange:", name: ACAccountStoreDidChangeNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    /**************************************************************************/
    // MARK: - Observer
    /**************************************************************************/
    
    /**
    アカウントの認証情報が変更された場合に呼ばれる
    
    :param: notification NSNotification
    */
    private func handleAccountStoreDidChange(notification: NSNotification) {
        let loginVC = storyboard?.instantiateViewControllerWithIdentifier(MainStoryboard.ViewControllerIdentifiers.loginViewController) as LoginViewController
        navigationController?.setViewControllers([loginVC], animated: true)
    }
    

}
