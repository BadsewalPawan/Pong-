//
//  SelectionVC.swift
//  Pong!
//
//  Created by Pawan Badsewal on 02/07/18.
//  Copyright © 2018 Pawan Badsewal. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIButton {
    func roundedButton(_ corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

enum gameMode {
    case ai
    case friendly
}


var impulseForce:Double = 2
var vibrationOn:Bool = true
var firstTimeLoaded:Bool = true

var impulseMem:Double = 2
var impulseLevel:Int = 1

class SelectionVC: UIViewController, UIViewControllerTransitioningDelegate {
    
    var AudioPlayer: AVAudioPlayer!
    var timer = Timer()
    var colorIndex:Int = 0
    var animatingColors:Array<UIColor> = [#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1), #colorLiteral(red: 0.9459975362, green: 0.3047701716, blue: 0.9482037425, alpha: 1),  #colorLiteral(red: 0.9978538156, green: 0.2217786312, blue: 0.9485233426, alpha: 1), #colorLiteral(red: 0.7114681602, green: 0.2993121743, blue: 1, alpha: 1),  #colorLiteral(red: 0.462166667, green: 0.289688319, blue: 0.9572553039, alpha: 1), #colorLiteral(red: 0.276253432, green: 0.3935356736, blue: 1, alpha: 1),  #colorLiteral(red: 0, green: 0.6257213354, blue: 0.9460859895, alpha: 1), #colorLiteral(red: 0, green: 0.9500153661, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9385238886, blue: 0.6478046775, alpha: 1), #colorLiteral(red: 0.4962247014, green: 1, blue: 0.3444253504, alpha: 1), #colorLiteral(red: 0.9258871675, green: 0.8918469548, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.856780231, blue: 0.2353284359, alpha: 1), #colorLiteral(red: 1, green: 0.711179316, blue: 0.1867073476, alpha: 1), #colorLiteral(red: 1, green: 0.4785065055, blue: 0.1527973115, alpha: 1), #colorLiteral(red: 1, green: 0.2068813443, blue: 0.09305993468, alpha: 1), #colorLiteral(red: 1, green: 0.2486671507, blue: 0.3278942108, alpha: 1), #colorLiteral(red: 1, green: 0.9862245917, blue: 0.9932437539, alpha: 1)]
    let transition = CircularTransition()
    var transitionPosition:CGPoint!
    @IBAction func unwindToSelectionVC(segue: UIStoryboardSegue) {}
    
    @IBOutlet var impulseLevellbl: UILabel!
    @IBOutlet var impulseStepper: UIStepper!
    @IBOutlet var rateBtn: UIButton!
    @IBOutlet var optionView: UIView!
    @IBOutlet var optionToggleBtn: UIButton!
    @IBOutlet var musicToggleBtn: UIButton!
    @IBOutlet var vibrationToggleBtn: UIButton!
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = transitionPosition
        transition.circleColor =  #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = transitionPosition
        transition.circleColor =  #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        return transition
    }
    
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
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
    }

    
    func startGame(game : gameMode){
        currentGameMode = game
        transitionPosition = game == .ai ? CGPoint(x: 0, y: self.view.frame.height):CGPoint(x: self.view.frame.width, y: self.view.frame.height)
        performSegue(withIdentifier: "selectionGameSegue", sender: Any?.self)
    }
    
    func showHideOptionView(xPosition: CGFloat, yPosition: CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.01, options: [.allowUserInteraction], animations: {
            self.optionView.frame.origin = CGPoint(x: xPosition, y: yPosition)
        }, completion: nil)
    }
    
    @objc func spinColor(){
        if (colorIndex == animatingColors.count - 1 ){
            colorIndex = 0
        }else{
            colorIndex += 1
        }
        UIView.animate(withDuration: 0.75, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.rateBtn.tintColor = self.animatingColors[self.colorIndex]
        }, completion: nil)
    }
    
    @IBAction func selectionAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            startGame(game: .friendly)
        case 2:
            startGame(game: .ai)
        default:
            break
        }
    }
    
    @IBAction func updateImpulse(_ sender: UIStepper) {
        impulseForce = sender.value
        if(impulseMem > impulseForce){
            impulseLevel -= 1
        }else{
            impulseLevel += 1
        }
        impulseMem = impulseForce
        impulseLevellbl.text = "Impulse level \(impulseLevel)"
    }
    
    @IBAction func optionAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            optionToggleBtn.isSelected = !optionToggleBtn.isSelected
            if(optionToggleBtn.isSelected){
                showHideOptionView(xPosition: 16, yPosition: (optionToggleBtn.frame.height + optionToggleBtn.frame.origin.y))
            }else{
                showHideOptionView(xPosition: -150, yPosition: (optionToggleBtn.frame.height + optionToggleBtn.frame.origin.y + 30))
            }
        case 1:
            let alert = UIAlertController(title: "Love This Game?", message: "Rate us 5★, please? :)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil ))
            alert.addAction(UIAlertAction(title: "Rate us 5★", style: .default, handler: { action in
                guard let url = URL(string: "itms-apps://itunes.apple.com/app/id1433957825?mt=8&action=write-review") else {
                    return
                }
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                } else {
                    UIApplication.shared.openURL(url)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        case 2:
            transitionPosition =  CGPoint(x: 0, y: 0)
            performSegue(withIdentifier: "selectionOnBoardSegue", sender: Any?.self)
        case 3:
            musicToggleBtn.isSelected = !musicToggleBtn.isSelected
            if(musicToggleBtn.isSelected){
                AudioPlayer.pause()
            }else{
                AudioPlayer.play()
            }
        case 4:
            vibrationOn = !vibrationOn
            vibrationToggleBtn.isSelected = !vibrationToggleBtn.isSelected
            if(vibrationOn){
                AudioServicesPlaySystemSound(1519)
            }
        default:
            break
        }
    }
    

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { return .bottom }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "selectionOnBoardSegue"){
            let onBoardingVC = segue.destination as! OnBoardingVC
            onBoardingVC.transitioningDelegate = self
            onBoardingVC.modalPresentationStyle = .custom
            
        }else{
            let gameVC = segue.destination as! GameViewController
            gameVC.transitioningDelegate = self
            gameVC.modalPresentationStyle = .custom
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        impulseStepper.value = impulseForce
        impulseLevellbl.text = "Impulse level \(impulseLevel)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(spinColor), userInfo: nil, repeats: true)
        optionView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHideOptionView(xPosition: -150, yPosition: (optionToggleBtn.frame.height + optionToggleBtn.frame.origin.y + 30))
        optionView.roundCorners([.bottomRight, .bottomLeft], radius: 20)
        optionToggleBtn.roundCorners([.topLeft, .topRight], radius: 20)
        optionToggleBtn.setImage(#imageLiteral(resourceName: "close"), for: .selected)
        musicToggleBtn.setImage(#imageLiteral(resourceName: "soundOff"), for: .selected)
        vibrationToggleBtn.setImage(#imageLiteral(resourceName: "vibrateOff"), for: .selected)
        let rateBtnimg = UIImage(named: "heart");
        let tintedImage = rateBtnimg?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        rateBtn.setImage(tintedImage, for: .normal)
        rateBtn.tintColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        if (firstTimeLoaded == true){
            playAudio()
            firstTimeLoaded = false
            if(UIScreen.main.bounds.width > 500){
                impulseForce = 3
                impulseStepper.minimumValue = 3
                impulseStepper.maximumValue = 5
                impulseStepper.stepValue = 0.5
            }else{
                impulseForce = 2
            }
            impulseMem = impulseForce
        }
    }
}

