//
//  AppDelegate.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/25/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit
import Parse
import IQKeyboardManagerSwift
import OneSignal
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Notifiaction SetUp
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: \(granted)")
        }
        
        
        // Parse setup
        let configuration = ParseClientConfiguration {
            $0.applicationId = "86a6e3ca2406975a7dbfd87fdb0e780657375c5b"
            $0.clientKey = "734d215c6eab358849480458dcd2fdca797f9fed"
            $0.server = "http://ec2-54-153-52-150.us-west-1.compute.amazonaws.com/parse"
        }
        Parse.initialize(with: configuration)
        
        
        // IQKeyboard set up
        IQKeyboardManager.sharedManager().enable = true
        
        //OneSignal push notification setup
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        //OneSignal.setLogLevel(.LL_DEBUG, visualLevel: .LL_DEBUG)
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "36374bf7-8c38-44d3-ab2d-3000f1d34ef3",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    



}

