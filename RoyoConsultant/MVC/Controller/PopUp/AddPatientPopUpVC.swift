//
//  AddPatientPopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 27/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

enum PatientType: String {
    case Elder
    case Children
    case None
}

class AddPatientPopUpVC: BaseVC {
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblElderely: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblChildren: UILabel!
    
    var callBack: ((_ _patientType: PatientType) -> Void)?

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
        case 0: //Back
            hideVisulEffectView(callBack: .None)
        case 1: //Elderely
            hideVisulEffectView(callBack: .Elder)
        case 2: //Children
            hideVisulEffectView(callBack: .Children)
        default:
            break
        }
    }
}
//MARK:- VCFuncs
extension AddPatientPopUpVC {
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        lblTitle.text = VCLiteral.ADD_A_PATIENT.localized
        lblElderely.text = VCLiteral.ELDERELY.localized
        lblChildren.text = VCLiteral.CHILDREN.localized
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
    
    private func hideVisulEffectView(callBack: PatientType) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.visualEffectView.isHidden = true
            self?.dismiss(animated: true, completion: {
                self?.callBack?(callBack)
            })
        }
    }
}
