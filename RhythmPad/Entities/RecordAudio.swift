import RealmSwift
import Foundation

class RecordAudio: Object {
    @Persisted var audioName: String = ""
    @Persisted var filePath: String = ""
    @Persisted var recordingDate: Date = Date()
}

