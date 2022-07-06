//
//  AppDelegate.swift
//  Refreshable-ScrollView-Example
//
//  Created by Mac on 06/07/22.
//

import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let content = VStack {
            ForEach(0..<10) { i in
                Text("User \(i)").padding()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: RefreshableScrollViewView(contentView: content, onRefresh: { print("Updating...") }))
        window?.makeKeyAndVisible()
        return true
    }
}
