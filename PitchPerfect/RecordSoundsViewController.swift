//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Annette Undheim on 11/05/15.
//  Copyright (c) 2015 Annette Undheim. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Declare global variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    // Declare constants
    let recordingText = "recording"
    let tapToRecordText = "Tap to record"
    let sequeIdentifier = "stopRecording"
    let recordingFileFormat = "ddMMyyyy-HHmmss"

    // Declaration of buttons and labels
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    /**
        viewDidLoad
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /**
        didReceiveMemoryWarning
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
        viewWillAppear
        Set recordButton to enabled
        Set stopButton, pauseButton and resumeButton to disabled
        Set text below record button to "Tap to record"
    */
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.enabled = false
        pauseButton.enabled = false
        resumeButton.enabled = false
        recordingInProgress.text = tapToRecordText
    }

    /**
        Starts audio recording when the user presses a button
        The recording is saved in the documents directory
        with filename of current date and time
    */
    @IBAction func recordAudio(sender: UIButton) {
        
        // Set flags
        recordButton.enabled = false;
        stopButton.enabled = true
        pauseButton.enabled = true;
        recordingInProgress.text = recordingText
        
        // Create audiosession and set category to only record
        // Setting is to play and record makes the volume affected
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryRecord, error: nil)
        
        // Create audiorecorder and record
        audioRecorder = AVAudioRecorder(URL: createRecordingFileName(), settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    /**
        Create filename for recording from current date and time
        and return filename as NSURL
    */
    func createRecordingFileName() -> NSURL{
    
        // get path for documents directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // create recording filename from current date time
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = recordingFileFormat
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        return NSURL.fileURLWithPathComponents(pathArray)!
    }
    
    /**
        Delegate for when audio has finished recording
        If recording is successful, assign filename of last recording
        to RecordedAudio and send to segue
    */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag){
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        self.performSegueWithIdentifier(sequeIdentifier, sender: recordedAudio)
        
        }
        else{
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    /**
        Prepare for segue
        Set destination viewcontroller to PlaySoundsViewController
        and provide receivedAudio
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == sequeIdentifier){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    /**
        Pause recording. This is called when user presses the pause button
    */
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        pauseButton.enabled = false
        resumeButton.enabled = true
    }
    
    /**
        Resume recording. This is called when user presses the pause button
    */
    @IBAction func resumeRecording(sender: UIButton) {
        
        // resume recording
        audioRecorder.record()
        
        resumeButton.enabled = false
        stopButton.enabled = true
        pauseButton.enabled = true
    }
    
    /**
        Stop recording. This is called when user presses the stop button
    */
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        
        // set stop, pause and  and stop button to disabled
        stopButton.enabled = false
        pauseButton.enabled = false
        resumeButton.enabled = false
        
        recordingInProgress.text = tapToRecordText
        var audioSession = AVAudioSession.sharedInstance()
        
        // Set category to only playback, otherwise the volume is affected (becomes too low)
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioSession.setActive(false, error: nil)
        
    }
}

