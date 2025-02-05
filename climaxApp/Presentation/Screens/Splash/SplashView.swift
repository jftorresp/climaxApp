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
                .accessibilityIdentifier("CityForecastView")
        } else {
            ZStack {
                Color.brandBlue
                VStack {
                    Image.appLogo
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.Splash.appLogoWidth)
                        .accessibilityIdentifier("appLogo")
                    Text(appName)
                        .foregroundColor(.white)
                        .font(.system(size: FontSize.p40.rawValue))
                        .fontWeight(.bold)
                        .accessibilityIdentifier("appName")
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(Constants.GeneralSizing.progressScaleEffect)
                        .accessibilityIdentifier("splashProgressView")
                }
            }
            .ignoresSafeArea(.all)
            .onAppear {
                let delay = ProcessInfo.processInfo.arguments.contains("UITestMode") ? 10.0 : Constants.Splash.splashDelay
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.isActive = true
                }
            }
            .accessibilityIdentifier("SplashView")
        }
    }
}

#Preview {
    SplashView()
}
