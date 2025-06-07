import Foundation
import AVFoundation
import SwiftUI

/// A view model that manages the camera interface and recording state.
///
/// The `CameraViewModel` class coordinates between the views and the camera service, managing:
/// - Recording state
/// - Audio input selection
/// - User interface state
///
/// ## Usage
///
/// ```swift
/// @StateObject private var viewModel = CameraViewModel()
///
/// // Start recording
/// viewModel.startRecording()
///
/// // Stop recording
/// viewModel.stopRecording()
///
/// // Select audio input
/// if let input = viewModel.availableAudioInputs.first {
///     viewModel.selectAudioInput(input)
/// }
/// ```
///
/// ## Topics
///
/// ### Recording
///
/// - ``startRecording()``
/// - ``stopRecording()``
/// - ``isRecording``
///
/// ### Audio Input
///
/// - ``availableAudioInputs``
/// - ``selectedAudioInput``
/// - ``selectAudioInput(_:)``
/// - ``showingAudioInputPicker``
class CameraViewModel: ObservableObject {
    /// The camera service instance that handles camera operations.
    @Published var cameraService = CameraService()
    
    /// A boolean indicating whether the audio input picker is being shown.
    @Published var showingAudioInputPicker = false
    
    /// The current recording state.
    @Published var isRecording = false
    
    /// Available audio input sources.
    var availableAudioInputs: [AVAudioSessionPortDescription] {
        cameraService.availableAudioInputs
    }
    
    /// The currently selected audio input source.
    var selectedAudioInput: AVAudioSessionPortDescription? {
        cameraService.selectedAudioInput
    }
    
    /// Starts a new video recording.
    ///
    /// This method begins recording video and updates the recording state.
    func startRecording() {
        cameraService.startRecording()
        isRecording = true
    }
    
    /// Stops the current video recording.
    ///
    /// This method stops the current recording and updates the recording state.
    func stopRecording() {
        cameraService.stopRecording()
        isRecording = false
    }
    
    /// Selects an audio input source.
    ///
    /// - Parameter input: The audio input source to select.
    func selectAudioInput(_ input: AVAudioSessionPortDescription) {
        cameraService.selectAudioInput(input)
    }
}
