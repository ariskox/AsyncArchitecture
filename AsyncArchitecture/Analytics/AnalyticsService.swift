//
//  AnalyticsService.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation
import Dependencies

actor AnalyticsService {
    private struct MyUnderlyingService { 
        var key: String
    }
    private var myUnderlyingService: MyUnderlyingService!

    init(key: String) {
            myUnderlyingService = MyUnderlyingService(key: key)
    }
    
    func sendEvent(_ event: String) async {
        print("Sending event: \(event)")
    }

}

extension AnalyticsService: DependencyKey {
    static var liveValue: AnalyticsService {
        return AnalyticsService(key: "1234")
    }
}

extension DependencyValues {
    var analyticsService: AnalyticsService {
        get { self[AnalyticsService.self] }
        set { self[AnalyticsService.self] = newValue }
    }
}

