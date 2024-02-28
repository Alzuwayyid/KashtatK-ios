//
//  SearchView.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import SwiftUI
import Neumorphic

struct SearchView: View {
    // MARK: Properities
    @EnvironmentObject var router: HomeRouter
    var neumorphicNavigationBarItems: [NavBarItem] = []
    
    var body: some View {
        VStack {
            NeumorphicNavigationBar(
                items: neumorphicNavigationBarItems,
                showBackButton: true,
                title: "Search",
                onBack: {
                    router.dismiss()
                }
            )
            SearchBarView {
                // Action
            }
            .padding(.horizontal, 16)
            Spacer()
        }
        .background(Color.Neumorphic.main)
        .navigationBarBackButtonHidden()
    }
}
