//
//  Views.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
import Neumorphic
import CoreGraphics
import CoreImage
import SwiftData

extension View {
    /// Converts the invoking view to `AnyView` for type erasure.
    /// Useful for returning different types of views from a single function or when a view's type needs to be abstracted.
    func earseToAnyView() -> AnyView {
        return AnyView(self)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

struct BaseView<Content: View>: View {
    let content: Content
    let baseColor: Color // Allows customization of the base color if needed

    init(baseColor: Color = Color.Neumorphic.main, @ViewBuilder content: () -> Content) {
        self.baseColor = baseColor
        self.content = content()
    }

    var body: some View {
        ZStack {
            baseColor.edgesIgnoringSafeArea(.all)
            content
        }
    }
}

struct NavBarItem {
    let id: UUID = UUID()
    let icon: Image
    let mainColor: Color
    let secondaryColor: Color
    let counter: Int?
    let action: () -> Void
    
    init(icon: Image, mainColor: Color, secondaryColor: Color, counter: Int? = nil, action: @escaping () -> Void) {
        self.icon = icon
        self.mainColor = mainColor
        self.secondaryColor = secondaryColor
        self.counter = counter
        self.action = action
    }
}

struct NeumorphicNavigationBar: View {
    enum TitleType {
        case main, subScreen
    }
    // MARK: Properties
    var items: [NavBarItem]
    var showBackButton: Bool
    var title: String
    var titleType: TitleType
    var onBack: (() -> Void)?

    var body: some View {
        ZStack {
            HStack {
                if showBackButton {
                    Button(action: {
                        onBack?()
                    }) {
                        Image(systemName: "chevron.left") // Example back button
                            .neumorphicStyle()
                    }
                }
                Spacer()
            }
            // Title positioned absolutely in the center
            Text(title)
                .bold()
                .font(.system(size: titleType == .main ? 40 : 20)) // Conditional font size
                .frame(maxWidth: .infinity, alignment: titleType == .main ? .leading : .center)
            HStack {
                Spacer()
                ForEach(items, id: \.id) { item in
                    Button(action: {
                        item.action()
                    }) {
                        item.icon
                    }
                    .softButtonStyle(Circle(), mainColor: item.mainColor, textColor: item.secondaryColor, darkShadowColor: Color.Neumorphic.darkShadow, lightShadowColor: Color.Neumorphic.lightShadow)
                    .overlay(
                        Group {
                            if let counter = item.counter, counter > 0 {
                                Text("\(counter)")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 20, y: -20)
                            }
                        }
                    )
                }
            }
        }
        .padding()
        .background(Color.Neumorphic.main)
        .cornerRadius(10)
    }
}



extension View {
    func neumorphicStyle() -> some View {
        self
            .foregroundColor(Color.gray)
            .padding()
            .background(Color.Neumorphic.main)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
            .shadow(color: .white.opacity(0.7), radius: 2, x: -2, y: -2)
    }
}

struct SearchBarView: View {
    // MARK: Properities
    var action: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.Neumorphic.secondary).font(Font.body.weight(.bold))
                Text("Search ...").foregroundColor(.Neumorphic.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                    .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: .Neumorphic.darkShadow, lightShadow: .Neumorphic.lightShadow, spread: 0.05, radius: 2)
            ).onTapGesture {
                action()
            }
        }
    }
}
            
struct BaseSearchView: View {
    // MARK: Properities
    @Binding var text: String
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.Neumorphic.secondary).font(Font.body.weight(.bold))
                TextField("Search ...", text: $text)
                    .focused($isTextFieldFocused)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                    .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: .Neumorphic.darkShadow, lightShadow: .Neumorphic.lightShadow, spread: 0.05, radius: 2)
            )
        }
    }
}

struct BaseAsyncImage: View {
    // MARK: Properities
    let url: String
    var height: CGFloat = 90
    var width: CGFloat = 90
    var isScaleToFill = false
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            if isScaleToFill {
                image.resizable()
                     .scaledToFill()
                     .frame(width: width, height: height)
            } else {
                image.resizable()
                     .scaledToFit()
                     .frame(width: width, height: height)
            }
        } placeholder: {
            ProgressView()
        }
    }
}

class ImageColorViewModel: ObservableObject {
    @Published var dominantColor1: Color = .clear
    @Published var dominantColor2: Color = .clear
}

