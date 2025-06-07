import Foundation
import AVFoundation
import SwiftUI

class CameraViewModel: ObservableObject {
    @Published var cameraService = CameraService()
    @Published var showingAudioInputPicker = false
    @Published var isRecording = false
    
    var availableAudioInputs: [AVAudioSessionPortDescription] {
        cameraService.availableAudioInputs
    }
    
    var selectedAudioInput: AVAudioSessionPortDescription? {
        cameraService.selectedAudioInput
    }
    
    func startRecording() {
        cameraService.startRecording()
        isRecording = true
    }
    
    func stopRecording() {
        cameraService.stopRecording()
        isRecording = false
    }
    
    func selectAudioInput(_ input: AVAudioSessionPortDescription) {
        cameraService.selectAudioInput(input)
    }
}
