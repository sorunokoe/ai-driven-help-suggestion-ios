//
//  SearchPage.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import SwiftUI

struct FlightItemView: View {
    
    var model: FlightModel
    
    var body: some View {
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
            HStack {
                Text(model.checkInState.title)
                    .foregroundColor(.white)
                Spacer()
                switch model.checkInState {
                case .available:
                    Image(systemName: "arrow.forward")
                        .foregroundColor(.white)
                case .notAvailable:
                    Image(systemName: "clock.badge.fill")
                        .foregroundColor(.white)
                case .checkedIn:
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding(8)
            .background(.blue)
            .clipShape(.capsule)
            
        }
    }
    
}

struct SearchPage: View {
    
    @State var from: String = "Frankfurt am Main (FRA)"
    @State var to: String = "Zurich (ZRH)"
    @State var fromDate: String = "16.12.2023"
    @State var toDate: String = "03.01.2024"
    
    @Binding var path: NavigationPath
    
    @State var model: FlightModel? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                // MARK: Flights
                if let model = model {
                    VStack(alignment: .leading) {
                        Text("Flights")
                            .font(.title)
                            .padding([.leading, .trailing], 32)
                        VStack(alignment: .leading, spacing: 12) {
                            FlightItemView(model: model)
                                .frame(height: 200)
                                .padding([.leading, .trailing], 16)
                                .border(Color("textColor"), width: 1)
                                .onTapGesture {
                                    if model.checkInState == .available {
                                        path.append(Route.checkIn(model))
                                    }
                                }
                        }
                        .padding([.leading, .trailing], 16)
                    }
                }
                
                // MARK: Search
                VStack(alignment: .leading, spacing: 12) {
                    Text("Search")
                        .font(.title)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("From")
                                .font(.headline)
                            TextField("Country, city or airport", text: $from)
                                .font(.footnote)
                        }
                        VStack(alignment: .leading) {
                            Text("To")
                                .font(.headline)
                            TextField("Country, city or airport", text: $to)
                                .font(.footnote)
                        }
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Depart")
                                .font(.headline)
                            TextField("Add date", text: $fromDate)
                                .font(.footnote)
                        }
                        VStack(alignment: .leading) {
                            Text("Return")
                                .font(.headline)
                            TextField("Add date", text: $toDate)
                                .font(.footnote)
                        }
                    }
                    
                    Spacer(minLength: 12)
                    
                    Text("Search")
                        .padding(16)
                        .padding([.leading, .trailing], 48)
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(.capsule)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            path.append(Route.flight)
                        }
                    
                }
                .padding(32)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                configure()
            }
        }
    }
    
    func configure() {
        model = Int.random(in: 1...2) % 2 == 0 ? Default.flightModel : nil
        BehaviourAnalyticsService.shared.event(.visit(.home))
    }
    
}

#Preview {
    SearchPage(path: .constant(NavigationPath()))
}
