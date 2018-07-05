//
//  GameViewController.swift
//  Pong!
//
//  Created by Pawan Badsewal on 27/06/18.
//  Copyright © 2018 Pawan Badsewal. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var currentGameMode:gameMode!
var impulseForce:Double = 2

class GameViewController: UIViewController {

    var timer = Timer()
    
    
    @IBAction func reset(_ sender: UIButton) {
        timer.invalidate()
        impulseForce = 3
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene"){
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = view.bounds.size 
                // Present the scene
                view.presentScene(scene)
            }
            timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { _ in
                impulseForce += 0.5
            })
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
