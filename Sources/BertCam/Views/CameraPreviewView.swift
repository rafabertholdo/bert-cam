import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let cameraService: CameraService

    class VideoPreviewView: UIView {
        public override class var layerClass: AnyClass {
             return AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    var view: VideoPreviewView = {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }()

    func makeUIView(context: Context) -> UIView {
        cameraService.updateSession(on: view.videoPreviewLayer)
        return self.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
