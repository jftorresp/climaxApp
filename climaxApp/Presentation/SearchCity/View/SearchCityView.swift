//
//  SearchCityView.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 1/02/25.
//

import SwiftUI

struct SearchCityView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCity: String
    @StateObject var viewModel: SearchCityViewModel
    
    var body: some View {
        content
    }
    
    var content: some View {
        ZStack {
            Color.brandBlue
                .ignoresSafeArea(.all)
            VStack(alignment: .leading, spacing: 10) {
                searchHeaderView
                
                if viewModel.searchText.isEmpty {
                    noSearchView
                } else if viewModel.noResultsFound {
                    noResultsView
                } else {
                    searchResultsView
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: Subviews

extension SearchCityView {
    var searchHeaderView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.searchTitleLabel)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            SearchBarView(searchtext: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { newValue in
                    Task {
                        try await viewModel.searchCityByName(name: newValue)
                    }
                }
        }
    }
    
    var noSearchView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            VStack {
                Image.sunImg
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                Text(viewModel.noSearchTitleLabel)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                Text(viewModel.noSearchSubTitleLabel)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
    }
    
    var noResultsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            VStack {
                Image.searchIcon
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 60)
                Text(viewModel.noResultsTitleLabel)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text(viewModel.noResultsSubTitleLabel)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
    }
    
    var searchResultsView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.cities, id: \.id) { city in
                    Button {
                        self.selectedCity = city.name
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("\(city.name), \(city.country)")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    SearchCityView(selectedCity: .constant("London"), viewModel: SearchCityViewModel())
}
