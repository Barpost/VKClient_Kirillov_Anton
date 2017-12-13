//
//  AppDelegate.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import Firebase
import WatchConnectivity

let userDefaults = UserDefaults.standard
let defaults = UserDefaults(suiteName: "group.VKNews")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var splashDelay = false
    var connectivityHandler : ConnectivityHandler?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        if WCSession.isSupported() {
            self.connectivityHandler = ConnectivityHandler()
        } else {
            print("WCSession not supported (f.e. on iPad).")
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let backgroundFetcher = BackgroundFetchAssist.shared
        print("Вызов обновления данных в фоне \(Date())")
        
        if let lastUpdate = backgroundFetcher.lastUpdate, abs(lastUpdate.timeIntervalSinceNow) < 30 {
            print("Фононвое обновление не требуется, так как последний раз данные обновлялись \(abs(lastUpdate.timeIntervalSinceNow)) секунд назад (меньше 30)")
            completionHandler(.noData)
            return
        }
        backgroundFetcher.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        backgroundFetcher.timer?.schedule(deadline: .now(), repeating: .seconds(29), leeway: .seconds(1))
        backgroundFetcher.timer?.setEventHandler {
            print("Говорим системе, что не смогли загрузить данные")
            completionHandler(.failed)
            return
        }
        backgroundFetcher.timer?.resume()
        
        APIService.shared.getFriendsRequests()
        
        let requestNotification = Notification.Name("requestNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(addBadge(notification:)), name: requestNotification, object: nil)
        
        backgroundFetcher.timer = nil
        backgroundFetcher.lastUpdate = Date()
        completionHandler(.newData)
        print("Данные загружены")
    }
    
    @objc func addBadge(notification: Notification) {
        let application = UIApplication.shared
        DispatchQueue.main.async {
            application.applicationIconBadgeNumber = userDefaults.integer(forKey: "RequestsCount")
        }
    }
}
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

