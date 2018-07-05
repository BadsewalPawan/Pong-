//
//  GameScene.swift
//  Pong!
//
//  Created by Pawan Badsewal on 27/06/18.
//  Copyright © 2018 Pawan Badsewal. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var score = [Int]()
    var ball = SKSpriteNode()
    var player = SKSpriteNode()
    var enemy = SKSpriteNode()
    var enemylbl = SKLabelNode()
    var playerlbl = SKLabelNode()
    var timer = Timer()
    
    
    func startGame(){
        score = [0,0]
        playerlbl.text = String(score[0])
        enemylbl.text = String(score[1])
        ball.physicsBody?.applyImpulse(CGVector(dx: impulseForce, dy: impulseForce))
    }
    
    func updateScore(whoWon:SKSpriteNode){
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        if(whoWon == player){
            score[0] += 1
            playerlbl.text = String(score[0])
        }else{
            score[1] += 1
            enemylbl.text = String(score[1])
        }
    }
    
    @objc func resetGame(){
        if(arc4random_uniform(2) == 0){
            ball.physicsBody?.applyImpulse(CGVector(dx: impulseForce, dy: impulseForce))
        }else{
            ball.physicsBody?.applyImpulse(CGVector(dx: -impulseForce, dy: -impulseForce))
        }
    }
    
    
    override func didMove(to view: SKView) {
        playerlbl = self.childNode(withName: "playerlbl") as! SKLabelNode
        enemylbl = self.childNode(withName: "enemylbl") as! SKLabelNode
        player = self.childNode(withName: "playerPaddle") as! SKSpriteNode
        player.position.y = (-self.frame.height/2) + 50
        enemy = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        enemy.position.y = (self.frame.height/2) - 50
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        startGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if(currentGameMode == .friendly){
                if(location.y > 0){
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.1))
                }
                if(location.y < 0){
                    player.run(SKAction.moveTo(x: location.x, duration: 0.1))
                }
            }else{
                player.run(SKAction.moveTo(x: location.x, duration: 0.1))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if(currentGameMode == .friendly){
                if(location.y > 0){
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.1))
                }
                if(location.y < 0){
                    player.run(SKAction.moveTo(x: location.x, duration: 0.1))
                }
            }else{
                player.run(SKAction.moveTo(x: location.x, duration: 0.1))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        switch currentGameMode {
        case .ai:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
        case .friendly:
            break
        default:
            break
        }
        if(ball.position.y <= player.position.y - 30){
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(resetGame), userInfo: nil, repeats: false)
            updateScore(whoWon: enemy)
        }else if(ball.position.y >= enemy.position.y + 30){
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(resetGame), userInfo: nil, repeats: false)
            updateScore(whoWon: player)
        }
    }
}
