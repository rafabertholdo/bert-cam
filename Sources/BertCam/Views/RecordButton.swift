import SwiftUI

struct RecordButton: View {
    @Binding var isRecording: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Outer circle with blur effect
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 84, height: 84)
                    .blur(radius: 2)
                
                // Main record button
                Circle()
                    .fill(isRecording ? Color.red : Color.white)
                    .frame(width: isRecording ? 60 : 74, height: isRecording ? 60 : 74)
                    .overlay(
                        Group {
                            if isRecording {
                                // Pulsing animation when recording
                                Circle()
                                    .stroke(Color.red, lineWidth: 2)
                                    .frame(width: 82, height: 82)
                                    .scaleEffect(1.1)
                                    .opacity(0.5)
                                    .animation(
                                        Animation.easeInOut(duration: 1)
                                            .repeatForever(autoreverses: true),
                                        value: isRecording
                                    )
                            }
                        }
                    )
                
                // Recording state symbol
                Group {
                    if isRecording {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: 28, height: 28)
                    } else {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 66, height: 66)
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRecording)
            }
        }
        .buttonStyle(RecordButtonStyle())
        .scaleEffect(isRecording ? 1.0 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRecording)
    }
} 