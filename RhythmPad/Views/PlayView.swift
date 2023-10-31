import Foundation
import SwiftUI

struct PlayView: View {
    @State var showModal: Bool = false
    @State var buttonSettingIndex = 0
    @StateObject var playViewModel: PlayViewModel
    @StateObject var audioViewModel: AudioViewModel

    init(playViewModel: PlayViewModel, audioViewModel: AudioViewModel) {
        _playViewModel = StateObject(wrappedValue: playViewModel)
        _audioViewModel = StateObject(wrappedValue: audioViewModel)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if playViewModel.padButtons.count == 0 {
                    Text("add button")
                    Button {
                        playViewModel.addButton()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ForEach(0 ..< 4) { i in
                    if playViewModel.padButtons.count > i * 3 {
                        HStack(spacing: 0) {
                            ForEach(playViewModel.padButtons[i * 3 ..< playViewModel.padButtons.count].indices, id: \.self) { index in
                                if playViewModel.check(index: index, i: i) {
                                    ZStack {
                                        Button {
                                            if playViewModel.pushedSettingButton {
                                                buttonSettingIndex = index
                                                showModal = true
                                            } else {
                                                audioViewModel.play(player: playViewModel.padButtons[index].audioPlayer)
                                            }
                                        } label: {
                                            PadButton(buttonTitle: playViewModel.padButtons[index].buttonTitle, buttonColor: playViewModel.padButtons[index].buttonColor, audioIndex: playViewModel.padButtons[index].audioIndex, audioViewModel: audioViewModel)
                                        }
                                        if playViewModel.pushedSettingButton {
                                            Button {
                                                playViewModel.deleteButton(at: index)
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(.red)
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                        }
                                    }
                                    .sheet(isPresented: $showModal) {
                                        ButtonSettingView(buttonTitle: $playViewModel.padButtons[buttonSettingIndex].buttonTitle, buttonColor: $playViewModel.padButtons[buttonSettingIndex].buttonColor, showModal: $showModal, audioIndex: $playViewModel.padButtons[buttonSettingIndex].audioIndex, audioPlayer: $playViewModel.padButtons[buttonSettingIndex].audioPlayer, audioViewModel: audioViewModel)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Play view", displayMode: .inline)
                .navigationBarItems(trailing:
                                        HStack(spacing: 0) {
                    if playViewModel.pushedSettingButton {
                        Button {
                            playViewModel.addButton()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .alert(isPresented: $playViewModel.showAlert) {
                            Alert(title: Text("これ以上はボタンを追加できません"))
                        }
                    }
                    Button(playViewModel.pushedSettingButton ? "Done" : "Edit") {
                        playViewModel.pushedSettingButton.toggle()
                    }
                })
            }
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(playViewModel: .init(), audioViewModel: .init())
    }
}

