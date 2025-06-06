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
                    if viewModel.isRecording {
                        viewModel.stopRecording()
                    } else {
                        viewModel.startRecording()
                    }
                }) {
                    ZStack {
                        // Outer circle
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 84, height: 84)
                        
                        // Main record button
                        Circle()
                            .fill(Color.white)
                            .frame(width: 74, height: 74)
                        
                        // Recording indicator
                        Circle()
                            .fill(Color.red)
                            .frame(width: 66, height: 66)
                            .scaleEffect(viewModel.isRecording ? 1 : 0.92)
                            .animation(.easeInOut(duration: 0.2), value: viewModel.isRecording)
                        
                        if viewModel.isRecording {
                            // Recording stop symbol
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .frame(width: 28, height: 28)
                                .transition(.scale)
                        }
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .frame(width: 94, height: 94)
                    )
                }
                .padding(.bottom, 30)
                .overlay(
                    // Recording timer
                    Group {
                        if viewModel.isRecording {
                            RecordingIndicator()
                                .offset(y: -50)
                        }
                    }
                )
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
