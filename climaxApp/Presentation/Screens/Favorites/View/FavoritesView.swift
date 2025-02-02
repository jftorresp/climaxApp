//
//  FavoritesView.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: FavoritesViewModel
    
    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image.arrowLeftIcon
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(height: 16)
                    }
                }
            }
    }
    
    var content: some View {
        ZStack {
            Color.brandBlue
                .ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Favorites")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                if viewModel.favoriteCities.isEmpty {
                    noFavoritesView
                } else {
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: Subviews

extension FavoritesView {
    var noFavoritesView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            VStack {
                Image.cloudRainImg
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                Text("No favorites :(")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                Text("Favorite a city from the search to view it faster.")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel())
}
