import RealmSwift
import AVFoundation
import SwiftUI

class AudioViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var audioItems: Array<RecordAudio> = Array<RecordAudio>()
    private var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    @Published var currentTime : TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 1
    @Published var startSeconds: TimeInterval = 1
    @Published var endSeconds: TimeInterval = 3
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @Published var isPlaying = false
    @Published var isLoading: Bool = false
    private var audioFileURL: URL?
    private var audioFileName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return (dateFormatter.string(from: Date())) + ".m4a"
    }

    override init() {
        super.init()
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        fetchData()
    }

    func fetchData() {
        DispatchQueue.main.async { [self] in
            guard let realm = try? Realm() else {
                return
            }
            let items = realm.objects(RecordAudio.self)
            audioItems = items.compactMap({ (item) -> RecordAudio? in
                return item
            })
        }

    }

    func startTimer() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    }

    func stopTimer() {
        timer.upstream.connect().cancel()
    }

    func getAudioPlayerCurrentTime() -> Double {
        if let audioPlayer = audioPlayer {
            return audioPlayer.currentTime
        }
        return 0
    }

    func getAudioLength() {
        if let audioPlayer = audioPlayer {
            self.totalTime = audioPlayer.duration
        }
    }
    func updateCurrentTime() {
        if let audioPlayer = audioPlayer {
            self.currentTime = audioPlayer.currentTime
        }
    }

    func setUpAudio(at index: Int) -> AVAudioPlayer? {
        guard index >= 0 && index < audioItems.count else {
            print("Invalid index")
            return nil
        }
        let playItem = audioItems[index]
        do {
            if isPlaying {
                pauseAudio()
                return nil
            } else {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: playItem.filePath) {
                    let audioURL = URL(fileURLWithPath: playItem.filePath)
                    let audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                    return audioPlayer
                } else {
                    return nil
                }
            }
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
            return nil
        }

    }

    func play(player: AVAudioPlayer?) {
        if let player = player {
            player.delegate = self
            if player.isPlaying {
                player.stop()
                player.currentTime = 0
            }
            player.prepareToPlay()
            player.play()
            isPlaying = true
        }
    }
    

    func pauseAudio() {
        if let audioPlayer = audioPlayer {
            audioPlayer.pause()
            isPlaying = false
        }
    }

    func stopAudio(player: AVAudioPlayer) {
        player.stop()
        isPlaying = false
    }

    func seek() {
        if let audioPlayer = audioPlayer {
            audioPlayer.currentTime = currentTime
        }
    }

    func recording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            audioFileURL = documentsDirectory.appendingPathComponent(audioFileName)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFileURL!, settings: settings)
            audioRecorder?.record()
        } catch {
            print("Error initializing audio recorder: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        if let audioRecorder = audioRecorder {
            audioRecorder.stop()
            saveAudio()
        }
    }

    private func saveAudio() {
        print("登録します")
        guard let audioFileURL = audioFileURL else {
            return
        }

        do {

            let realm = try Realm()

            try realm.write {
                let audioData = RecordAudio()
                audioData.audioName = "new audio"
                audioData.filePath = audioFileURL.path
                realm.add(audioData)
                print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
            }
            fetchData()
        } catch {
            print("Error saving audio to Realm: \(error.localizedDescription)")
        }
    }

    func trimAudio(at index: Int) {
        guard index >= 0 && index < audioItems.count else {
            print("Invalid index")
            return
        }
        let playItem = audioItems[index]

        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: playItem.filePath) {
            let audioURL = URL(fileURLWithPath: playItem.filePath)
            let asset = AVAsset(url: audioURL)
            let startTime = CMTimeMakeWithSeconds(startSeconds, preferredTimescale: 1000)
            let endTime = CMTimeMakeWithSeconds(endSeconds, preferredTimescale: 1000)

            let exportTimeRange = CMTimeRange(start: startTime, duration: endTime)

            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            audioFileURL = documentsDirectory.appendingPathComponent(audioFileName)

            let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
            exporter?.outputFileType = AVFileType.m4a
            exporter?.timeRange = exportTimeRange
            exporter?.outputURL = audioFileURL

            exporter?.exportAsynchronously {
                switch exporter!.status {
                case .completed:
                    self.saveAudio()
                case .failed, .cancelled:
                    print("Error: \(exporter?.error?.localizedDescription ?? "Unknown Error")")
                default:
                    print("Error: Unknown Error")
                }
            }
        }
    }

    func deleteAudioFile(at indexSet: IndexSet) {
        guard let firstIndex = indexSet.first else {
            return
        }
        print(firstIndex)
        print(audioItems.count)
        if firstIndex >= 0 && firstIndex < audioItems.count {

            do {
                let realm = try Realm()
                let itemToDelete = audioItems[firstIndex]
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: itemToDelete.filePath) {
                    try fileManager.removeItem(atPath: itemToDelete.filePath)
                    print(itemToDelete.filePath + "を削除")
                }
                try realm.write {
                    realm.delete(itemToDelete)
                    print("Realmファイルも削除しました")
                }
                fetchData()
            } catch {
                print("エラーが発生しました: \(error)")
            }
        } else {
            print("そのインデックスはない")
            return
        }
    }

    func updateAudioName(itemIndex: Int, newName: String) {
        guard itemIndex >= 0 && itemIndex < audioItems.count else {
            print("Invalid index")
            return
        }

        do {
            let realm = try Realm()
            let item = realm.objects(RecordAudio.self).where({ $0.filePath == audioItems[itemIndex].filePath})
            if item.count == 1 {
                try realm.write {
                    item[0].audioName = newName
                }
            }
            fetchData()
        } catch {
            print("Error update audio to Realm: \(error.localizedDescription)")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // 音声再生が正常に終了した場合の処理
            stopAudio(player: player) // 音声を停止
        }
    }
}

