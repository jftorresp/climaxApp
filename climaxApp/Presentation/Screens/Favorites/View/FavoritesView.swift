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
    @State private var isLandscape: Bool = false

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    deleteFavoritesButton
                }
            }
            .onAppear {
                viewModel.loadFavoriteCities()
            }
    }
    
    var content: some View {
        GeometryReader { geometry in
            let newIsLandscape = geometry.size.width > geometry.size.height
            
            ZStack {
                Color.brandBlue
                    .ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    favoritesHeaderView
                    
                    if viewModel.favoriteCities.isEmpty {
                        noFavoritesView
                    } else {
                        favoritesListView
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
            .onAppear { isLandscape = newIsLandscape }
            .onChange(of: newIsLandscape) { newValue in
                isLandscape = newValue
            }
        }
    }
}

// MARK: Subviews

extension FavoritesView {
    var favoritesHeaderView: some View {
        Text(viewModel.favoritesTitleLabel)
            .font(.system(size: 36, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .if(isLandscape, transform: { view in
                view
                    .padding(.top, 10)
            })
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image.arrowLeftIcon
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 16)
                .if(isLandscape, transform: { view in
                    view
                        .padding(.top, 30)
                })
        }
    }
    
    var deleteFavoritesButton: some View {
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
                .frame(height: 20)
                .if(isLandscape, transform: { view in
                    view
                        .padding(.top, 30)
                })
        }
    }
    
    var noFavoritesView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            VStack {
                Image.cloudRainImg
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                Text(viewModel.noFavoritesTitleLabel)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                Text(viewModel.noFavoritesSubTitleLabel)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
    }
    
    var favoritesListView: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.favoriteCities, id: \.id) { city in
                    FavoriteCityView(city)
                }
            }
            .padding(.horizontal, 20)
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
                        Text(viewModel.latitudeLongitudeLabel(lat: city.latitude, lon: city.longitude))
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
