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
    @Binding var selectedFavoriteCity: City?
    
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            viewModel.deleteMode.toggle()
                        }
                    } label: {
                        Image.trashFillIcon
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20)
                    }
                }
            }
            .onAppear {
                viewModel.loadFavoriteCities()
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
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(viewModel.favoriteCities, id: \.id) { city in
                                FavoriteCityView(city)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
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
    
    @ViewBuilder
    func FavoriteCityView(_ city: City) -> some View {
        Button {
            self.selectedFavoriteCity = city
            presentationMode.wrappedValue.dismiss()
        } label: {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(city.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text(city.country)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image.starFillIcon
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20)
                    }

                    HStack {
                        Spacer()
                        Text("LAT:\(String(format: "%.1f", city.latitude))°, LON:\(String(format: "%.1f", city.longitude))°")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
            .background(Color.brandDarkBlue)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            if viewModel.deleteMode {
                Button {
                    viewModel.removeFromFavorites(city)
                } label: {
                    VStack(alignment: .leading) {
                        Image.trashIcon
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20)
                            .padding(12)
                    }
                    .background(Color.brandDarkBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel(), selectedFavoriteCity: .constant(nil))
}
