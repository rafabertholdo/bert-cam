import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // Match LaunchScreen background
            Image("Icon-1024")
                .resizable()
                .frame(width: 180, height: 180)
        }
        .onAppear {
            // Simulate loading or delay for effect
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            ContentView() // Your main app view
        }
    }
} 