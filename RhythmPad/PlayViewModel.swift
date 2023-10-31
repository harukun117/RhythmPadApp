import Foundation

class PlayViewModel: ObservableObject {
    @Published var pushedSettingButton: Bool = false
    @Published var buttonIDs: Array<Int> = Array()
    @Published var padButtons: Array<PadButton> = Array()
    @Published var buttonID: Int = 0

    func addButton(audioViewModel: AudioViewModel) {
        padButtons.append(PadButton(id: buttonID, playViewModel: self, audioViewModel: audioViewModel))
        buttonIDs.append(buttonID)
        buttonID += 1
    }

    func deleteButton(at id: Int) {
        if let deleteToIndex = buttonIDs.firstIndex(of: id) {
            buttonIDs.remove(at: deleteToIndex)
            padButtons.remove(at: deleteToIndex)
        } else {
            print("Invalid index")
        }
    }
}
