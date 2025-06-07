import Foundation
import AVFoundation
import Photos

class CameraService: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var availableAudioInputs: [AVAudioSessionPortDescription] = []
    @Published var selectedAudioInput: AVAudioSessionPortDescription?
    
    private var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureMovieFileOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
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
        do {
            // Stop the session before reconfiguring
            captureSession?.stopRunning()
            
            // Set the preferred input
            try AVAudioSession.sharedInstance().setPreferredInput(input)
            
            // Remove existing audio inputs
            if let existingInputs = captureSession?.inputs {
                for input in existingInputs where input.ports.contains(where: { $0.mediaType == .audio }) {
                    captureSession?.removeInput(input)
                }
            }
            
            // Configure audio session
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            // Add new audio input
            if let audioDevice = AVCaptureDevice.default(for: .audio),
               let audioInput = try? AVCaptureDeviceInput(device: audioDevice),
               let captureSession = captureSession,
               captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
                
                // Ensure audio connection is enabled
                if let videoOutput = videoOutput,
                   let audioConnection = videoOutput.connection(with: .audio) {
                    audioConnection.isEnabled = true
                }
            }
            
            selectedAudioInput = input
            
            // Restart the session
            captureSession?.startRunning()
        } catch {
            print("Failed to select audio input: \(error)")
        }
    }
    
    func startRecording() {
        guard let videoOutput = videoOutput else { return }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "recording-\(Date().timeIntervalSince1970).mov"
        let fileUrl = documentsPath.appendingPathComponent(fileName)
        
        videoOutput.startRecording(to: fileUrl, recordingDelegate: self)
    }
    
    func stopRecording() {
        videoOutput?.stopRecording()
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return previewLayer
    }
    
    func startSession() {
        captureSession?.startRunning()
    }
    
    func stopSession() {
        captureSession?.stopRunning()
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
