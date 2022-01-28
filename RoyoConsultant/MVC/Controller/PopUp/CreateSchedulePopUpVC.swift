//
//  CreateSchedulePopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 25/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class CreateSchedulePopUpVC: UIViewController {
    
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var btnCreateBooking: SKBorderButton!
    @IBOutlet weak var btnSchedule: SKBorderButton!
    
    public var scheduleTypeTapped: ((_ for: ScheduleType) -> Void)?
    private var scheduleType: ScheduleType = .instant
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Dismiss
            hideVisulEffectView(isDismissOnly: true)
        case 1: //Create Booking
            scheduleType = .instant
            hideVisulEffectView(isDismissOnly: false)
        case 2: //Schedule
            scheduleType = .schedule
            hideVisulEffectView(isDismissOnly: false)
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension CreateSchedulePopUpVC {
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        btnCreateBooking.setAnimationType(.BtnAppTintLoader)
        btnSchedule.setAnimationType(.BtnAppTintLoader)
        btnCreateBooking.setTitle(VCLiteral.REQUEST_NOW.localized, for: .normal)
        btnSchedule.setTitle(VCLiteral.SCHEDULE.localized, for: .normal)
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
    
    private func hideVisulEffectView(isDismissOnly: Bool? = true) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.visualEffectView.isHidden = true
            self?.dismiss(animated: true, completion: {
                /isDismissOnly ? () : self?.scheduleTypeTapped?(self?.scheduleType ?? .instant)
            })
        }
    }
}
