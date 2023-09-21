//
//  CheckInPage.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import SwiftUI

struct CheckInPage: View {
    
    @Binding var path: NavigationPath
    @State var firstName: String = "YESKENDIR"
    @State var lastName: String = "SALGARA"
    let model: FlightModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                Text("Check in")
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 8){
                    VStack(alignment: .leading) {
                        Text("First name")
                            .font(.headline)
                        TextField("First name", text: $firstName)
                            .font(.footnote)
                            .padding(16)
                            .background(.secondary.opacity(0.15))
                            .clipShape(.capsule)
                    }
                    VStack(alignment: .leading) {
                        Text("Last name")
                            .font(.headline)
                        TextField("Last name", text: $lastName)
                            .font(.footnote)
                            .padding(16)
                            .background(.secondary.opacity(0.15))
                            .clipShape(.capsule)
                    }
                }
                
                Text("Continue")
                    .padding(16)
                    .padding([.leading, .trailing], 48)
                    .foregroundColor(.white)
                    .background(.blue)
                    .clipShape(.capsule)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        if Int.random(in: 1...2) % 2 == 0 {
                            path.append(Route.success("You have been successfully checked in!"))
                        } else {
                            path.append(Route.failure)
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
        BehaviourAnalyticsService.shared.event(.visit(.checkIn))
    }
    
}

#Preview {
    CheckInPage(path: .constant(NavigationPath()), model: Default.flightModel)
}
