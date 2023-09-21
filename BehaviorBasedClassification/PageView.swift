//
//  PageView.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import SwiftUI

struct PageView: View {
    
    let title: String? = nil
    let content: any View
    
    @EnvironmentObject var mlService: MLService
    
    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Spacer()
                NavigationLink(value: Route.help) {
                    HStack {
                        Text(mlService.behaviourType?.title ?? "Help")
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .frame(maxWidth: (mlService.behaviourType ?? .normal) == .normal ? 80 : .infinity)
                    .padding(8)
                    .padding([.leading, .trailing], 12)
                    .background(.blue.opacity(0.25))
                    .clipShape(.capsule)
                    .symbolEffect(.pulse, options: .speed(2), value: mlService.behaviourType?.title ?? "Help")
                }
            }
            .padding([.leading, .trailing], 32)
            AnyView(content)
        }
    }
}

//#Preview {
//    PageView(content: SearchPage(path: .constant(NavigationPath())))
//}
