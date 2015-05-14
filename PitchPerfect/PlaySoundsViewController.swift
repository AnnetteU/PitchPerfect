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

        // Initialise main audio player and audio player for echo effect
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true;        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    /*
        didReceiveMemoryWarning
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
        Play back recorded audio at half speed
    */
    @IBAction func playSoundSlow(sender: UIButton) {
        playAudio(0.5)
    }
    
    /*
        Play back recorded audio at twice the speed
    */
    @IBAction func playAudioFast(sender: UIButton) {
        playAudio(2.0)
    }
    
    /*
        Play back recorded audio with increased pitch
        making it sound like a chipmunk
    */
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    /*
        Play back recorded audio reduced pitch making it sound like Darth Vader
    */
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    /*
        Play back recorded audio with echo
    */
    @IBAction func playEchoAudio(sender: UIButton) {
        playEcho()
    }
    
    /*
        Play back recorded audio at pitch set by parameter
        :param: pitch
    */
    func playAudioWithVariablePitch(pitch: Float){
        
        // Stop audioplayers and reset audioengine
        stopAndResetAudioPlayersAndEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Add pitch effect
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect audio nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Schedule file to play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // Play audio file
        audioPlayerNode.play()
    }
    
    /*
        Play back the sound with echo
    */
    func playEcho() {
        
        // stop and reset audio
        stopAndResetAudioPlayersAndEngine()
        
        // add echo node and set delaytime
        var echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.3)
        
        // add audio player node for echo
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Attach the audio effect node corresponding to the user selected effect
        audioEngine.attachNode(echoNode)
        
        // Connect Player --> AudioEffect
        audioEngine.connect(audioPlayerNode, to: echoNode, format: audioFile.processingFormat)
        
        // Connect AudioEffect --> Output
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        // Schedule and play file
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler:nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    /*
        Play back recorded audio at rate set by parameter
        :param: playbackRate
    */
    func playAudio(playbackRate: Float){
        
        // stop and reset audio
        stopAndResetAudioPlayersAndEngine()
        
        audioPlayer.rate = playbackRate
        audioPlayer.currentTime = 0.0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    /*
        Stop audio playback
    */
    @IBAction func stopAudioPlayback(sender: UIButton) {
        stopAndResetAudioPlayersAndEngine()
    }
    
    /*
        Stop audio players and stop and reset audio engine
    */
    func stopAndResetAudioPlayersAndEngine(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    

}
