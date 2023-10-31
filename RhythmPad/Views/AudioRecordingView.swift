import SwiftUI
import AVFoundation
import RealmSwift

struct AudioRecordingView: View {
    @State private var showModal: Bool = false
    @State private var index: Int = 0
    @State private var isRecording = false
    @ObservedObject var audioViewModel: AudioViewModel
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(audioViewModel.audioItems.indices, id: \.self) { index in
                        Button(audioViewModel.audioItems[index].audioName) {
                            self.index = index
                            if !showModal {
                                showModal = true
                            }
                        }
                    }
                    .onDelete(perform: audioViewModel.deleteAudioFile)
                    .sheet(isPresented: $showModal) {
                        AudioSettingView(showModal: $showModal, audioViewModel: audioViewModel, index: index)
                    }
                }
                .navigationBarItems(trailing: EditButton())
                .environment(\.editMode, $editMode)

                Button {
                    if isRecording {
                        audioViewModel.stopRecording()
                        isRecording = false
                    } else {
                        audioViewModel.recording()
                        isRecording = true
                    }
                } label: {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                        .background(isRecording ? .red : .blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("Audio file", displayMode: .inline)
        }
    }
}

struct AudioRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordingView(audioViewModel: .init())
    }
}
