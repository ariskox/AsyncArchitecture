//
//  AppDelegate.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation
import UIKit
import Dependencies

class AppDelegate: NSObject, UIApplicationDelegate {

    @Dependency(\.networkMonitor) var networkMonitor
    
    private(set) var viewModel: ContentViewModel = ContentViewModel()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        networkMonitor.start()

        return true
    }
}