extension ImageColorViewModel {
    func loadImageAndAnalyzeColors(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let uiImage = UIImage(data: data) else {
                return
            }

            // Resize image for efficiency in color analysis
            let resizedImage = uiImage.resized(to: CGSize(width: 100, height: 100))
            
            // Extract dominant colors from the resized image
            let dominantColors = self.analyzeDominantColors(in: resizedImage)
            
            // Update the published properties on the main thread
            DispatchQueue.main.async {
                self.dominantColor1 = dominantColors.0
                self.dominantColor2 = dominantColors.1
            }
        }.resume()
    }
    
    private func analyzeDominantColors(in image: UIImage) -> (Color, Color) {
        guard let ciImage = CIImage(image: image) else { return (.clear, .clear) }
        
        // Using CoreImage's CFAreaHistogram to analyze the image's color histogram
        let context = CIContext(options: nil)
        guard let averageFilter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: ciImage]) else { return (.clear, .clear) }
        averageFilter.setValue(CIVector(cgRect: ciImage.extent), forKey: kCIInputExtentKey)
        
        var dominantColor1 = Color.clear
        var dominantColor2 = Color.clear
        
        if let outputImage = averageFilter.outputImage,
           let bitmap = context.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: 1, height: 1)),
           let data = CFDataGetBytePtr(bitmap.dataProvider!.data) {
            let red = CGFloat(data[0]) / 255.0
            let green = CGFloat(data[1]) / 255.0
            let blue = CGFloat(data[2]) / 255.0
            let alpha = CGFloat(data[3]) / 255.0
            dominantColor1 = Color(red: red, green: green, blue: blue, opacity: alpha)
            
            // For simplicity, let's assume the second dominant color is a lighter or darker variant of the first
            // In a real scenario, you might perform additional analysis to find another distinct color
            let adjustedBrightness = max(red, green, blue) > 0.5 ? 0.8 : 0.2
            dominantColor2 = Color(red: red * adjustedBrightness, green: green * adjustedBrightness, blue: blue * adjustedBrightness)
        }
        
        return (dominantColor1, dominantColor2)
    }
}

struct GradientBackgroundView: View {
    let imageUrl: URL
    @StateObject private var viewModel = ImageColorViewModel()
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [viewModel.dominantColor1.opacity(0.5), viewModel.dominantColor2.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
            .animation(.easeInOut(duration: 1.5), value: viewModel.dominantColor1)
            .animation(.easeInOut(duration: 1.5), value: viewModel.dominantColor2)
            .overlay(
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(25)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.loadImageAndAnalyzeColors(from: imageUrl)
            }
    }
}



struct NeumorphicCircleView: View {
    enum Mode {
        case cart(counter: Int)
        case rating(value: Double)
    }
    
    var mode: Mode
    var imageStr = "checkmark.circle.fill"
    
    var body: some View {
        ZStack {
            // Main circle with an image in the center
            Circle()
                .fill(Color.gray.opacity(0.2)) // Adjust the color to match your background or preference
                .frame(width: 50, height: 50)
                .shadow(color: .white, radius: 8, x: -8, y: -8) // Light source from top-left
                .shadow(color: .black.opacity(0.2), radius: 8, x: 8, y: 8) // Shadow to the bottom-right
                .overlay(
                    Image(systemName: imageStr) // Example system image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25) // Adjust the size as needed
                        .foregroundColor(.gray) // Icon color
                )
            
            // Conditional overlay based on mode
            switch mode {
            case .cart(let counter):
                // Counter circle for cart
                Circle()
                    .fill(Color.green.opacity(0.9)) // Counter background color
                    .frame(width: 20, height: 20)
                    .overlay(
                        Text("\(counter)")
                            .font(.system(size: 11))
                            .foregroundColor(.white)
                    )
                    .offset(x: 25, y: -25) // Adjust position to top-right
                
            case .rating(let value):
                    Circle()
                        .fill(Color.yellow.opacity(0.9)) // Counter background color
                        .frame(width: 25, height: 20)
                        .overlay(
                            // Rating value
                            Text(String(format: "%.1f", value))
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                        )
                        .offset(x: 25, y: -25) // Adjust position to top-right
            }
        }
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
    
}

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
}

struct FilterKeywordsScrollView: View {
    enum KeywordsType {
        case filterKeyWords
        case popularSearches
    }
    // MARK: Properities
    @State var selectedChipId: String?
    var filterKeywords: [FilterModel]
    var keywordsType: KeywordsType
    var cornerRadius: CGFloat = 20
    var horizontalPadding: CGFloat = 5
    let onChipSelected: (String?) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15).fill(Color.Neumorphic.main).frame(height: 55).frame(maxWidth: .infinity)
                .softInnerShadow(RoundedRectangle(cornerRadius: 15))
            ScrollView(.horizontal) {
                LazyHGrid(rows: ThemeManager.shared.gridFixed55) {
                    ForEach(keywordsArray(), id: \.id) { keyword in
                        FilterChipView(data: keyword, isSelected: selectedChipId == keyword.id, cornerRadius: cornerRadius) { id in
                            withAnimation {
                                selectedChipId = (selectedChipId == id) ? nil : id
                            }
                            onChipSelected(id)
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .frame(height: 55)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    // Helper function to determine which keywords array to use
    private func keywordsArray() -> [SearchKeywords] {
        switch keywordsType {
        case .filterKeyWords:
            return filterKeywords.flatMap { $0.filterKeyWords }
        case .popularSearches:
            return filterKeywords.flatMap { $0.popularSearches }
        }
    }
}

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
