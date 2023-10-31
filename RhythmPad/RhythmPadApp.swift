import SwiftUI

@main
struct RhythmPadApp: App {
    private let playViewModel = PlayViewModel()
    private let audioViewModel = AudioViewModel()
    var body: some Scene {
        WindowGroup {
            MainTabView(playViewModel: playViewModel, audioViewModel: audioViewModel)
        }
    }
}
