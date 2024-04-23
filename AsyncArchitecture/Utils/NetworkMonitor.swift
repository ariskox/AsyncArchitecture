//
//  NetworkMonitor.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation
import Dependencies
import Network

@MainActor
class NetworkMonitor: ObservableObject {
    @Published private(set) var isConnected = true
    @Published private(set) var isCellular = false

    private let nwMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue.global()
    private var isStarted = false

    init() {
        isConnected = false
    }

    func start() {
        guard !isStarted else { return }
        isStarted = true

        nwMonitor.start(queue: workerQueue)
        nwMonitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            Task {
                await self.update(
                    isConnected: path.status == .satisfied,
                    isCellular: path.usesInterfaceType(.cellular)
                )
            }
        }
    }

    private func update(isConnected: Bool, isCellular: Bool) {
        self.isConnected = isConnected
        self.isCellular = isCellular

    }

    func stop() {
        isStarted = false
        nwMonitor.cancel()
    }
}

extension NetworkMonitor: DependencyKey {
    nonisolated static var liveValue: NetworkMonitor {
        MainActor.assumeIsolated {
            return NetworkMonitor()
        }
    }
}

extension DependencyValues {
    var networkMonitor: NetworkMonitor {
        get { self[NetworkMonitor.self] }
        set { self[NetworkMonitor.self] = newValue }
    }
}

