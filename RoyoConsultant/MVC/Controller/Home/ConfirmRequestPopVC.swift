//
//  ConfirmRequestPopVC.swift
//  RoyoConsultant
//
//  Created by Chitresh Goyal on 17/08/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class ConfirmRequestPopVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btnConfirm: SKButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var confirmData: ConfirmBookingData?
    var service: Service?
    var category: Category?
    var address: Address?
    
    var startDate: Date?
    var endDate: Date?
    
    var time: String?
    var endTime: String?
    var selectedTier: Tier?
    
    var requestId: String?
    public var didReceiveRequestId: ((_ requestId: String?) -> Void)?
    
    var backHandler :(()->())?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizedTextSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
        
        setConfirmRequestData(confirmData)
    }
    
    //MARK: - IBActions
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1:
            apiConfirmRequest()
        default:
            break
        }
    }
}
extension ConfirmRequestPopVC {
    
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        btnConfirm.setTitle(VCLiteral.PAY.localized, for: .normal)
        
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
    
    func refreshViaNotification() {
        self.dismiss(animated: true, completion: {
            self.didReceiveRequestId?(self.requestId)
        })
    }
    func startTimer() {
        
        let totalTime = 65.0
        var waitingTime = 0.0
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if waitingTime < totalTime {
                waitingTime += 1
                
                let progress = Float(waitingTime/totalTime)
                self.progressView.setProgress(Float(progress), animated: true)
            } else {
                Timer.invalidate()
//                Toast.shared.showAlert(type: .notification, message: "No experts are available. Please try again Later.")
//                self.dismissVC()
                self.backHandler?()
            }
        }
    }
}
extension ConfirmRequestPopVC {
    
    private func setConfirmRequestData(_ data: ConfirmBookingData?) {
        
        lblSubTotal.text = /data?.total?.getFormattedPrice()
        lblTotal.text = /data?.grand_total?.getFormattedPrice()
        
        lblServiceType.text = /service?.main_service_type?.rawValue.replacingOccurrences(of: "_", with: " ").capitalized
        
        let startDate = self.startDate?.toString(DateFormat.custom("MMM d, yyyy"), timeZone: .local, isForAPI: true)
        let endDate = self.endDate?.toString(DateFormat.custom("MMM d, yyyy"), timeZone: .local, isForAPI: true)
        
        lblDate.text = /startDate + " - " + /endDate
        lblTime.text = /self.time + " - " + /endTime
        
    }
    
    private func apiConfirmRequest() {
        
        btnConfirm.playAnimation()
        let scheduleType: ScheduleType = .schedule
        
        let startDate = self.startDate?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local, isForAPI: true)
        let startTime = Date.init(fromString: /time, format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom("HH:mm"), timeZone: .local, isForAPI: true)
        
        let endDate = self.endDate?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local, isForAPI: true)
        let endTime = Date.init(fromString: /self.endTime, format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom("HH:mm"), timeZone: .local, isForAPI: true)
        
        EP_Others.createRequest(consultant_id: nil, date: startDate, time: startTime, service_id: String(/service?.service_id), schedule_type: scheduleType, coupon_code: nil, request_id: nil, latitude: address?.latitude, longitude: address?.longitude, service_address: address?.name, secondOpinion: nil, title: nil, images: nil, tier_id: selectedTier?.id, tier_options: selectedTier?.getOptionsForBackend(), end_date: endDate, end_time: endTime, category_id: "\(/category?.id)").request(success: { [weak self] (responseData) in
            
            self?.btnConfirm.stop()
            let response = (responseData as? CreateRequestData)
            if /response?.amountNotSufficient {
                self?.showInvalidBalanceAlert(message: response?.message, minAmount: Double(/response?.minimum_balance))
            } else {
                
                #if NurseLynx
                self?.startTimer()
                self?.btnConfirm.isHidden = true
                #else
                
                UserPreference.shared.didAddedOrModifiedBooking = true
                let destVC = Storyboard<SuccessPopUpVC>.PopUp.instantiateVC()
                destVC.modalPresentationStyle = .overFullScreen
                destVC.message = VCLiteral.REQUEST_SENT_SUCCESS.localized
                self?.present(destVC, animated: true, completion: nil)
                destVC.didClosed = {
                    #if HealthCarePrashant || Heal
                    let updateApptVC = Storyboard<UpdateApptVC>.Home.instantiateVC()
                    updateApptVC.request = response?.request
                    self?.pushVC(updateApptVC)
                    #elseif CloudDoc
                    let preAssesmentVC = Storyboard<PreAssesmentVC>.Home.instantiateVC()
                    preAssesmentVC.request = response?.request
                    self?.pushVC(preAssesmentVC)
                    #else
                    self?.popVC()
                    #endif
                }
                #endif
            }
        }) { [weak self] (error) in
            self?.btnConfirm.stop()
        }
    }
    
    private func showInvalidBalanceAlert(message: String?, minAmount: Double?) {
        
        let minimumAmount = /minAmount?.getFormattedPrice()
        let defaultMessage = String(format: VCLiteral.WALLET_ALERT_MESSAGE.localized, minimumAmount)
        
        alertBox(title: VCLiteral.WALLET_ALERT.localized, message: message ?? defaultMessage, btn1: VCLiteral.ADD_MONEY.localized, btn2: VCLiteral.CANCEL.localized, tapped1: {
            let destVC = Storyboard<AddMoneyVC>.Home.instantiateVC()
            UIApplication.topVC()?.presentVC(destVC)
        }, tapped2: nil)
    }
    
}
