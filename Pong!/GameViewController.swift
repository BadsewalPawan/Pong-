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

class GameViewController: UIViewController {

    var timer = Timer()
    @IBOutlet var backBtn: UIButton!
    
    @objc func dimBackBtn(){
        UIView.animate(withDuration: 1, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.backBtn.alpha = 0.6
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(dimBackBtn), userInfo: nil, repeats: false)
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene"){
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = view.bounds.size 
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { return .bottom }
    
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
