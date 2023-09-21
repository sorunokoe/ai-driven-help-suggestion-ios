//
//  BehaviourAnalyticsService.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import Foundation

final class BehaviourAnalyticsService {
    
    enum BehaviourLabel: Int {
        case normal = 0,
             checkIn = 1,
             changeBooking = 2,
             cancelationAndRefund = 3,
             other = 4
        
        var title: String {
            switch self {
            case .normal:
                return "Help"
            case .checkIn:
                return "Do you need help with check-in?"
            case .changeBooking:
                return "Do you need help with changing booking?"
            case .cancelationAndRefund:
                return "Do you need help with cancelation and refund?"
            case .other:
                return "Do you need any help?"
            }
        }
    }
    
    struct UserData {
        var flights: [FlightModel] = []
    }
    
    struct BehaviorData: CustomStringConvertible {
        let id: UUID = UUID()
        let event: Event
        let date: Date = Date()
        var duration: TimeInterval?
        let params: [String: Any]
        
        var description: String {
            return "\(event.description) | \((duration ?? -1).rounded()) seconds"
        }
    }
    
    enum Event: Equatable {
        case visit(Page), appActive, appInBackgroundState
        
        var description: String {
            switch self {
            case let .visit(page):
                return "\(page.description)"
            case .appInBackgroundState:
                return "The App entered into Background state"
            case .appActive:
                return "The App is Active"
            }
        }
        
    }
    
    enum Page {
        case home, bookFlight, checkIn, successfullPage, failurePage,
             help, helpCheckIn, helpChangeBooking, helpCancelationAndRefund, helpOther
        
        var description: String {
            switch self {
            case .home:
                return "Home page"
            case .bookFlight:
                return "Book Flight page"
            case .successfullPage:
                return "Successfull page"
            case .failurePage:
                return "Failure page"
            case .help:
                return "Help page"
            case .checkIn:
                return "Check In page"
            case .helpCheckIn:
                return "Help Check-in page"
            case .helpChangeBooking:
                return "Help Change Booking page"
            case .helpCancelationAndRefund:
                return "Help Cancelation and refund"
            case .helpOther:
                return "Help Other"
            }
        }
        
    }
    
    static let shared = BehaviourAnalyticsService()
    
    private init() {}
    
    private var storage: [BehaviorData] = []
    
    private var lastPage: Page?
    private var isFirstOpen: Bool = true
    
    var properties: UserData = UserData()
    
    func event(_ type: Event) {
        switch type {
        case .appActive:
            if let page = lastPage {
                record(type)
                record(.visit(page))
            }
            isFirstOpen = false
        case let .visit(page):
            if !isFirstOpen {
                record(type)
            }
            lastPage = page
        default:
            record(type)
        }
    }
    
    private func record(_ event: Event) {
        let data = BehaviorData(event: event,
                                params: ["flights" : Default.flightModel])
        if storage.count > 0 {
            storage[storage.count-1].duration = Date().timeIntervalSince(storage[storage.count-1].date)
        }
        storage.append(data)
        
        MLService.shared.predictBehaviour()
        print("- - - - - - - - - -")
    }
    
    func prepareData() -> [String: String] {
        let cleanStorage = storage.filter { $0.duration != nil && $0.event != .appActive && $0.event != .appInBackgroundState }
        
        guard cleanStorage.count > 3 else { return [:] }
        
        let homePageVisits = cleanStorage.filter { $0.event == .visit(.home) }.count
        let flightPageVisits = cleanStorage.filter { $0.event == .visit(.bookFlight) }.count
        let checkinPageVisits = cleanStorage.filter { $0.event == .visit(.checkIn) }.count
        let successfullPageVisits = cleanStorage.filter { $0.event == .visit(.successfullPage) }.count
        let failurePageVisits = cleanStorage.filter { $0.event == .visit(.failurePage) }.count
        let helpPageVisits = cleanStorage.filter { $0.event == .visit(.help) }.count
        let checkInHelpVisits = cleanStorage.filter { $0.event == .visit(.helpCheckIn) }.count
        let changeBookingHelpVisits = cleanStorage.filter { $0.event == .visit(.helpChangeBooking) }.count
        let cancelationAndRefundHelpVisits = cleanStorage.filter { $0.event == .visit(.helpCancelationAndRefund) }.count
        let otherHelpVisits = cleanStorage.filter { $0.event == .visit(.helpOther) }.count
        
        let filteredStorage = cleanStorage.filter {
            $0.event != .visit(.help) &&
            $0.event != .visit(.helpCheckIn) &&
            $0.event != .visit(.helpChangeBooking) &&
            $0.event != .visit(.helpCancelationAndRefund) &&
            $0.event != .visit(.helpOther)
        }
        
        let firstData = filteredStorage.count > 1 ? filteredStorage[0] : nil
        let secondData = filteredStorage.count > 2 ? filteredStorage[1] : nil
        let thirdData = filteredStorage.count > 3 ? filteredStorage[2] : nil
        let lastData = filteredStorage.last
        
        let firstPage = firstData?.event.description ?? "-"
        let firstPageDuration = firstData?.duration ?? 0
        let secondPage = secondData?.event.description ?? "-"
        let secondPageDuration = secondData?.duration ?? 0
        let thirdPage = thirdData?.event.description ?? "-"
        let thirdPageDuration = thirdData?.duration ?? 0
        
        let lastPage = lastData?.event.description ?? "-"
        let lastPageDuration = lastData?.duration ?? 0
        
        return [
            "first_page": firstPage,
            "first_duration": "\(firstPageDuration)",
            "second_page": secondPage,
            "second_duration": "\(secondPageDuration)",
            "third_page": thirdPage,
            "third_duration": "\(thirdPageDuration)",
            "last_page": lastPage,
            "last_duration": "\(lastPageDuration)",
            "home_page_visits": "\(homePageVisits)",
            "flight_page_visits": "\(flightPageVisits)",
            "check_in_page_visits": "\(checkinPageVisits)",
            "successfull_page_visits": "\(successfullPageVisits)",
            "failure_page_visits": "\(failurePageVisits)",
            "help_page_visits": "\(helpPageVisits)",
            "check_in_help_visits": "\(checkInHelpVisits)",
            "change_booking_help_visits": "\(changeBookingHelpVisits)",
            "cancelation_and_refund_help_visits": "\(cancelationAndRefundHelpVisits)",
            "other_help_visits": "\(otherHelpVisits)"
        ]
    }
    
    func label(_ type: BehaviourLabel) {
        var data = prepareData()
        data["class"] = "\(type.rawValue)"
        FileService.createCSVX(from: data)
        
        clean()
    }
    
    func clean() {
        storage.removeAll()
    }
    
}
