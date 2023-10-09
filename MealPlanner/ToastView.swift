//
//  ToastContentView.swift
//  MealPlanner
//
//  Created by Abdullah Nur on 9.10.2023.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let iconName: String
    @Binding var showToastMessage: Bool

    var body: some View {
        ZStack {
            VStack {
                Image(systemName: iconName)
                    .font(.largeTitle)
                    .foregroundColor(Color.orange)
                    .padding(.bottom, 10)
                
                Text(message)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            .padding()
            .background(Color.gray.opacity(0.5))
            .cornerRadius(20)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.4))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showToastMessage = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(message: "Your Message", iconName: "yourIconName", showToastMessage: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
