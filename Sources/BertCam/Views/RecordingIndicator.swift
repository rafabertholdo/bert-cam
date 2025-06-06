import SwiftUI

struct RecordingIndicator: View {
    @State private var isBlinking = false
    @State private var recordingTime: TimeInterval = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 8) {
            // Blinking record indicator
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .opacity(isBlinking ? 0.3 : 1)
                .animation(
                    Animation.easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true),
                    value: isBlinking
                )
                .onAppear { isBlinking = true }
            
            // Recording time
            Text(timeString(from: recordingTime))
                .font(.system(.body, design: .monospaced).weight(.medium))
                .foregroundColor(.white)
            
            // REC label
            Text("REC")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.red)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.75))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .onReceive(timer) { _ in
            recordingTime += 1
        }
        .onDisappear {
            recordingTime = 0
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
