//
//  FailurePage.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import SwiftUI

struct FailurePage: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "cloud.drizzle.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
            VStack {
                Text("Ahh.. 😱")
                    .font(.title)
                Text("Undefined issue, please try again later.")
                    .font(.subheadline)
            }
            Text("Back to home")
                .padding(16)
                .padding([.leading, .trailing], 48)
                .foregroundColor(Color("backgroundColor"))
                .background(Color("textColor"))
                .clipShape(.capsule)
                .onTapGesture {
                    path = NavigationPath()
                }
        }
        .padding(32)
        .navigationBarBackButtonHidden()
        .onAppear {
            configure()
        }
    }
    
    func configure() {
        BehaviourAnalyticsService.shared.event(.visit(.failurePage))
    }
}

#Preview {
    FailurePage(path: .constant(NavigationPath()))
}
