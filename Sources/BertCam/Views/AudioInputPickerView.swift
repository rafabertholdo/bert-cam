import SwiftUI
import AVFoundation

struct AudioInputPickerView: View {
    @ObservedObject var viewModel: CameraViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(viewModel.availableAudioInputs, id: \.uid) { input in
                Button(action: {
                    viewModel.selectAudioInput(input)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(input.portName)
                        Spacer()
                        if input.uid == viewModel.selectedAudioInput?.uid {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Audio Input")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
