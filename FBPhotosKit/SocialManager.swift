//
//  SocialManager.swift
//  FBPhotos
//
//  Created by kyo__hei on 2014/10/04.
//  Copyright (c) 2014年 kyo__hei. All rights reserved.
//

import UIKit
import Foundation
import Accounts

/**
*  ソーシャルアカウントへのアクセスなどを管理するシングルトンクラス
*/
public class SocialManager: NSObject {
    public typealias RequestAccessCompletionHandler = ([AnyObject]?, NSError!) -> Void
    
    /**************************************************************************/
    // MARK: - Types
    /**************************************************************************/
    struct Error {
        static let errorDomain = "SocialManager"
        struct Code {
            static let userNotGranted = 1
            static let notSupportedType = 2
        }
    }
    
    /**************************************************************************/
    // MARK: - Properties
    /**************************************************************************/
    
    private let fbAppID = "268369639954008"
    private let store = ACAccountStore()
    private var fbAccount: ACAccount?
    
    /**************************************************************************/
    // MARK: - Initializer
    /**************************************************************************/
    private override init() {
        
    }
    
    public class var sharedManager : SocialManager {
    struct Static {
        static let instance : SocialManager = SocialManager()
        }
        return Static.instance
    }
    
    
    /**************************************************************************/
    // MARK: - Public Method
    /**************************************************************************/
    
    public func accountsWithAccountTypeIdentifier(id: NSString) -> [AnyObject]? {
        let accountType = store.accountTypeWithAccountTypeIdentifier(id)
        let accounts = store.accountsWithAccountType(accountType)
        return accounts
    }
    
    /**
    各種ソーシャルアカウントへのアクセス権限を確認する
    
    :param: id ソーシャルアカウントのID
    
    :returns: アクセス権限
    */
    public func accessGrantedWithAccountTypeIdentifier(id: NSString) -> Bool {
        let accountType = store.accountTypeWithAccountTypeIdentifier(id)
        return accountType.accessGranted
    }
    
    /**
    各種ソーシャルアカウントへのアクセスを要求する
    
    :param: id         ソーシャルアカウントのID
    :param: completion ユーザが返答した際のコールバック
    */
    public func requestAccessWithAccountTypeIdentifier(id: NSString, completion: RequestAccessCompletionHandler) {
        let accountType = store.accountTypeWithAccountTypeIdentifier(id)
        var options: [NSObject : AnyObject]?
        
        if id.isEqualToString(ACAccountTypeIdentifierFacebook) {
           let permissions = ["email"]
            options = [ACFacebookAppIdKey: fbAppID,
                ACFacebookPermissionsKey: permissions,
                ACFacebookAudienceKey: ACFacebookAudienceFriends]
        } else {
            let error = NSError(domain: Error.errorDomain, code: Error.Code.notSupportedType, userInfo: nil)
            completion(nil, error)
        }
        
        store.requestAccessToAccountsWithType(accountType, options: options) { (granted: Bool, error:
            NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if error != nil {
                    completion(nil, error)
                    return
                } else if granted == false {
                    let grantError = NSError(domain: Error.errorDomain, code: Error.Code.userNotGranted, userInfo: nil)
                    completion(nil, grantError)
                } else {
                    let accounts = self.store.accountsWithAccountType(accountType)
                    self.fbAccount = accounts?[0] as? ACAccount
                    completion(accounts, nil)
                }
            })
        }
    }
    
    public func requestAboutMe() {
        
    }
}