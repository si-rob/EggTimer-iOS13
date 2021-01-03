//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimes : [String : Int] = ["Soft": 5, "Medium": 420, "Hard": 720]
    var timer:Timer?
    
    var totalTime = 0
    var secondsPassed = 0
    var player: AVAudioPlayer?
    var eggType: String = ""

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eggCookProgress: UIProgressView!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer?.invalidate()
        secondsPassed = 0

        let hardness = sender.currentTitle!
        eggType = hardness
        totalTime = eggTimes[hardness]!
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer?.tolerance = 0.2

    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    @objc func updateTimer()
    {
        if secondsPassed < totalTime {
            secondsPassed += 1
            let percentageProgress = Float(secondsPassed) / Float(totalTime)
            eggCookProgress.setProgress(percentageProgress, animated: true)
            let secondsUntilDone = totalTime - secondsPassed
            
            titleLabel.text = "\(eggType)\n\(secondsUntilDone) seconds until done!"
            titleLabel.text = titleLabel.text?.uppercased()

        }

        if secondsPassed >= totalTime {
            timer?.invalidate()
            timer = nil
            titleLabel.text = "DONE!!"
            playSound()
        }
    }
    
    
}
