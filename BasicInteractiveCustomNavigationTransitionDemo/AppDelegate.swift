//
//  AppDelegate.swift
//  BasicInteractiveCustomNavigationTransitionDemo
//
//  Created by 张威 on 16/7/2.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.rootViewController = UINavigationController(rootViewController: MainViewController())
    window?.makeKeyWindow()
    
    return true

  }

}

