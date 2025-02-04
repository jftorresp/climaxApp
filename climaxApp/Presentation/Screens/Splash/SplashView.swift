//
//  SplashView.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 1/02/25.
//

import SwiftUI

struct SplashView: View {
    @State var isActive = false
    
    var appName: String {
        return "Climax."
    }
    
    var body: some View {
        if isActive {
            CityForecastView(viewModel: CityForecastViewModel())
        } else {
            ZStack {
                Color.brandBlue
                VStack {
                    Image.appLogo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    Text(appName)
                        .foregroundColor(.white)
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(1.5)
                }
            }
            .ignoresSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
