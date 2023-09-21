//
//  FlightView.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import SwiftUI

struct FlightModel: Hashable, Encodable {
    
    enum CheckInState: Hashable, Encodable {
        case available, notAvailable, checkedIn
        
        var title: String {
            switch self {
            case .available:
                return "Check-in is available"
            case .notAvailable:
                return "Check-in is not available"
            case .checkedIn:
                return "You're checked in"
            }
        }
    }
    
    let id: UUID = UUID()
    let stops: Int = 0
    let fromTime: String
    let fromCity: String
    let toTime: String
    let toCity: String
    let duration: String
    let operatedCompany: String
    let price: String
    
    var checkInState: CheckInState
}

struct FlightView: View {
    
    let model: FlightModel
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        ZStack {
                            Rectangle()
                                .frame(height: 1)
                            Text("\(model.stops) stops")
                                .font(.caption)
                                .padding(.bottom)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(model.fromTime)
                                        .font(.title2)
                                    Text(model.fromCity)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(model.toTime)
                                        .font(.title2)
                                    Text(model.toCity)
                                }
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Duration: \(model.duration)")
                            Text("Operated by \(model.operatedCompany)")
                        }
                    }
                    .padding(.leading, 32)
                    .padding(.trailing, 8)
                    Rectangle()
                        .frame(width: 1)
                    VStack {
                        Text("EUR")
                        Text("\(model.price)")
                            .font(.title)
                        Text("Economy")
                    }
                    .padding(.leading, 8)
                    .padding([.trailing], 32)
                }
                .frame(height: 160)
                .border(.blue, width: 1)
                .padding()
                
                Text("Select")
                    .padding(16)
                    .padding([.leading, .trailing], 48)
                    .foregroundColor(.white)
                    .background(.blue)
                    .clipShape(.capsule)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        if Int.random(in: 1...2) % 2 == 0 {
                            path.append(Route.success("Your flight has been successfully booked!"))
                        } else {
                            path.append(Route.failure)
                        }
                    }
            }
        }
        .onAppear {
            configure()
        }
    }
    
    func configure() {
        BehaviourAnalyticsService.shared.event(.visit(.bookFlight))
    }
    
}

#Preview {
    FlightView(model: Default.flightModel, path: .constant(NavigationPath()))
}
