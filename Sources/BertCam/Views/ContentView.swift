import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var recordingTime: TimeInterval = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreviewView(cameraService: viewModel.cameraService)
                .edgesIgnoringSafeArea(.all)
            
            // Controls Overlay
            VStack {
                Spacer()
                
                if !viewModel.isRecording {
                    AudioInputButton(viewModel: viewModel)
                        .padding(.bottom)
                }
                
                RecordButton(
                    isRecording: $viewModel.isRecording,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            if viewModel.isRecording {
                                viewModel.stopRecording()
                                recordingTime = 0
                            } else {
                                viewModel.startRecording()
                                recordingTime = 0
                            }
                        }
                    }
                )
                .padding(.bottom, 30)
                
                if viewModel.isRecording {
                    RecordingTimerView(time: recordingTime)
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
        .onReceive(timer) { _ in
            if viewModel.isRecording {
                recordingTime += 1
            }
        }
    }
}
