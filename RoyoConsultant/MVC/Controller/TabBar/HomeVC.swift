//
//  HomeVC_Tab1HomeVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewAddPatient: UIView!
    @IBOutlet weak var btnWallet: UIButton!
    @IBOutlet weak var btnAddPatient: UIButton!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var viewNotification: UIView!

    @IBOutlet weak var vwNotificationCOunt: UIView!
    
    @IBOutlet weak var lblNotificationCount: UILabel!
    private let tab1 = Storyboard<HomeVC_Consult>.TabBar.instantiateVC()
    private let tab2 = Storyboard<HomeVC_Consult>.TabBar.instantiateVC()
    private var selectedSegment: SJSegmentTab?
    private var sjSegmentVC: SJSegmentedViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegments()
        
        if AppSettings.isLocationEnabled {
            LocationManager.shared.startTrackingUser()
        }
        viewAddPatient.isHidden = UserPreference.shared.isUserLoggedIn ? !AppSettings.showAddPatient : true
        btnAddPatient.setTitle(VCLiteral.ADD_PATIENT.localized, for: .normal)
        btnWallet.isHidden = !UserPreference.shared.isUserLoggedIn
        lblBalance.isHidden = UserPreference.shared.isUserLoggedIn ? !AppSettings.showBalanceOnTabScreens : true
        viewNotification.isHidden = UserPreference.shared.isUserLoggedIn ? !AppSettings.showNotificationBtnOnHome : true
        lblBalance.text = nil
        vwNotificationCOunt.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if AppSettings.showBalanceOnTabScreens {
            getWalletBalanceAPI()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if AppSettings.isLocationEnabled && /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: false) {
                EP_Login.locationUpdate.request { _ in
                    
                } error: { _ in
                    
                }
            }
        }
    }
    
    @IBAction func btnAddPatientAction(_ sender: UIButton) {
        if !(/(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true)) {
            return
        }
        let destVC = Storyboard<AddPatientPopUpVC>.PopUp.instantiateVC()
        destVC.modalPresentationStyle = .overFullScreen
        destVC.callBack = { [weak self] (patientType) in
            switch patientType {
            case .Children, .Elder:
                let addPatientVC = Storyboard<AddPatientVC>.Home.instantiateVC()
                addPatientVC.patientType = patientType
                addPatientVC.patiendAdded = {
                    let successPopUp = Storyboard<SuccessPopUpVC>.PopUp.instantiateVC()
                    successPopUp.message = VCLiteral.PATIENT_SUCCESS.localized
                    successPopUp.modalPresentationStyle = .overFullScreen
                    self?.presentVC(successPopUp)
                }
                self?.pushVC(addPatientVC)
            case .None:
                break
            }
        }
        presentVC(destVC)
    }
    
    @IBAction func btnNotificationAction(_ sender: Any) {
        pushVC(Storyboard<NotificationsVC>.Home.instantiateVC())
    }
    
    @IBAction func btnWalletAction(_ sender: UIButton) {
        if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) {
            pushVC(Storyboard<WalletVC>.Home.instantiateVC())
        }
    }
}

//MARK:- VCFuncs
extension HomeVC {
    private func getWalletBalanceAPI() {
        if /UserPreference.shared.data?.token == "" {
            return
        }
        EP_Home.wallet.request(success: { [weak self] (responseData) in
            let walletBalance = (responseData as? WalletBalance)?.balance
            self?.lblBalance.text = walletBalance?.getFormattedPrice()
        }) { (error) in
            
        }
    }
    
    private func setupSegments() {
        
        if AppSettings.showClassesInSecondTab {
            sjSegmentVC = SJSegmentedViewController(headerViewController: nil, segmentControllers: [tab1, tab2])
            sjSegmentVC?.selectedSegmentViewHeight = 2.0
            sjSegmentVC?.segmentViewHeight = 48
        } else {
            sjSegmentVC = SJSegmentedViewController(headerViewController: nil, segmentControllers: [tab1])
            sjSegmentVC?.selectedSegmentViewHeight = 0.0
            sjSegmentVC?.segmentViewHeight = 0
        }
        
        tab1.title = VCLiteral.HOME.localized
        tab2.title = VCLiteral.CLASSES.localized
        tab2.isClassesScreen = true
        
        sjSegmentVC?.selectedSegmentViewColor = ColorAsset.appTint.color
        
        sjSegmentVC?.segmentTitleFont = Fonts.CamptonBook.ofSize(14)
        sjSegmentVC?.segmentTitleColor = ColorAsset.txtMoreDark.color
        sjSegmentVC?.segmentBackgroundColor = ColorAsset.backgroundColor.color
        sjSegmentVC?.segmentedScrollView.bounces = true
        sjSegmentVC?.delegate = self
        
        addChild(sjSegmentVC!)
        self.containerView.addSubview((sjSegmentVC?.view)!)
        sjSegmentVC?.view.frame = self.containerView.bounds
        sjSegmentVC?.didMove(toParent: self)
    }
}

//MARK:- SJSegmentedViewController Delegate
extension HomeVC: SJSegmentedViewControllerDelegate {
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        segment?.selectedTitleColor(ColorAsset.txtMoreDark.color)
        segment?.titleColor(ColorAsset.txtMoreDark.color)
        if selectedSegment != nil {
            selectedSegment?.titleFont(Fonts.CamptonBook.ofSize(14.0))
        }
        if /sjSegmentVC?.segments.count > 0 {
            selectedSegment = sjSegmentVC?.segments[index]
            selectedSegment?.titleFont(Fonts.CamptonSemiBold.ofSize(14.0))
        }
    }
}
