//
//  AudioSettingView.swift
//  RhythmPad
//
//  Created by Nakano Haru on 2023/10/09.
//

import SwiftUI

struct AudioSettingView: View {
    @Binding var showModal: Bool
    @State var audioName: String
    @State var showAlert = false
    @State var showCutSlider = false
    @ObservedObject var audioViewModel: AudioViewModel
    private var index: Int

    init(showModal: Binding<Bool>, audioViewModel: AudioViewModel, index: Int) {
        _showModal = showModal
        self.audioViewModel = audioViewModel
        self.index = index
        self.audioName = audioViewModel.audioItems[index].audioName
    }

    var body: some View {
        NavigationView {
            if audioViewModel.isLoading {
                ProgressView("Loading...")
            } else {
                VStack(spacing: 0) {
                    TextField("入力してください", text: $audioName)
                        .frame(height: 36)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1)
                        )
                    Button {
                        if audioViewModel.isPlaying {
                            audioViewModel.pauseAudio()
                            audioViewModel.stopTimer()
                        } else {
                            audioViewModel.startTimer()
                            audioViewModel.play(player: audioViewModel.audioPlayer)
                        }
                    } label: {
                        Image(systemName: audioViewModel.isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                    Slider(value: $audioViewModel.currentTime, in: 0...audioViewModel.totalTime, onEditingChanged: { _ in
                        audioViewModel.seek()
                    })
                    .onReceive(audioViewModel.timer) { _ in
                        if audioViewModel.isPlaying {
                            audioViewModel.currentTime = audioViewModel.getAudioPlayerCurrentTime()
                        } else {
                            audioViewModel.stopTimer()
                        }
                    }
                    Text(String(audioViewModel.totalTime))
                    Text(String(audioViewModel.totalTime - audioViewModel.currentTime))
                    Button(showCutSlider ? "完了" : "切り取る") {
                        if showCutSlider {
                            audioViewModel.trimAudio(at: index)
                            showCutSlider = false
                        } else {
                            showCutSlider = true
                        }
                    }
                    if showCutSlider {
                        Slider(value: $audioViewModel.startSeconds, in : 0...audioViewModel.totalTime)
                        Slider(value: $audioViewModel.endSeconds, in : 0...audioViewModel.totalTime)
                    }
                }
                .navigationBarTitle("Audio Settings", displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") {
                    if audioName.isEmpty {
                        showAlert = true
                    } else {
                        audioViewModel.updateAudioName(itemIndex: index, newName: audioName)
                        showModal = false
                    }
                }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Please enter audio name!!"))
                    }
                )
            }

        }
        .onAppear {
            audioViewModel.audioPlayer = audioViewModel.setUpAudio(at: index)
            audioViewModel.getAudioLength()
            audioViewModel.currentTime = 0.0
        }
    }
}


struct AudioSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AudioSettingView(showModal: .constant(true), audioViewModel: .init(), index: 1)
    }
}
