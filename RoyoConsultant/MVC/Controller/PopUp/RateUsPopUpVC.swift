//
//  RateUsPopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 07/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import HCSStarRatingView
import SZTextView

class RateUsPopUpVC: BaseVC {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSubmit: SKButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var tvReview: SZTextView!
    
    public var request: Requests?
    public var didRequestUpdated: ((_ obj: Requests?) -> Void)?
    
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
        case 0: //Cancel
            hideVisulEffectView()
        case 1: //Submit
            if /tvReview.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" || /ratingView.value == 0.0 {
                btnSubmit.vibrate()
                return
            }
            addReviewAPI()
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension RateUsPopUpVC {
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        lblTitle.text = VCLiteral.APPOINTMENT_REVIEW.localized
        btnSubmit.setTitle(VCLiteral.SUBMIT.localized, for: .normal)
        tvReview.placeholder = VCLiteral.REVIEW_PLACEHOLDER.localized
        lblName.text = /request?.to_user?.name?.capitalizingFirstLetter()
        imgView.setImageNuke(/request?.to_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        tvReview.textContainerInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        if L102Language.isRTL {
            tvReview.makeTextWritingDirectionRightToLeft(true)
        }

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
                //CallBack
            })
        }
    }
    
    private func addReviewAPI() {
        btnSubmit.playAnimation()
        EP_Home.addReview(consultantId: String(/request?.to_user?.id), requestId: String(/request?.id), review: tvReview.text.trimmingCharacters(in: .whitespacesAndNewlines), rating: String(Double(ratingView.value))).request(success: { [weak self] (_) in
            self?.request?.rating = /Double(/self?.ratingView.value)
            self?.didRequestUpdated?(self?.request)
            self?.btnSubmit.stop()
            self?.hideVisulEffectView()
        }) { [weak self] (_) in
            self?.btnSubmit.stop()
        }
    }
}
