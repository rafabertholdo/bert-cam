# Getting Started with BertCam

Learn how to set up and use BertCam for video recording.

## Installation

To get started with BertCam, follow these steps:

1. Clone the repository:
```bash
git clone https://github.com/yourusername/bert-cam.git
cd bert-cam
```

2. Install Tuist (if not already installed):
```bash
curl -Ls https://install.tuist.io | bash
```

3. Generate the Xcode project:
```bash
tuist generate
```

4. Open the generated workspace:
```bash
open BertCam.xcworkspace
```

## Basic Usage

### Recording a Video

1. Launch the app
2. Grant camera and microphone permissions when prompted
3. Select your preferred audio input source using the microphone button
4. Tap the record button to start recording
5. Tap the record button again to stop recording
6. The video will be automatically saved to your photo library

### Selecting Audio Input

1. Tap the microphone button in the main interface
2. Choose from the available audio input sources
3. The selected input will be used for recording

## Requirements

- iOS 15.0 or later
- Camera and microphone permissions
- Photo library access for saving recordings

## Troubleshooting

### Common Issues

1. **Camera Access Denied**
   - Go to Settings > Privacy > Camera
   - Enable access for BertCam

2. **Microphone Access Denied**
   - Go to Settings > Privacy > Microphone
   - Enable access for BertCam

3. **Photo Library Access Denied**
   - Go to Settings > Privacy > Photos
   - Enable access for BertCam

### Support

If you encounter any issues not covered here, please:
1. Check the [GitHub Issues](https://github.com/yourusername/bert-cam/issues)
2. Create a new issue if your problem hasn't been reported 