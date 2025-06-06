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
                .animation(Animation.easeInOut(duration: 1).repeatForever(), value: isBlinking)
                .onAppear {
                    isBlinking = true
                }
            
            // Recording time
            Text(timeString(from: recordingTime))
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.6))
        .cornerRadius(20)
        .onReceive(timer) { _ in
            recordingTime += 1
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
