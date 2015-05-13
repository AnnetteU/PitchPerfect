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
    
    //Declare global variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    // Constants
    let recordingText = "recording"
    let tapToRecordText = "Tap to record"
    let sequeIdentifier = "stopRecording"
    let recordingFileFormat = "ddMMyyyy-HHmmss"

    // Declaration of buttons and labels
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true;
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
        stopButton.hidden = false;
        recordingInProgress.text = recordingText
        
        // create audiosession and set category
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // create audiorecorder and record
        audioRecorder = AVAudioRecorder(URL: createRecordingFileName(), settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    /**
        Create filename for recording from current date and time
        and saves in users document directory
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
        Stop recording. This is called when user presses the stop button
    */
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.text = tapToRecordText
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
}

