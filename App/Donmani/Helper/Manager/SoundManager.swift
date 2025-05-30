//
//  SoundManager.swift
//  Donmani
//
//  Created by 문종식 on 5/30/25.
//

import AVFoundation

import Foundation
import AVFoundation

public final class SoundManager {
    public static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}

    /// mp3 파일을 재생합니다.
    /// - Parameters:
    ///   - fileName: mp3 파일명 (확장자 제외)
    ///   - bundle: 번들 (기본값: .designSystem)
    public func play(fileName: String) {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("SoundManager: Failed to set audio session - \(error.localizedDescription)")
        }
        
        guard let url = Bundle.designSystem.url(forResource: fileName, withExtension: "mp3") else {
            print("SoundManager: \(fileName).mp3 not found in bundle.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
        } catch {
            print("SoundManager: Failed to play \(fileName).mp3 - \(error.localizedDescription)")
        }
    }

    /// 현재 재생 중인 사운드를 일시정지합니다.
    public func pause() {
        guard let player = audioPlayer, player.isPlaying else { return }
        player.pause()
    }

    /// 현재 재생 중인 사운드를 정지합니다.
    public func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
