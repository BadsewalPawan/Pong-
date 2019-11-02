//
//  GameScene.swift
//  Pong!
//
//  Created by Pawan Badsewal on 27/06/18.
//  Copyright © 2018 Pawan Badsewal. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

var aiReactionTime:Double = 0.05

var selectedColorIndex:Int = 0
var paddleColor:Array<Array<UIColor>> = [[#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)], [#colorLiteral(red: 0, green: 0.814856112, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8491321206, blue: 0.2452769876, alpha: 1)], [#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)]]

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var angleDiversionX:Double!
    var angleDiversionY:Double!
    var score = [Int]()
    var ball = SKSpriteNode()
    var player = SKSpriteNode()
    var enemy = SKSpriteNode()
    var enemylbl = SKLabelNode()
    var playerlbl = SKLabelNode()
    var timer = Timer()
    var enemyLooses:Bool = false
    var enemySide:Bool = false
    
    func setupPaddle(targetPaddle: SKSpriteNode, targetTexture: String, yPos:CGFloat, targetlbl:SKLabelNode, targetlblColor:UIColor){
        targetlbl.fontColor = targetlblColor
        targetPaddle.position.y = yPos
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
    
    func strikeBall(){
        enemySide = !enemySide
        angleDiversionX = Double(arc4random_uniform(9)/10)
        angleDiversionY = Double(arc4random_uniform(9)/10)
        let randNum = arc4random_uniform(2)
        switch enemySide {
        case true:
            if(randNum == 0){
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseForce+angleDiversionX, dy: impulseForce+angleDiversionY))
            }else{
                ball.physicsBody?.applyImpulse(CGVector(dx: -impulseForce-angleDiversionX, dy: impulseForce+angleDiversionY))
            }
        default:
            if(randNum == 0){
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseForce+angleDiversionX, dy: -impulseForce-angleDiversionY))
            }else{
                ball.physicsBody?.applyImpulse(CGVector(dx: -impulseForce-angleDiversionX, dy: -impulseForce-angleDiversionY))
            }
        }
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
    
    @objc func resetGame(){
        enemyLooses = false
        strikeBall()
    }
    
    @objc func startGame(){
        score = [0,0]
        playerlbl.text = String(score[0])
        enemylbl.text = String(score[1])
        strikeBall()
    }
    
    @objc func doubleTapped() {
        selectedColorIndex += 1
        updateColor()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(vibrationOn){
            if !(contact.bodyA.node?.name == nil) {
                print("vib")
                AudioServicesPlaySystemSound(1519)}
        }
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        playerlbl = self.childNode(withName: "playerlbl") as! SKLabelNode
        enemylbl = self.childNode(withName: "enemylbl") as! SKLabelNode
        player = self.childNode(withName: "playerPaddle") as! SKSpriteNode
        enemy = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        setupPaddle(targetPaddle: player, targetTexture: "paddle", yPos: (-self.frame.height/2) + 50, targetlbl: playerlbl, targetlblColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        setupPaddle(targetPaddle: enemy, targetTexture: "paddle", yPos: (self.frame.height/2) - 50, targetlbl: enemylbl, targetlblColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(startGame), userInfo: nil, repeats: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if(currentGameMode == .friendly){
                if(location.y > 0){
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0))
                }
                if(location.y < 0){
                    player.run(SKAction.moveTo(x: location.x, duration: 0))
                }
            }else{
                player.run(SKAction.moveTo(x: location.x, duration: 0))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if(currentGameMode == .friendly){
                if(location.y > 0){
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0))
                }
                if(location.y < 0){
                    player.run(SKAction.moveTo(x: location.x, duration: 0))
                }
            }else{
                player.run(SKAction.moveTo(x: location.x, duration: 0))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        switch currentGameMode {
        case .ai?:
            if(ball.position.y > 2 && ball.position.y < 12 && (Int(arc4random_uniform(101)) % 25 == 0)){
                enemyLooses = true
            }else{
                if(enemyLooses){
                    UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                        self.enemy.run(SKAction.moveTo(x: self.ball.position.x-10, duration: aiReactionTime+0.5))
                    }, completion: nil)
                }else{
                    enemy.run(SKAction.moveTo(x: ball.position.x, duration: aiReactionTime))
                }
            }
        case .friendly?:
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
