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
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel())
}
