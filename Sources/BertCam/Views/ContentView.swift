import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreviewView(cameraService: viewModel.cameraService)
                .edgesIgnoringSafeArea(.all)
            
            // Controls Overlay
            VStack {
                Spacer()
                
                // Audio Input Selection Button
                Button(action: {
                    viewModel.showingAudioInputPicker = true
                }) {
                    HStack {
                        Image(systemName: "mic")
                        Text(viewModel.selectedAudioInput?.portName ?? "Select Audio Input")
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.bottom)
                
                // Record Button
                Button(action: {
                    withAnimation {
                        if viewModel.isRecording {
                            viewModel.stopRecording()
                        } else {
                            viewModel.startRecording()
                        }
                    }
                }) {
                    ZStack {
                        // Outer circle
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 84, height: 84)
                        
                        // Main record button
                        Circle()
                            .fill(viewModel.isRecording ? Color.red : Color.white)
                            .frame(width: 74, height: 74)
                            .overlay(
                                Group {
                                    if viewModel.isRecording {
                                        // Pulsing animation when recording
                                        Circle()
                                            .stroke(Color.red, lineWidth: 2)
                                            .frame(width: 82, height: 82)
                                            .scaleEffect(1.1)
                                            .opacity(0.5)
                                            .animation(
                                                Animation.easeInOut(duration: 1)
                                                    .repeatForever(autoreverses: true),
                                                value: viewModel.isRecording
                                            )
                                    }
                                }
                            )
                        
                        // Recording state symbol
                        if viewModel.isRecording {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .frame(width: 26, height: 26)
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 66, height: 66)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .buttonStyle(RecordButtonStyle())
                .padding(.bottom, 30)
                
                // Recording timer and indicator
                if viewModel.isRecording {
                    RecordingIndicator()
                        .padding(.bottom, 16)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAudioInputPicker) {
            AudioInputPickerView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.cameraService.startSession()
        }
        .onDisappear {
            viewModel.cameraService.stopSession()
        }
    }
}
