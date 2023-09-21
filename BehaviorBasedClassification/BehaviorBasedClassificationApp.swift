//
//  BehaviorBasedClassificationApp.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 20.09.23.
//

import SwiftUI

enum Route: Hashable {
    case search, flight, success(String), failure, checkIn(FlightModel), help, helpDetail(HelpType)
}

@main
struct BehaviorBasedClassificationApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @State var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                PageView(content: SearchPage(path: $path))
                    .environmentObject(MLService.shared)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .search:
                            PageView(content: SearchPage(path: $path))
                                .environmentObject(MLService.shared)
                        case .flight:
                            PageView(content: FlightView(model: Default.flightModel, path: $path))
                                .environmentObject(MLService.shared)
                        case let .success(text):
                            SuccessPage(text: text, path: $path)
                        case .failure:
                            FailurePage(path: $path)
                        case let .checkIn(model):
                            PageView(content: CheckInPage(path: $path, model: model))
                                .environmentObject(MLService.shared)
                        case .help:
                            HelpPage()
                        case let .helpDetail(type):
                            HelpPageDetail(type: type)
                        }
                    }
            }
            .onChange(of: scenePhase, initial: false) { _, newPhase in
                if newPhase == .active {
                    print("Active")
                    BehaviourAnalyticsService.shared.event(.appActive)
                } else if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .background {
                    print("Background")
                    BehaviourAnalyticsService.shared.event(.appInBackgroundState)
                }
            }
            
        }
    }
    
    
    
}
