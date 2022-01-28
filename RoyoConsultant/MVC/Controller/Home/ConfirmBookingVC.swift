//
//  ConfirmBookingVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 09/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import MapKit

class ConfirmBookingVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVendorExtraInfo: UILabel!
    @IBOutlet weak var lblBookingDetailsTitle: UILabel!
    @IBOutlet weak var lblAptDateTimeTitle: UILabel!
    @IBOutlet weak var lblAptDateTime: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNumberTitle: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var tfCoupon: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var lblPriceDetailsTitle: UILabel!
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblPromoAppliedTitle: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblPromoApplied: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTerms: SKLabel!
    @IBOutlet weak var btnConfirm: SKButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAddressValue: UILabel!
    @IBOutlet weak var btnViewAddress: UIButton!
    @IBOutlet weak var viewTax: UIView!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblTaxValue: UILabel!
    @IBOutlet weak var viewLeftTime: UIView!
    @IBOutlet weak var lblFreeBookingTIme: UILabel!
    @IBOutlet weak var lblCarePlan: UILabel!
    @IBOutlet weak var viewCarePlan: UIView!
    @IBOutlet weak var viewCarePlanPrice: UIView!
    @IBOutlet weak var lblCarePlanText: UILabel!
    @IBOutlet weak var lblCarePlanAmount: UILabel!
    @IBOutlet weak var viewTickUnTick: UIView!
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var tickBackView: UIView!
    
    public var vendor: User?
    public var service: Service?
    public var selectedDateTime: SelectedDateTime?
    public var requestId: String? //user for rescheduling
    private var address: Address?
    public var isSecondOpinion = false
    public var secondOpinionData: (images: [String], recordTitle: String)?
    private var timer: Timer?
    private var currentSeconds: Int?
    private var tier: Tier?
    private var isTermsAgreed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if NurseLynx
        viewCarePlan.isHidden = false
        viewCarePlanPrice.isHidden = false
        lblCarePlan.addTapGestureRecognizer { [weak self] (_) in
            let destVC = Storyboard<AddCarePlanVC>.Home.instantiateVC()
            destVC.didTapAdd = { (selectedTier) in
                self?.tier = selectedTier
                self?.getConfirmRequestAPI()
                self?.lblCarePlan.text = "\(VCLiteral.CARE_PLAN.localized)\n\(/selectedTier?.title)"
            }
            self?.pushVC(destVC)
        }
        #else
        viewCarePlan.isHidden = true
        viewCarePlanPrice.isHidden = true
        #endif
        localizedTextSetup()
        initialSetup()
        getConfirmRequestAPI()
        
        #if NurseLynx
        viewTickUnTick.isHidden = false
        isTermsAgreed = false
        #else
        viewTickUnTick.isHidden = true
        isTermsAgreed = true
        #endif
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Date and Time Edit
            let destVC = Storyboard<ChooseDateTimeVC>.Home.instantiateVC()
            destVC.service = service
            destVC.vendor = vendor
            destVC.selectedDateTime = selectedDateTime
            destVC.didSelecteDateTime = { [weak self] (dateTime) in
                self?.selectedDateTime = dateTime
                self?.getConfirmRequestAPI()
            }
            pushVC(destVC)
        case 2: //Apply Code
            view.endEditing(true)
            getConfirmRequestAPI()
        case 3: //Confirm Booking
            if /lblAptDateTime.text == "" || !isTermsAgreed {
                btnConfirm.vibrate()
                return
            }
            createRequestAPI()
        case 4: //Add Address
            if /service?.isClinicAddress() {
                return
            }
            #if Heal || HomeDoctorKhalid || NurseLynx
            let destVC = Storyboard<AddAddressVC>.Home.instantiateVC()
            destVC.address = address
            destVC.didSelected = { [weak self] (address) in
                self?.lblAddressValue.text = /address?.name
                self?.address = address
            }
            pushVC(destVC)
            #endif
        case 5: //View Address Clinic
            let mapItem = MKMapItem.init(coordinate: CLLocationCoordinate2D.init(latitude: /service?.clinic_address?.lat, longitude: /service?.clinic_address?.long), name: /service?.clinic_address?.locationName)
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        case 6: //Terms Tick UnTick
            isTermsAgreed = !(isTermsAgreed)
            btnTick.backgroundColor = isTermsAgreed ? ColorAsset.appTint.color : .clear
            btnTick.setImage(isTermsAgreed ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension ConfirmBookingVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.CONFIRM_BOOKING.localized
        lblBookingDetailsTitle.text = VCLiteral.BOOKING_DETAILS.localized
        lblAptDateTimeTitle.text = VCLiteral.APPT_DATE_TIME.localized
        lblEmailTitle.text = VCLiteral.EMAIL_PLACEHOLDER.localized
        lblPhoneNumberTitle.text = VCLiteral.PHONE_NUMBER.localized
        tfCoupon.placeholder = VCLiteral.COUPON_PLACEHOLDER.localized
        btnApply.setTitle(VCLiteral.APPLY.localized, for: .normal)
        lblPriceDetailsTitle.text = VCLiteral.PRICE_DETAILS.localized
        lblSubTotalTitle.text = VCLiteral.SUB_TOTAL.localized
        lblPromoAppliedTitle.text = VCLiteral.PROMO_APPLIED.localized
        lblSubTotalTitle.text = VCLiteral.TOTAL.localized
        #if NurseLynx
        let termsText = String.init(format: VCLiteral.TERMS_CONFIRM_BOOKING.localized, VCLiteral.SALES_CONTRACT.localized)
        lblTerms.setAttributedText(original: (termsText, Fonts.CamptonBook.ofSize(12), ColorAsset.txtLightGrey.color), toReplace: (VCLiteral.SALES_CONTRACT.localized, Fonts.CamptonMedium.ofSize(12), ColorAsset.txtTheme.color))
        lblTerms.textAlignment = .left
        lblTerms.setLinkedTextWithHandler(text: termsText, link: VCLiteral.SALES_CONTRACT.localized) { [weak self] in
            let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            destVC.linkTitle = ("\(/UserPreference.shared.clientDetail?.domain_url)/\(APIConstants.salesAgreement)", VCLiteral.SALES_CONTRACT.localized)
            self?.pushVC(destVC)
        }
        #else
        lblTerms.textAlignment = .center
        lblTerms.text = VCLiteral.TERMS_CONFIRM_BOOKING.localized
        #endif
        btnConfirm.setTitle(VCLiteral.CONFIRM_BOOKING.localized, for: .normal)
        btnEdit.setTitle(VCLiteral.EDIT_SLOT.localized, for: .normal)
        lblAddress.text = VCLiteral.ADDRESS.localized
        lblAddressValue.text = nil
        lblAptDateTime.text = nil
        lblTotal.text = nil
        lblSubTotal.text = nil
        lblPromoApplied.text = nil
        btnEdit.isHidden = selectedDateTime == nil
        btnViewAddress.setTitle(VCLiteral.VIEW.localized, for: .normal)
        btnViewAddress.isHidden = /service?.clinic_address?.lat == 0
        lblTaxTitle.text = VCLiteral.TAX.localized
        lblTaxValue.text = ""
        viewTax.isHidden = true
        viewLeftTime.isHidden = true
        btnTick.backgroundColor = isTermsAgreed ? ColorAsset.appTint.color : .clear
        btnTick.setImage(isTermsAgreed ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        
        #if NurseLynx
        lblCarePlan.text = VCLiteral.CARE_PLAN.localized
        lblCarePlanText.text = VCLiteral.CARE_PLAN.localized
        #endif
        lblCarePlanAmount.text = nil
        
        
        #if HealthCarePrashant
        emailView.isHidden = true
        phoneView.isHidden = true
        addressView.isHidden = true
        #elseif Heal || HomeDoctorKhalid || NurseLynx
        emailView.isHidden = true
        phoneView.isHidden = true
        if /service?.isLocationLinked() {
            addressView.isHidden = false
            let currentLocation = LocationManager.shared.locationData
            address = Address(currentLocation.latitude, currentLocation.longitude, nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.lblAddressValue.text = /self.address?.name
            }
        } else {
            addressView.isHidden = true
        }
        #else
        emailView.isHidden = false
        phoneView.isHidden = false
        addressView.isHidden = true
        #endif
        
        if /service?.isClinicAddress() && /service?.clinic_address?.locationName != "" {
            lblAddressValue.text = /service?.clinic_address?.locationName
            addressView.isHidden = false
            lblAddress.text = VCLiteral.ADDRESS.localized + /service?.service_name
        }
    }
    
    private func initialSetup() {
        imgView.setImageNuke(/vendor?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        lblName.text = /vendor?.name?.capitalizingFirstLetter()
        lblVendorExtraInfo.text = /vendor?.categoryData?.name?.capitalizingFirstLetter()
        lblEmail.text = /vendor?.email
        lblPhoneNumber.text = "\(/vendor?.country_code)-\(/vendor?.phone)"
        lblFreeBookingTIme.text = String.init(format: VCLiteral.FREE_BOOKING_TIME.localized, "")
    }
    
    private func getConfirmRequestAPI() {
        var date: String?
        var time: String?
        var scheduleType: ScheduleType = .instant
        if let selectedSlot = selectedDateTime {
            date = selectedSlot.selectedDate?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local, isForAPI: true)
            time = Date.init(fromString: /selectedSlot.selectedTime?.uppercased(), format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom("HH:mm"), timeZone: .local, isForAPI: true)
            scheduleType = .schedule
        }
        playLineAnimation()
        EP_Home.confirmRequest(consultantId: String(/vendor?.id), date: date, time: time, serviceId: String(/service?.service_id), scheduleType: scheduleType, couponCode: tfCoupon.text, requestId: requestId, tierId: tier?.id).request(success: { [weak self] (responseData) in
            let response = responseData as? ConfirmBookingData
            self?.setConfirmRequestData(response)
            self?.stopLineAnimation()
            self?.viewLeftTime.isHidden = response?.is_paid ?? true
            if !(response?.is_paid ?? true) {
                self?.currentSeconds = Int(/response?.left_minute * 60.0)
                self?.startTimer()
            }
        }) { [weak self] (_) in
            self?.tfCoupon.text = nil
            self?.stopLineAnimation()
        }
    }
    
    private func startTimer() {
        if currentSeconds == nil {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
            self?.currentSeconds = /self?.currentSeconds + 1
            let days = /self?.currentSeconds / 86400
            let hours = (/self?.currentSeconds / 3600)
            let minutes = (/self?.currentSeconds % 3600) / 60
            let seconds = (/self?.currentSeconds % 3600) % 60
            var timeStamp = ""
            if hours <= 24 {
                timeStamp = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
            } else if days == 1 {
                timeStamp = "1 Day"
            } else {
                timeStamp = "\(days) Days"
            }
            self?.lblFreeBookingTIme.text = String.init(format: VCLiteral.FREE_BOOKING_TIME.localized, timeStamp)
            if /self?.currentSeconds <= 0 {
                self?.timer?.invalidate()
                self?.getConfirmRequestAPI()
            }
        })
    }
    
    private func createRequestAPI() {
        btnConfirm.playAnimation()
        var date: String?
        var time: String?
        var scheduleType: ScheduleType = .instant
        if let selectedSlot = selectedDateTime {
            date = selectedSlot.selectedDate?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local, isForAPI: true)
            time = Date.init(fromString: /selectedSlot.selectedTime?.uppercased(), format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom("HH:mm"), timeZone: .local, isForAPI: true)
            scheduleType = .schedule
        }
        
        
        
        EP_Home.createRequest(consultant_id: String(/vendor?.id), date: date, time: time, service_id: String(/service?.service_id), schedule_type: scheduleType, coupon_code: tfCoupon.text, request_id: requestId, latitude: address?.latitude, longitude: address?.longitude, service_address: address?.name, secondOpinion: isSecondOpinion, title: secondOpinionData?.recordTitle, images: secondOpinionData?.images.joined(separator: ","), tier_id: tier?.id, tier_options: tier?.getOptionsForBackend(), end_date: nil, end_time: nil).request(success: { [weak self] (responseData) in
            
            self?.btnConfirm.stop()
            let response = (responseData as? CreateRequestData)
            if /response?.amountNotSufficient {
                self?.showInvalidBalanceAlert(message: response?.message, minAmount: Double(/response?.minimum_balance))
            } else {
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
            UIApplication.topVC()?.pushVC(destVC)
        }, tapped2: nil)
    }
    
    private func setConfirmRequestData(_ data: ConfirmBookingData?) {
        lblSubTotal.text = /data?.total?.getFormattedPrice()
        lblTotal.text = /data?.grand_total?.getFormattedPrice()
        lblPromoApplied.text = (/data?.discount == 0.0 ? "" : "-") + /data?.discount?.getFormattedPrice()
        let date = /Date.init(fromString: /data?.book_slot_date, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom("E · \(UserPreference.shared.dateFormat)"), timeZone: .local, isForAPI: false)
        let time = /Date.init(fromString: /data?.book_slot_time?.uppercased(), format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom(" · hh:mm a"), timeZone: .local, isForAPI: false)
        lblAptDateTime.text = date + time
        viewTax.isHidden = /data?.service_tax == 0.0
        lblTaxValue.text = /data?.service_tax?.getFormattedPrice()
        lblCarePlanAmount.text = /data?.tier_charges?.getFormattedPrice()
    }
}
