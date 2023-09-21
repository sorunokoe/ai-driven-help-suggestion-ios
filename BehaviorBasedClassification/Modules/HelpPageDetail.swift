//
//  HelpPageDetail.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import SwiftUI

struct HelpPageDetail: View {
    
    var type: HelpType
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(type.text)
                    .font(.title)
                VStack(alignment: .leading, spacing: 32) {
                    Text("You can find all the necessary information for your issue here.")
                    Text("Detailed information about your flight can be found on our website.")
                    Image(systemName: "ellipsis.circle.fill")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .frame(maxWidth: .infinity, alignment: .center)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Do you need further help?")
                            .font(.headline)
                        Text("Have you tried using our AI assistant?\nIt can assist you in various situations.")
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Did you find a solution to your problem?")
                           
                        HStack {
                            Text("Yes")
                                .padding(8)
                                .padding([.leading, .trailing], 32)
                                .foregroundColor(Color("backgroundColor"))
                                .background(Color("textColor"))
                                .clipShape(.capsule)
                                .onTapGesture {
                                    BehaviourAnalyticsService.shared.label(type.label)
                                }
                            Text("No")
                                .padding(8)
                                .padding([.leading, .trailing], 32)
                                .foregroundColor(Color("backgroundColor"))
                                .background(Color("textColor"))
                                .clipShape(.capsule)
                        }
                        .frame(maxWidth: .infinity)
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
        BehaviourAnalyticsService.shared.event(.visit(type.page))
    }
    
}

#Preview {
    HelpPageDetail(type: .checkIn)
}
