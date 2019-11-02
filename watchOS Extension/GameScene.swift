//
//  GameScene.swift
//  watchOS Extension
//
//  Created by Pawan Badsewal on 11/03/19.
//  Copyright © 2019 Pawan Badsewal. All rights reserved.
//

import SpriteKit
import GameKit
import WatchKit

class GameScene: SKScene, SKPhysicsContactDelegate, WKCrownDelegate{
    
    var impulseForce:Double = 1.5
    var aiReactionTime:Double = 0.05
    var iCount:Int = 0
    var angleDiversionX:Double!
    var angleDiversionY:Double!
    var score = [Int]()
    var ball = SKSpriteNode()
    var player = SKSpriteNode()
    var enemy = SKSpriteNode()
    var enemylbl = SKLabelNode()
    var playerlbl = SKLabelNode()
    var timer = Timer()
    var looseDetectTimer = Timer()
    var enemyLooses:Bool = false
    var enemySide:Bool = false
    var selectedColorIndex:Int = 0
    var paddleColor:Array<Array<UIColor>> = [[#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)], [#colorLiteral(red: 0, green: 0.814856112, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8491321206, blue: 0.2452769876, alpha: 1)], [#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)]]
    
    func setupPaddle(targetPaddle: SKSpriteNode, targetTexture: String, xPos:CGFloat, targetlbl:SKLabelNode, targetlblColor:UIColor){
        targetlbl.fontColor = targetlblColor
        targetPaddle.position.x = xPos
        targetPaddle.texture = SKTexture(imageNamed: targetTexture)
        targetPaddle.physicsBody = SKPhysicsBody(texture: targetPaddle.texture!, size: targetPaddle.size)
        targetPaddle.physicsBody?.affectedByGravity = false
        targetPaddle.physicsBody?.allowsRotation = false
        targetPaddle.physicsBody?.isDynamic = false
        targetPaddle.physicsBody?.pinned = false
        targetPaddle.colorBlendFactor = 1
        targetlbl.colorBlendFactor = 1
        updateColor()
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
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        let playerPosition = player.position.y + CGFloat(rotationalDelta * 2500)
        if(playerPosition > scene!.frame.height/2){
            player.run(SKAction.moveTo(y: scene!.frame.height/2, duration: 0.1))
        }else if(playerPosition < -scene!.frame.height/2){
            player.run(SKAction.moveTo(y: -scene!.frame.height/2, duration: 0.1))
        }else{
            player.run(SKAction.moveTo(y: playerPosition, duration: 0.1))
        }
    }
    
    func changeTheme(){
        selectedColorIndex += 1
        updateColor()
    }
    
    func strikeBall(){
        enemySide = !enemySide
        angleDiversionX = Double(arc4random_uniform(9)/10)
        angleDiversionY = Double(arc4random_uniform(9)/10)
        let randNum = arc4random_uniform(2)
        switch enemySide {
        case true:
            if(randNum == 0){
                ball.physicsBody?.applyImpulse(CGVector(dx: -impulseForce-angleDiversionX, dy: impulseForce+angleDiversionY))
            }else{
                ball.physicsBody?.applyImpulse(CGVector(dx: -impulseForce-angleDiversionX, dy: -impulseForce-angleDiversionY))
            }
        default:
            if(randNum == 0){
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseForce+angleDiversionX, dy: impulseForce+angleDiversionY))
            }else{
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseForce+angleDiversionX, dy: -impulseForce-angleDiversionY))
            }
        }
    }
    
    func updateColor(){
        if(selectedColorIndex == paddleColor.count){
            selectedColorIndex = 0
            let action = SKAction.colorize(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), colorBlendFactor: 1, duration: 0.5)
            player.run(action)
            playerlbl.run(action)
            enemy.run(action)
            enemylbl.run(action)
        }else{
            player.color = paddleColor[selectedColorIndex][0]
            playerlbl.color = paddleColor[selectedColorIndex][0]
            enemy.color = paddleColor[selectedColorIndex][1]
            enemylbl.color = paddleColor[selectedColorIndex][1]
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if !(contact.bodyA.node?.name == nil) {
            WKInterfaceDevice.current().play(.click)}
    }
    
    @objc func resetGame(){
        enemyLooses = false
        angleDiversionX = Double(arc4random_uniform(9)/10)
        angleDiversionY = Double(arc4random_uniform(9)/10)
        strikeBall()
    }
    
    @objc func makeLose(){
        if(arc4random_uniform(11) < 4){
            enemyLooses = true
        }
    }
    
    @objc func startGame(){
        score = [0,0]
        playerlbl.text = String(score[0])
        enemylbl.text = String(score[1])
        strikeBall()
    }
    
    
    
    override func sceneDidLoad() {
        playerlbl = self.childNode(withName: "playerlbl") as! SKLabelNode
        enemylbl = self.childNode(withName: "enemylbl") as! SKLabelNode
        player = self.childNode(withName: "playerPaddle") as! SKSpriteNode
        setupPaddle(targetPaddle: player, targetTexture: "paddle", xPos: (self.frame.width/2) - 15, targetlbl: playerlbl, targetlblColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        enemy = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        setupPaddle(targetPaddle: enemy, targetTexture: "paddle", xPos: (-self.frame.width/2) + 15, targetlbl: enemylbl, targetlblColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startGame), userInfo: nil, repeats: false)
        looseDetectTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(makeLose), userInfo: nil, repeats: true)
        self.physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if(enemyLooses){
            self.enemy.run(SKAction.moveTo(y: self.ball.position.y-10, duration: aiReactionTime+0.5))
        }else{
            enemy.run(SKAction.moveTo(y: ball.position.y, duration: aiReactionTime))
        }
        if(ball.position.x >= player.position.x){
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(resetGame), userInfo: nil, repeats: false)
            updateScore(whoWon: enemy)
        }else if(ball.position.x <= enemy.position.x){
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(resetGame), userInfo: nil, repeats: false)
            updateScore(whoWon: player)
        }
    }
}
