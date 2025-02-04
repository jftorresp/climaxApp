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
                        .frame(width: Constants.Splash.appLogoWidth)
                    Text(appName)
                        .foregroundColor(.white)
                        .font(.system(size: FontSize.p40.rawValue))
                        .fontWeight(.bold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(Constants.GeneralSizing.progressScaleEffect)
                }
            }
            .ignoresSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Splash.splashDelay) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
