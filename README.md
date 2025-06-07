# BertCam

BertCam is a modern iOS camera application built with SwiftUI that provides a clean and intuitive interface for recording videos with customizable audio input selection.

## Features

- 📹 High-quality video recording
- 🎤 Multiple audio input source selection
- ⏱️ Recording timer with visual feedback
- 🎨 Beautiful and intuitive UI
- 📱 Support for both iPhone and iPad
- 🌙 Dark mode support

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+
- Tuist (for project generation)

## Installation

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

## Usage

1. Launch the app
2. Grant camera and microphone permissions when prompted
3. Select your preferred audio input source using the microphone button
4. Tap the record button to start/stop recording
5. Recorded videos are automatically saved to your photo library

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic and state management
- **Services**: Core functionality for camera and audio handling

### Key Components

- `CameraService`: Handles camera setup, recording, and audio input management
- `CameraViewModel`: Manages the app's state and user interactions
- `ContentView`: Main view containing the camera preview and controls
- `RecordButton`: Custom record button with animations and state handling
- `AudioInputPickerView`: Interface for selecting audio input sources

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with SwiftUI and AVFoundation
- Project managed with Tuist
- Icons generated using ImageMagick 