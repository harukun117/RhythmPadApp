import SwiftUI
import AVFoundation

struct PadButton: View {
    private var buttonTitle: String
    private var buttonColor: Color
    private var audioIndex: Int
    @State private var audioPlayer: AVAudioPlayer?
    @StateObject var audioViewModel: AudioViewModel

    init(buttonTitle: String, buttonColor: Color, audioIndex: Int, audioViewModel: AudioViewModel) {
        self.buttonTitle = buttonTitle
        self.buttonColor = buttonColor
        self.audioIndex = audioIndex
        _audioViewModel = StateObject(wrappedValue: audioViewModel)
    }

    var body: some View {
        Text(buttonTitle)
            .font(.largeTitle)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(buttonColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 6)
            )
            .padding(5)
            .onAppear {
                audioPlayer = audioViewModel.setUpAudio(at: audioIndex)
            }
    }
}

struct PadButton_Previews: PreviewProvider {
    static var previews: some View {
        PadButton(buttonTitle: "", buttonColor: .white, audioIndex: 0, audioViewModel: .init())
    }
}
