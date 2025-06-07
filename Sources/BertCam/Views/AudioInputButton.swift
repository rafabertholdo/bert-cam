import SwiftUI

struct AudioInputButton: View {
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        Button(action: {
            viewModel.showingAudioInputPicker = true
        }) {
            HStack {
                Image(systemName: "mic")
                Text(viewModel.selectedAudioInput?.portName ?? "Select Audio Input")
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
} 