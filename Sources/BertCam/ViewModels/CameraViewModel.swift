import Foundation
import AVFoundation
import SwiftUI

class CameraViewModel: ObservableObject {
    @Published var cameraService = CameraService()
    @Published var showingAudioInputPicker = false
    
    var isRecording: Bool {
        cameraService.isRecording
    }
    
    var availableAudioInputs: [AVAudioSessionPortDescription] {
        cameraService.availableAudioInputs
    }
    
    var selectedAudioInput: AVAudioSessionPortDescription? {
        cameraService.selectedAudioInput
    }
    
    func startRecording() {
        cameraService.startRecording()
    }
    
    func stopRecording() {
        cameraService.stopRecording()
    }
    
    func selectAudioInput(_ input: AVAudioSessionPortDescription) {
        cameraService.selectAudioInput(input)
    }
}
