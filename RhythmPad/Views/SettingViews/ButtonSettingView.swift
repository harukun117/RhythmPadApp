//
//  ButtonSetting.swift
//  RhythmPad
//
//  Created by Nakano Haru on 2023/09/23.
//

import SwiftUI
import AVFoundation

struct ButtonSettingView: View {
    private let colors = [Color.black, Color.white, Color.red, Color.blue, Color.yellow, Color.green, Color.orange, Color.cyan, Color.brown, Color.pink, Color.purple, Color.gray]
    @Binding var buttonTitle: String
    @Binding var buttonColor: Color
    @Binding var showModal: Bool
    @Binding var audioIndex: Int
    @Binding var audioPlayer: AVAudioPlayer?
    @StateObject var audioViewModel: AudioViewModel
    
    init(buttonTitle: Binding<String>, buttonColor: Binding<Color>, showModal: Binding<Bool>, audioIndex: Binding<Int>, audioPlayer: Binding<AVAudioPlayer?>, audioViewModel: AudioViewModel) {
        _buttonTitle = buttonTitle
        _buttonColor = buttonColor
        _showModal = showModal
        _audioIndex = audioIndex
        _audioPlayer = audioPlayer
        _audioViewModel = StateObject(wrappedValue: audioViewModel)
    }
    var body: some View {
        NavigationView {
            Form {
                
                HStack(spacing: 0) {
                    Text("Button Name")
                        .padding(.trailing, 5)
                    TextField("Name", text: $buttonTitle)
                        .frame(height: 36)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1)
                        )
                    
                }
                HStack(spacing: 0) {
                    Text("Button Color")
                    Picker("", selection: $buttonColor) {
                        ForEach(colors, id: \.self) {color in
                            Text("color")
                                .frame(maxWidth: .infinity)
                                .background(color)
                                .foregroundColor(color)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                HStack(spacing: 0) {
                    Text("audio")
                    if audioViewModel.audioItems.count == 0 {
                        Text("There is no data")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        Picker("", selection: $audioIndex) {
                            ForEach(audioViewModel.audioItems.indices, id: \.self) { index in
                                Text(audioViewModel.audioItems[index].audioName)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .onChange(of: audioIndex) {newValue in
                            audioPlayer = audioViewModel.setUpAudio(at: newValue)

                        }
                    }

                }
            }
            .navigationBarTitle("Button settings", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                showModal = false
                print(showModal)
            })
        }
    }
}

struct ButtonSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonSettingView(buttonTitle: .constant(""), buttonColor: .constant(.gray), showModal: .constant(true), audioIndex: .constant(0), audioPlayer: .constant(nil), audioViewModel: .init())
    }
}
