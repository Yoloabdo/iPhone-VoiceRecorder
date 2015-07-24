//
//  PlaySoundViewController.swift
//  Record Teen
//
//  Created by abdelrahman mohamed on 7/16/15.
//  Copyright (c) 2015 abdelrahman mohamed. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    
    @IBOutlet weak var audioPlayerBar: UISlider!
    
    var audioPlayer = AVAudioPlayer()
    var recievedAudio: RecordedAudio!

    var isPlaying = false
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    

    @IBOutlet weak var timeViewer: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // handling the audio attachment
//        var filePath = NSBundle.mainBundle().URLForResource("movie_quote", withExtension: "mp3")
//        var error:NSError?
        
        
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // handling the playbar limits
        
        // Do any additional setup after loading the view.
        
        //chipmunk addition 
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playRate(rate:Float) -> Void{
        audioEngine.stop()
        audioPlayer.stop()
    
        audioPlayer.rate = rate
        audioPlayer.play()
        
        // starting timer
    }
   
    @IBAction func playSlowSound(sender: UIButton) {
        playRate(0.5)
    }


    @IBAction func playFastSound(sender: UIButton) {
        playRate(2.0)
    }
    
    @IBAction func stopPlayingAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }

    @IBAction func SliderChange(sender: UISlider) {
        audioPlayer.stop()
        var newTime = audioPlayerBar.value
        audioPlayer.currentTime = NSTimeInterval(newTime)
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(500)

    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
