import Foundation
import SwiftUI

struct PlayView: View {
    @State var showAlert = false
    @ObservedObject var playViewModel: PlayViewModel
    private let audioViewModel: AudioViewModel

    init(playViewModel: PlayViewModel, audioViewModel: AudioViewModel) {
        self.playViewModel = playViewModel
        self.audioViewModel = audioViewModel
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: 0) {
                    if playViewModel.buttonIDs.count == 0 {
                        Text("add button")
                        Button {
                            playViewModel.addButton(audioViewModel: audioViewModel)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    ForEach(0 ..< 4) { index in
                        if playViewModel.buttonIDs.count > index * 3 {
                            HStack(spacing: 0) {
                                ForEach(playViewModel.buttonIDs[index * 3 ..< playViewModel.buttonIDs.count], id: \.self) { id in
                                    if let getIndex = playViewModel.padButtons.firstIndex(where: {$0.id == id}) {
                                        if getIndex < index * 3 + 3 {
                                            playViewModel.padButtons[getIndex]
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
                                if playViewModel.buttonIDs.count != 12 {
                                    playViewModel.addButton(audioViewModel: audioViewModel)
                                } else {
                                    showAlert = true
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("これ以上はボタンを追加できません"))
                            }
                        }
                        Button(playViewModel.pushedSettingButton ? "Done" : "Button edit") {
                            playViewModel.pushedSettingButton.toggle()
                        }
                    }

                    )
                }
            }
        }
    }

}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(playViewModel: .init(), audioViewModel: .init())
    }
}

