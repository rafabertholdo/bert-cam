import Foundation
import AVFoundation
import Photos

/// A service that manages camera and audio functionality for video recording.
///
/// The `CameraService` class handles all camera-related operations, including:
/// - Camera setup and configuration
/// - Video recording
/// - Audio input management
/// - Photo library integration
///
/// ## Usage
///
/// ```swift
/// let cameraService = CameraService()
/// cameraService.startSession()
/// cameraService.startRecording()
/// ```
///
/// ## Topics
///
/// ### Recording
///
/// - ``startRecording()``
/// - ``stopRecording()``
///
/// ### Audio Input
///
/// - ``availableAudioInputs``
/// - ``selectedAudioInput``
/// - ``selectAudioInput(_:)``
///
/// ### Session Management
///
/// - ``startSession()``
/// - ``stopSession()``
/// - ``getPreviewLayer()``
class CameraService: NSObject, ObservableObject {
    /// The current recording state.
    @Published var isRecording = false
    
    /// Available audio input sources.
    @Published var availableAudioInputs: [AVAudioSessionPortDescription] = []
    
    /// The currently selected audio input source.
    @Published var selectedAudioInput: AVAudioSessionPortDescription?
    
    private var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureMovieFileOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    /// Initializes a new camera service.
    ///
    /// This initializer sets up the capture session and loads available audio inputs.
    override init() {
        super.init()
        setupCaptureSession()
        loadAvailableAudioInputs()
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              let captureSession = captureSession else {
            return
        }
        
        // Configure audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
        
        // Add video input
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        // Add audio input
        if let audioDevice = AVCaptureDevice.default(for: .audio),
           let audioInput = try? AVCaptureDeviceInput(device: audioDevice),
           captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }
        
        // Add video output
        videoOutput = AVCaptureMovieFileOutput()
        if let videoOutput = videoOutput, captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
            // Configure audio settings
            if let audioConnection = videoOutput.connection(with: .audio) {
                audioConnection.isEnabled = true
            }
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
    }
    
    func loadAvailableAudioInputs() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            availableAudioInputs = AVAudioSession.sharedInstance().availableInputs ?? []
            
            // Select the first available audio input by default
            if let firstInput = availableAudioInputs.first {
                selectAudioInput(firstInput)
            }
        } catch {
            print("Failed to load audio inputs: \(error)")
        }
    }
    
    func selectAudioInput(_ input: AVAudioSessionPortDescription) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                // Stop the session before reconfiguring
                self.captureSession?.stopRunning()
                
                // Set the preferred input
                try AVAudioSession.sharedInstance().setPreferredInput(input)
                
                // Remove existing audio inputs
                if let existingInputs = self.captureSession?.inputs {
                    for input in existingInputs where input.ports.contains(where: { $0.mediaType == .audio }) {
                        self.captureSession?.removeInput(input)
                    }
                }
                
                // Configure audio session
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                // Add new audio input
                if let audioDevice = AVCaptureDevice.default(for: .audio),
                   let audioInput = try? AVCaptureDeviceInput(device: audioDevice),
                   let captureSession = self.captureSession,
                   captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                    
                    // Ensure audio connection is enabled
                    if let videoOutput = self.videoOutput,
                       let audioConnection = videoOutput.connection(with: .audio) {
                        audioConnection.isEnabled = true
                    }
                }
                
                DispatchQueue.main.async {
                    self.selectedAudioInput = input
                }
                
                // Restart the session
                self.captureSession?.startRunning()
            } catch {
                print("Failed to select audio input: \(error)")
            }
        }
    }
    
    /// Starts a new video recording.
    ///
    /// This method begins recording video to a temporary file. The recording will be saved to the photo library when stopped.
    func startRecording() {
        guard let videoOutput = videoOutput else { return }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "recording-\(Date().timeIntervalSince1970).mov"
        let fileUrl = documentsPath.appendingPathComponent(fileName)
        
        videoOutput.startRecording(to: fileUrl, recordingDelegate: self)
    }
    
    /// Stops the current video recording.
    ///
    /// This method stops the current recording and saves it to the photo library.
    func stopRecording() {
        videoOutput?.stopRecording()
    }
    
    /// Returns the preview layer for displaying the camera feed.
    ///
    /// - Returns: An `AVCaptureVideoPreviewLayer` that can be used to display the camera feed.
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return previewLayer
    }
    
    /// Starts the capture session.
    ///
    /// Call this method when you want to begin capturing video.
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    /// Stops the capture session.
    ///
    /// Call this method when you want to stop capturing video.
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.stopRunning()
        }
    }
}

extension CameraService: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async { [weak self] in
            self?.isRecording = true
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.isRecording = false
        }
        
        if let error = error {
            print("Error recording video: \(error)")
            return
        }
        
        // Request permission to save to photo library if needed
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                // Save video to camera roll
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                }) { success, error in
                    if let error = error {
                        print("Error saving video to photo library: \(error)")
                    } else if success {
                        print("Video successfully saved to camera roll")
                        // Clean up the temporary file
                        try? FileManager.default.removeItem(at: outputFileURL)
                    }
                }
            } else {
                print("Permission denied to save video to photo library")
            }
        }
    }
}
