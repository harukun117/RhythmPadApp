//
//  ButtonInformation.swift
//  RhythmPad
//
//  Created by Nakano Haru on 2023/11/01.
//

import Foundation
import SwiftUI
import AVFAudio

struct ButtonInformation {
    var index: Int = 0
    var buttonTitle: String = "button"
    var buttonColor: Color = .white
    var audioIndex: Int = 0
    var audioPlayer: AVAudioPlayer? = nil
}
