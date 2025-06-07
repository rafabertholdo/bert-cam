# Architecture

Learn about the architecture and design patterns used in BertCam.

## Overview

BertCam follows the MVVM (Model-View-ViewModel) architecture pattern, which provides a clear separation of concerns and makes the codebase more maintainable and testable.

## Architecture Components

### Views

The Views layer is responsible for the user interface and user interactions. It's built using SwiftUI and includes:

- ``ContentView``: The main view that contains the camera preview and controls
- ``CameraPreviewView``: Displays the live camera feed
- ``RecordButton``: Custom record button with animations
- ``AudioInputButton``: Button for accessing audio input selection
- ``AudioInputPickerView``: Interface for selecting audio input sources
- ``RecordingTimerView``: Displays the current recording duration
- ``AppLogo``: The app's logo component

### View Models

The View Models layer manages the app's state and business logic:

- ``CameraViewModel``: Coordinates between the views and the camera service, managing:
  - Recording state
  - Audio input selection
  - User interface state

### Services

The Services layer handles core functionality:

- ``CameraService``: Manages camera and audio functionality:
  - Camera setup and configuration
  - Video recording
  - Audio input management
  - Photo library integration

## Data Flow

1. User interactions are handled by SwiftUI views
2. Views communicate with the ViewModel through bindings
3. ViewModel processes the requests and updates the state
4. CameraService handles the actual camera and audio operations
5. Results are propagated back through the ViewModel to update the UI

## Design Patterns

### MVVM Pattern

- **Model**: Camera and audio functionality in CameraService
- **View**: SwiftUI views
- **ViewModel**: CameraViewModel

### Dependency Injection

- Services are injected into ViewModels
- ViewModels are injected into Views
- This makes the code more testable and maintainable

### Observer Pattern

- Uses SwiftUI's `@Published` and `@StateObject` for reactive updates
- Implements `ObservableObject` for state management

## Best Practices

1. **Separation of Concerns**
   - Views handle UI only
   - ViewModels manage state and business logic
   - Services handle core functionality

2. **Reactive Programming**
   - Uses SwiftUI's data flow
   - Implements proper state management

3. **Error Handling**
   - Graceful error handling in services
   - User-friendly error messages

4. **Memory Management**
   - Proper use of weak references
   - Cleanup of resources when views disappear 