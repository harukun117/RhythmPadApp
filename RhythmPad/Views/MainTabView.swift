import SwiftUI

struct MainTabView: View {
    @State private var selection: TabItem = .play
    private let playViewModel: PlayViewModel
    private let audioViewModel: AudioViewModel

    init(playViewModel: PlayViewModel, audioViewModel: AudioViewModel) {
        self.playViewModel = playViewModel
        self.audioViewModel = audioViewModel
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(TabItem.allCases, id: \.self) { tabItem in
                tabItemView(from: tabItem)
                    .tabItem {
                        tabItem.image
                        Text(tabItem.title)
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .tag(tabItem)
            }
        }
        .tint(.blue)
    }

    @ViewBuilder
    func tabItemView(from tabItem: TabItem) -> some View {
        switch tabItem {
        case .play:
            PlayView(playViewModel: playViewModel, audioViewModel: audioViewModel)
        case .recordingList:
            AudioRecordingView(audioViewModel: audioViewModel)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(playViewModel: .init(), audioViewModel: .init())
    }
}
