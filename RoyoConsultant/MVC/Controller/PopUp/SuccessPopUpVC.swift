//
//  SuccessPopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/10/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import Lottie

class SuccessPopUpVC: BaseVC {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewLottieWrapper: UIView! {
        didSet {
            viewLottieWrapper.backgroundColor = .clear
        }
    }
    @IBOutlet weak var viewLabel: UIView! {
        didSet {
            viewLabel.roundCorners(with: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 8.0)
        }
    }
    
    var message: String?
    var didClosed: (() -> Void)?
    
    lazy var animation: AnimationView = {
        let successView = AnimationView()
        successView.animation = Animation.named(LottieFiles.Success.getFileName(), bundle: .main, subdirectory: nil, animationCache: nil)
        successView.animationSpeed = 2.0
        successView.loopMode = .playOnce
        successView.contentMode = .scaleAspectFit
        return successView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        animation.frame = viewLottieWrapper.bounds
        viewLottieWrapper.addSubview(animation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
            self.animation.play()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.hideVisulEffectView()
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        hideVisulEffectView()
    }
}

//MARK:- VCFuncs 
extension SuccessPopUpVC {
    private func setText() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        lblMessage.text = /message
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
    
    private func hideVisulEffectView() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.visualEffectView.isHidden = true
            self?.dismiss(animated: true, completion: {
                self?.didClosed?()
            })
        }
    }
}


