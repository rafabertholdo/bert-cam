import SwiftUI

/// A loading view that displays while the camera is initializing.
///
/// The `CameraLoadingView` provides a clean and modern loading interface with:
/// - A rotating circular progress indicator
/// - A status message
/// - A dark theme that matches the camera interface
///
/// ## Usage
///
/// ```swift
/// if isInitializing {
///     CameraLoadingView()
/// }
/// ```
struct CameraLoadingView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.white, lineWidth: 4)
                            .rotationEffect(Angle(degrees: 270))
                            .animation(
                                Animation.linear(duration: 1)
                                    .repeatForever(autoreverses: false),
                                value: UUID()
                            )
                    )
                
                Text("Initializing Camera")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    CameraLoadingView()
} 