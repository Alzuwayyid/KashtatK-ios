//
//  HomeView+Views.swift
//  KashtatK
//
//  Created by Mohammed on 02/03/2024.
//

import SwiftUI
import Neumorphic

struct CartStateComponentView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5).fill(Color.Neumorphic.main).frame(height: 140).frame(maxWidth: .infinity)
                .softInnerShadow(RoundedRectangle(cornerRadius: 5))
            VStack(spacing: 10) {
                Text("No items added to the bag")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.black.opacity(0.6))
                Image(systemName: "cross.fill")
                    .foregroundStyle(Color.black.opacity(0.6))
            }
            .padding()
        }
    }
}
