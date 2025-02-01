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
        VStack {
            SearchBarView(searchtext: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { newValue in
                    Task {
                        try await viewModel.searchCityByName(name: newValue)
                    }
                }
            if viewModel.noResultsFound {
                Spacer()
                VStack {
                    Image.searchIcon
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: 40)
                    Text("No Results")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    Text("No cities found for \"\(viewModel.searchText)\".")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.cities, id: \.id) { city in
                            Button {
                                self.selectedCity = city.name
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("\(city.name), \(city.country)")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SearchCityView(selectedCity: .constant("London"), viewModel: SearchCityViewModel())
}

struct SearchBarView: UIViewRepresentable {
    @Binding var searchtext: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $searchtext)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search for a city"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = searchtext
    }
}
