import SwiftUI

@available(macOS 11.0, *)
struct AppLogo: View {
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
            
            // Camera lens
            Circle()
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 70, height: 70)
            
            // Camera lens inner circle
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 50, height: 50)
            
            // Audio waves
            ForEach(0..<3) { i in
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 30 + CGFloat(i * 10), height: 30 + CGFloat(i * 10))
                    .opacity(0.3)
            }
            
            // Letter B
            Text("B")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .offset(x: 2, y: -2)
            
            // Small audio symbol
            Image(systemName: "waveform")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .offset(x: 25, y: 25)
        }
    }
} 