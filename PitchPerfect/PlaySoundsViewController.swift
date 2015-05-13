//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Annette Undheim on 12/05/15.
//  Copyright (c) 2015 Annette Undheim. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true;
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
        Play back recorded audio at half speed
    */
    @IBAction func playSoundSlow(sender: UIButton) {
        playAudio(0.5)
    }
    
    /**
        Play back recorded audio at twice the speed
    */
    @IBAction func playAudioFast(sender: UIButton) {
        playAudio(2.0)
    }
    
    /**
        Play back recorded audio with increased pitch
        making it sound like a chipmunk
    */
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    /**
        Play back recorded audio reduced pitch making it sound like Darth Vader
    */
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    /**
        Play back recorded audio at pitch set by parameter
        :param: pitch
    */
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    /**
        Play back recorded audio at rate set by parameter
        :param: playbackRate
    */
    func playAudio(playbackRate: Float){
        audioPlayer.stop()
        audioPlayer.rate = playbackRate
        audioPlayer.currentTime = 0.0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    /**
        Stop audio playback
    */
    @IBAction func stopAudioPlayback(sender: UIButton) {
        audioPlayer.stop()
    }
    

}
