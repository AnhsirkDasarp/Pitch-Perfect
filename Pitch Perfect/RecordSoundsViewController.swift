//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Prasad on 8/7/17.
//  Copyright © 2017 Advaitham. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stopRecordButton.isEnabled = false
    }
    
    
    
    @IBAction func startRecording(_ sender: Any) {
        
        print("start recording")
        configureUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath ?? "no url available to print")
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        print("stop recording")
        configureUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        
    }
    
    func configureUI(isRecording: Bool) {
        // based on parameter value, code for enabling and disabling
        // the recording and stop buttons, and setting the label text
        
        if isRecording {
            recordingLabel.text="Recording..."
            stopRecordButton.isEnabled = true
            recordButton.isEnabled = false
        }else{
            recordingLabel.text = "tap to start recording"
            stopRecordButton.isEnabled=false
            recordButton.isEnabled=true
        }
        
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        }else{
            print("recording was not successful")
            showAlert()
            
        }
        
        print("finished recording")
        
    }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Crap", message: "The recording failed. Please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier=="stopRecording"){
            let playsoundsVC = segue.destination as! PlaysoundViewController
            let recordedAudioURL = sender as! URL
            playsoundsVC.recordedAudioURL = recordedAudioURL
        }
        
    }
    
}

