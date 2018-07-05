//
//  SelectionVC.swift
//  Pong!
//
//  Created by Pawan Badsewal on 02/07/18.
//  Copyright © 2018 Pawan Badsewal. All rights reserved.
//

import Foundation
import UIKit

enum gameMode {
    case ai
    case friendly
}

class SelectionVC: UIViewController {
    
    @IBOutlet var easyBtn: UIButton!
    @IBOutlet var hardBtn: UIButton!
    
    
    func startGame(game : gameMode){
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        currentGameMode = game
        self.navigationController?.pushViewController(gameVC, animated: true)
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
}

