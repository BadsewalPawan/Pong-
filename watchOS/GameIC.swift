//
//  InterfaceController.swift
//  watchOS Extension
//
//  Created by Pawan Badsewal on 11/03/19.
//  Copyright © 2019 Pawan Badsewal. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

var skInterfaceFrame:CGRect!


class GameIC : WKInterfaceController {

    var AudioPlayer: AVAudioPlayer!
    var gameScene = GameScene(fileNamed: "GameScene")
    
    @IBOutlet var skInterface: WKInterfaceSKScene!
    
    func playAudio(){
        let path = Bundle.main.path(forResource: "BackgroundMusic" , ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do{
            AudioPlayer = try AVAudioPlayer(contentsOf: url)
            AudioPlayer.prepareToPlay()
        }
        catch let error as NSError{
            print(error.description)
        }
        AudioPlayer.volume = 1
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        gameScene!.changeTheme()
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        // Load the SKScene from 'GameScene.sks'
        if let scene = gameScene {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            skInterface.presentScene(scene)
            crownSequencer.delegate = scene
            playAudio()
            // Use a value that will maintain a consistent frame rate
            self.skInterface.preferredFramesPerSecond = 30
        }
    }
    
    override func didAppear() {
        super.didAppear()
        crownSequencer.focus()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
