//
//  Modifier.swift
//  KashtatK
//
//  Created by Mohammed on 02/03/2024.
//

import SwiftUI

// MARK: Three Loading dots View
struct ThreeDotsLoadingView: View {
    let animationDuration: Double = 0.6
    @State private var isAnimating: Bool = false

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .scaleEffect(isAnimating ? 0.5 : 1)
                    .opacity(isAnimating ? 0.5 : 1)
                    .animation(Animation.easeInOut(duration: animationDuration)
                                .repeatForever()
                                .delay(Double(index) * animationDuration / 3), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct LoadingModifier: ViewModifier {
    var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 3 : 0)

            if isLoading {
                ThreeDotsLoadingView()
                    .transition(.opacity)
            }
        }
    }
}

extension View {
    func loading(isLoading: Bool) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading))
    }
}

enum ToastStatus {
    case success, error
}
// MARK: Toast Banner View
struct ToastBannerView: View {
    let message: String
    let status: ToastStatus

    var body: some View {
        Text(message)
            .padding()
            .frame(maxWidth: .infinity) // Ensures full width
            .background(Color.Neumorphic.main.opacity(0.8))
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(status == .success ? Color.green : Color.red, lineWidth: 1)
            )
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal, 10) // Horizontal padding
    }
}

struct ToastBannerModifier: ViewModifier {
    let message: String
    let status: ToastStatus
    @Binding var show: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            GeometryReader { geometry in
                if show {
                    ToastBannerView(message: message, status: status)
                        .frame(width: geometry.size.width)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    show = false
                                }
                            }
                        }
                }
            }
        }
    }
}

extension View {
    func toastBanner(message: String, status: ToastStatus, show: Binding<Bool>) -> some View {
        self.modifier(ToastBannerModifier(message: message, status: status, show: show))
    }
}
