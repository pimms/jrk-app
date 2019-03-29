//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import AVFoundation

class StreamPlayer {

    // MARK: - Public properties

    // MARK: - Private properties

    let player: AVPlayer
    let audioSession: AVAudioSession

    // MARK: - Init

    init(streamUrl: URL) {
        player = AVPlayer(url: streamUrl)

        audioSession = AVAudioSession()
        try? audioSession.setCategory(.playback, mode: .spokenAudio, options: [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP, .interruptSpokenAudioAndMixWithOthers])
        try? audioSession.setActive(true, options: [])
    }

    // MARK: - Private methods

    // MARK: - Public methods

    func isPlaying() -> Bool {
        return player.rate > 0.01 && player.error == nil
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }
}
