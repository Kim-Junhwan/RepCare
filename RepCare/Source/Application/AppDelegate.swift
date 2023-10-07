//
//  AppDelegate.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/09/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        copyRealm()
        return true
    }
    
    func copyRealm() {
        guard let realmURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("repcare.realm", conformingTo: .data) else { return }
        let realmPath: String
        if #available(iOS 16.0, *) {
            realmPath = realmURL.path()
        } else {
            realmPath = realmURL.path
        }
        if !FileManager.default.fileExists(atPath: realmPath) {
            guard let bundleRealmURL = Bundle.main.url(forResource: "repcare", withExtension: ".realm") else {return}
            do {
                try FileManager.default.copyItem(at: bundleRealmURL, to: realmURL)
            } catch {
                fatalError()
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

