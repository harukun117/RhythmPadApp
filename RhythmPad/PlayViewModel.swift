import Foundation
import SwiftUI
import AVFoundation

class PlayViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var pushedSettingButton: Bool = false
    @Published var padButtons: Array<ButtonInformation> = Array()


    func addButton() {
        if padButtons.count < 12 {
            padButtons.append(ButtonInformation())
        } else {
            showAlert = true
        }
    }

    func deleteButton(at index: Int) {
        padButtons.remove(at: index)
        for i in 0 ..< padButtons.count {
            padButtons[i].index = i
        }
    }

    func check(index: Int, i: Int) -> Bool {
        if index < i * 3 + 3 {
            return true
        } else {
            return false
        }
    }
}
