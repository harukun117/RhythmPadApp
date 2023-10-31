import SwiftUI
import RealmSwift

struct SwiftUIView: View {
    var body: some View {
        Button("a") {
            let realm = try! Realm()
            _ = realm.objects(RecordAudio.self)
            try! realm.write {
                realm.deleteAll()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
