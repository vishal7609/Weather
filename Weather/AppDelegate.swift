//
//  AppDelegate.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    static func initMasterData() {
        CityRepository.saveAllCities()
        CountryCode.shared.initalizeDic()
    }
}

