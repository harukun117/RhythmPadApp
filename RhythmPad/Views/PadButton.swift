import SwiftUI
import AVFoundation

struct PadButton: View {
    let id: Int
    @State var showModal: Bool = false
    @State private var buttonTitle = "ボタン"
    @State private var buttonColor = Color.white
    @State private var audioIndex: Int = 0
    @State private var audioPlayer: AVAudioPlayer? = nil
    @ObservedObject var playViewModel: PlayViewModel
    @ObservedObject var audioViewModel: AudioViewModel

    init(id: Int, playViewModel: PlayViewModel, audioViewModel: AudioViewModel) {
        self.id = id
        self.playViewModel = playViewModel
        self.audioViewModel = audioViewModel
    }

    var body: some View {
        ZStack {
            Button {
                if playViewModel.pushedSettingButton {
                    showModal = true
                } else {
                    print("play")
                    audioViewModel.play(player: audioPlayer)
                    print("played")
                }
            } label: {
                Text(buttonTitle)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(buttonColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 6)
            )
            .padding(5)
            .sheet(isPresented: $showModal) {
                ButtonSettingView(id: id, buttonTitle: $buttonTitle, buttonColor: $buttonColor, showModal: $showModal, audioIndex: $audioIndex, audioPlayer: $audioPlayer, playViewModel: playViewModel, audioViewModel: audioViewModel)
            }
            if playViewModel.pushedSettingButton {
                Button {
                    playViewModel.deleteButton(at: id)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .onAppear {
            audioPlayer = audioViewModel.setUpAudio(at: audioIndex)
        }
    }
}

struct PadButton_Previews: PreviewProvider {
    static var previews: some View {
        PadButton(id: 1, playViewModel: .init(), audioViewModel: .init())
    }
}
