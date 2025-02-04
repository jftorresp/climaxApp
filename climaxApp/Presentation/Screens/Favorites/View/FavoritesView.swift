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
            .font(.system(size: FontSize.p36.rawValue, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, Sizing.small.rawValue)
            .if(isLandscape, transform: { view in
                view
                    .padding(.top, Sizing.tiny.rawValue)
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
                .frame(height: Constants.Favorites.backButtonIconHeight)
                .if(isLandscape, transform: { view in
                    view
                        .padding(.top, Constants.GeneralSizing.landscapeTopPadding)
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
                .frame(height: Constants.Favorites.trashIconHeight)
                .if(isLandscape, transform: { view in
                    view
                        .padding(.top, Constants.GeneralSizing.landscapeTopPadding)
                })
        }
    }
    
    var noFavoritesView: some View {
        VStack(alignment: .leading, spacing: Sizing.tiny.rawValue) {
            Spacer()
            VStack {
                Image.cloudRainImg
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.Favorites.noFavoritesImageWidth)
                Text(viewModel.noFavoritesTitleLabel)
                    .font(.system(size: FontSize.p32.rawValue, weight: .bold))
                    .foregroundColor(.white)
                Text(viewModel.noFavoritesSubTitleLabel)
                    .font(.system(size: FontSize.p18.rawValue))
                    .foregroundColor(.white.opacity(Constants.Favorites.opacity))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Sizing.small.rawValue)
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
            .padding(.horizontal, Sizing.small.rawValue)
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
                                .font(.system(size: FontSize.p24.rawValue, weight: .bold))
                                .foregroundColor(.white)
                            Text(city.country)
                                .font(.system(size: FontSize.p14.rawValue))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image.starFillIcon
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: Constants.Favorites.smallIconWidth)
                    }

                    HStack {
                        Spacer()
                        Text(viewModel.latitudeLongitudeLabel(lat: city.latitude, lon: city.longitude))
                            .font(.system(size: FontSize.p14.rawValue, weight: .medium))
                            .foregroundColor(.white)
                            .shadow(radius: Constants.GeneralSizing.shadowRadius)
                    }
                }
                .padding(.vertical, Sizing.xxxxSmall.rawValue)
                .padding(.horizontal, Sizing.xxSmall.rawValue)
            }
            .background(Color.brandDarkBlue)
            .clipShape(RoundedRectangle(cornerRadius: Sizing.xxSmall.rawValue))
            
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
                            .frame(width: Constants.Favorites.smallIconWidth)
                            .padding(Sizing.xxxxSmall.rawValue)
                    }
                    .background(Color.brandDarkBlue)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Favorites.deleteIconCornerRadius))
                }
            }
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel(), selectedFavoriteCity: .constant(nil))
}
