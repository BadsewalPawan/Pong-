//
//  OnBoardingVC.swift
//  Pong!
//
//  Created by Pawan Badsewal on 18/05/19.
//  Copyright © 2019 Pawan Badsewal. All rights reserved.
//

import UIKit
import paper_onboarding

class OnBoardingVC: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
  

    @IBOutlet var onBoardingView: PaperOnboarding!
    @IBOutlet var skipBtn: UIButton!
    

    func onboardingItemsCount() -> Int {
        return 2
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if(index == 0){
            skipBtn.setTitle("Skip", for: .normal)
        }else{
            skipBtn.setTitle("Done", for: .normal)
        }
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito", size: 36.0)!
        let descFont = UIFont(name: "OpenSans", size: 14.0)!
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoard1"),
                               title: "Colors",
                               description: "Double tap on screen to change the color",
                               pageIcon: #imageLiteral(resourceName: "colorWheel"),
                               color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                               titleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), descriptionColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), titleFont: titleFont, descriptionFont: descFont),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoard2"),
                               title: "Ball Speed",
                               description: "Change impulse level to adjust ball speed",
                               pageIcon: #imageLiteral(resourceName: "ballSpeed"),
                               color: #colorLiteral(red: 0.03921568627, green: 0.03921568627, blue: 0.03921568627, alpha: 1),
                               titleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), descriptionColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), titleFont: titleFont, descriptionFont: descFont)
            ][index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardingView.delegate = self
        onBoardingView.dataSource = self
        view.bringSubviewToFront(skipBtn)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
