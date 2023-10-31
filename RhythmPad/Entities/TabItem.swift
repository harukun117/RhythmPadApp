import SwiftUI

enum TabItem: CaseIterable {
    case play
    case recordingList
}

extension TabItem {
    var image: Image {
        switch self {
        case .play:
            return Image(systemName: "music.note")
        case .recordingList:
            return Image(systemName: "folder")
        }
    }

    var title: String {
        switch self {
        case .play:
            return "play"
        case .recordingList:
            return "record audio"
        }
    }
}
