//
//  AppDelegate.swift
//  ToDoTrackr
//
//  Created by Admin on 16.01.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
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
        self.saveContext()
    }
    
    //MARK: - Core Data operations
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ToDoDataModel")
        container.loadPersistentStores(completionHandler: {
            (storedDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved database error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error when saving context \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

