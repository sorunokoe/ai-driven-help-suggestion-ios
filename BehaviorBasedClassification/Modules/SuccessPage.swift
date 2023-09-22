//
//  SuccessPage.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import SwiftUI

struct SuccessPage: View {
    
    var text: String
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "sun.haze.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
            VStack {
                Text("Hooray 🎉")
                    .font(.title)
                Text(text)
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
        BehaviourAnalyticsService.shared.event(.visit(.successfullPage))
        BehaviourAnalyticsService.shared.label(.normal)
    }
}

#Preview {
    SuccessPage(text: "Your flight has been successfully booked!",
                path: .constant(NavigationPath()))
}
