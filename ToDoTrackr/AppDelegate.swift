//
//  AppDelegate.swift
//  ToDoTrackr
//
//  Created by Admin on 16.01.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import RealmSwift
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //brave new Realm
        do {
            _ = try Realm()
            
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        //Fabric
        Fabric.with([Crashlytics.self])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //pause
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //save
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //resume
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //restart
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //exit
    }
    

}

