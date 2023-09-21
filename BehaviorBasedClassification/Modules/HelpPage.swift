//
//  HelpPage.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import SwiftUI

enum HelpType: Identifiable, CaseIterable {
    case checkIn, changeBooking, cancellationAndRefund, other
    
    var id: UUID {
        return UUID()
    }
    
    var iconName: String {
        switch self {
        case .checkIn:
            return "person.crop.circle.badge.checkmark"
        case .changeBooking:
            return "calendar"
        case .cancellationAndRefund:
            return "person.2.gobackward"
        case .other:
            return "aqi.medium"
        }
    }
    
    var text: String {
        switch self {
        case .checkIn:
            return "Check-in"
        case .changeBooking:
            return "Change booking"
        case .cancellationAndRefund:
            return "Cancelation and refund"
        case .other:
            return "Other"
        }
    }
    
    var label: BehaviourAnalyticsService.BehaviourLabel {
        switch self {
        case .checkIn:
            return .checkIn
        case .changeBooking:
            return .changeBooking
        case .cancellationAndRefund:
            return .cancelationAndRefund
        case .other:
            return .other
        }
    }
    
    var page: BehaviourAnalyticsService.Page {
        switch self {
        case .checkIn:
            return .helpCheckIn
        case .changeBooking:
            return .helpChangeBooking
        case .cancellationAndRefund:
            return .helpCancelationAndRefund
        case .other:
            return .helpOther
        }
    }
}

struct HelpPage: View {
    
    private var types: [HelpType] = HelpType.allCases
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Help center")
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(types) { type in
                        NavigationLink(value: Route.helpDetail(type)) {
                            HStack {
                                Image(systemName: type.iconName)
                                Text(type.text)
                                Spacer()
                                Image(systemName: "arrow.forward")
                            }
                            .padding(16)
                            .background(.blue.opacity(0.25))
                            .clipShape(.capsule)
                        }
                    }
                }
                
            }
            .padding(32)
        }
        .onAppear {
            configure()
        }
    }
    
    func configure() {
        BehaviourAnalyticsService.shared.event(.visit(.help))
    }
    
}

#Preview {
    HelpPage()
}
