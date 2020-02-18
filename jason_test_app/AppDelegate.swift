//
//  AppDelegate.swift
//  jason_test_app
//
//  Created by Jason.Chang on 2020/2/17.
//  Copyright © 2020 Jason.Chang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let QG = QGSdk.getSharedInstance()
        #if DEBUG
            QG?.onStart("95125409e1db46a88c5c", withAppGroup:"group.com.appier.jason.jason-test-app.notification", setDevProfile: true)
        #else
            QG?.onStart("95125409e1db46a88c5c", withAppGroup:"group.com.appier.jason.jason-test-app.notification", setDevProfile: false)
        #endif
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            QGSdk.setCarouselNotificationCategoryWithNextButtonTitle("Play", withOpenAppButtonTitle: "Checkout")
            if #available(iOS 12.0, *) {
                options.update(with: .provisional)
            }
            center.requestAuthorization(options: [.badge, .carPlay, .alert, .sound]) { (granted, error) in
                print("Granted: \(granted), Error: \(error)")
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        return true
    }
    
    // sending the token to the server
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let QG = QGSdk.getSharedInstance()
        print("My token is: \(deviceToken.description)")
        QG?.setToken(deviceToken as Data)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to get token, error: \(error.localizedDescription)")
    }
    
    // To handle the push notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let QG = QGSdk.getSharedInstance()
        // to enable track click on notification
        QG?.application(application, didReceiveRemoteNotification: userInfo)
        completionHandler(UIBackgroundFetchResult.noData)
    }
    
    // The method will be called on the delegate only if the application is in the foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        QGSdk.getSharedInstance().userNotificationCenter(center, willPresent: notification)
        completionHandler([.alert, .badge, .sound]);
    }
    
    // when users interact with the push notification
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler:@escaping() -> Void) {
        QGSdk.getSharedInstance().userNotificationCenter(center, didReceive: response)
        completionHandler()
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

