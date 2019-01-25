//
//  AppDelegate.swift
//  VersionsTracker
//
// Copyright (c) 2016 Martin Stemmle
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import VersionsTracker

let iDontMindSingletons = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard NSClassFromString("XCTest") == nil else {
            // skip AppVersionTracker setup to unit tests take care of it
            return true
        }
        
        print("☀️ W E L C O M E  🤗")
        
        if iDontMindSingletons {
            // initialize AppVersionTracker once
            VersionsTracker.initialize(trackAppVersion: true, trackOSVersion: true)
            // access the AppVersionTracker.sharedInstance anywhere you need
            printVersionInfo(VersionsTracker.sharedInstance.osVersion, headline: "OS VERSION")
            printVersionInfo(VersionsTracker.sharedInstance.appVersion, headline: "APP VERSION (via AppDelegate)")
        }
        else {
            // make sure to update the version history once once during you app's life time
            VersionsTracker.updateVersionHistories(trackAppVersion: true, trackOSVersion: true)
            // see ViewController.viewDidLoad() for usage of tracked version
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// MARK: - Helpers 

func printVersionInfo(_ versionTracker: VersionTracker, headline: String) {
    print("")
    print("")
    print(headline)
    print([String](repeating: "-", count: headline.count).joined(separator: ""))
    print("")
    printVersionChange(versionTracker)
    print("⌚️Current version is from \(versionTracker.currentVersion.installDate)")
    print("  previous version is from \((versionTracker.previousVersion?.installDate.description ?? "- oh, there is no")!)")
    printVersionHistory(versionTracker)
}

func printVersionChange(_ versionTracker: VersionTracker) {
    switch versionTracker.changeState {
    case .installed:
        print("🆕 Congratulations, the app is launched for the very first time")
    case .notChanged:
        print("🔄 Welcome back, nothing as changed since the last time")
    case .updated(let previousVersion):
        print("🆙 The app was updated making small changes: \(previousVersion) -> \(versionTracker.currentVersion)")
    case .upgraded(let previousVersion):
        print("⬆️ Cool, its a new version: \(previousVersion) -> \(versionTracker.currentVersion)")
    case .downgraded(let previousVersion):
        print("⬇️ Oohu, looks like something is wrong with the current version to make you come back here: \(previousVersion) -> \(versionTracker.currentVersion)")
    }
}

func printVersionHistory(_ versionTracker: VersionTracker) {
    let clocks = ["🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚", "🕛"]
    print("")
    print("Version history:")
    for (index, version) in versionTracker.versionHistory.enumerated() {
        print("\(clocks[index % clocks.count]) \(version.installDate) \(version)")
    }
}
