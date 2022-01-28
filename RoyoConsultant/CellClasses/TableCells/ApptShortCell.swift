//
//  ApptShortCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 02/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import MapKit

class ApptShortCell: UITableViewCell, ReusableCell {
    
    typealias T = AppDetailCellModel
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnViewMap: UIButton!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var btnCancel: SKLottieButton!
    @IBOutlet weak var btnMulti: SKButton!
    @IBOutlet weak var lblServiceTypeTitle: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblTimeTitle: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var btnViewPrescription: SKButton!
    @IBOutlet weak var lblCategoryname: UILabel!
    @IBOutlet weak var stackHeight: NSLayoutConstraint! //Buttons //48 + Top Edge 8 = 56
    @IBOutlet weak var btnNotify: SKButton!
    @IBOutlet weak var lblCancelReason: UILabel!
    @IBOutlet weak var btnMedicalHistory: UIButton!
    
    var didReloadCell: (() -> Void)?
    
    var item: AppDetailCellModel? {
        didSet {
            let obj = item?.property?.model?.request
            lblServiceTypeTitle.text = VCLiteral.SERVICE_TYPE.localized
            btnViewPrescription.setTitle(VCLiteral.VIEW_PRESCRIPTION.localized, for: .normal)
            lblDateTitle.text = VCLiteral.DATE.localized
            lblTime.text = VCLiteral.TIME.localized
            lblTimeTitle.text = VCLiteral.TIME.localized
            lblPriceTitle.text = VCLiteral.PRICE.localized
            lblCategoryname.text = /obj?.to_user?.categoryData?.name
            lblName.text = "\(/obj?.to_user?.profile?.title) \(/obj?.to_user?.name)"
            lblServiceType.text = (/obj?.service_type).uppercased()
            lblStatus.text = /obj?.status?.title.localized
            lblStatus.textColor = obj?.status?.linkedColor.color
            imgView.setImageNuke(/obj?.to_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            let utcDate = Date(fromString: /obj?.bookingDateUTC, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc)
            lblDate.text = utcDate.toString(DateFormat.custom(UserPreference.shared.dateFormat), timeZone: .local, isForAPI: false)
            lblTime.text = utcDate.toString(DateFormat.custom("hh:mm a"), timeZone: .local, isForAPI: false)
            lblPrice.text = /obj?.price?.getDoubleValue?.getFormattedPrice()
            lblCancelReason.text = /obj?.cancel_reason == "" ? "" : String(format: VCLiteral.CANCEL_REASON.localized, /obj?.cancel_reason)
            btnMedicalHistory.setTitle(VCLiteral.MEDICAL_HISTORY.localized, for: .normal)
            
            if /obj?.isClinicAddress() && /obj?.service?.clinic_address?.locationName != "" {
                viewAddress.isHidden = false
                lblAddress.text = /obj?.service?.clinic_address?.locationName
            } else {
                viewAddress.isHidden = /obj?.extra_detail?.service_address == ""
                lblAddress.text = /obj?.extra_detail?.service_address
            }
            btnNotify.setTitle(VCLiteral.NOTIFY.localized, for: .normal)
            btnCancel.setTitle(VCLiteral.CANCEL.localized, for: .normal)
            btnCancel.isHidden = !(/obj?.canCancel)
            btnCancel.removeGradientBorder()
            if /obj?.canReschedule {
                btnMulti.isHidden = false
                btnMulti.setTitle(VCLiteral.RESCHEDULE.localized, for: .normal)
                btnCancel.setTitle(VCLiteral.CANCEL.localized, for: .normal)
                btnCancel.setTitleColor(ColorAsset.requestStatusFailed.color, for: .normal)
                btnCancel.borderColor = ColorAsset.requestStatusFailed.color
                btnCancel.removeGradientBorder()
                btnViewPrescription.isHidden = true
                btnNotify.isHidden = true
            } else {
                switch obj?.status ?? .unknown {
                case .start, .reached:
                    #if Heal || HomeDoctorKhalid || NurseLynx
                    btnMulti.setTitle(VCLiteral.TRACK_STATUS.localized, for: .normal)
                    btnMulti.isHidden = !(obj?.getRelatedAction() == .HOME)
                    #else
                    btnMulti.isHidden = true
                    #endif
                    btnCancel.isHidden = true
                    btnCancel.setTitle(VCLiteral.CANCEL.localized, for: .normal)
                    btnCancel.setTitleColor(ColorAsset.requestStatusFailed.color, for: .normal)
                    btnCancel.borderColor = ColorAsset.requestStatusFailed.color
                    btnCancel.removeGradientBorder()
                    btnViewPrescription.isHidden = true
                    btnNotify.isHidden = !(/obj?.canNotify)
                case .canceled, .failed:
                    btnMulti.isHidden = true
                    btnMulti.setTitle(VCLiteral.BOOKAGAIN.localized, for: .normal)
                    btnCancel.isHidden = true
                    btnCancel.setTitle(VCLiteral.CANCEL.localized, for: .normal)
                    btnCancel.setTitleColor(ColorAsset.requestStatusFailed.color, for: .normal)
                    btnCancel.borderColor = ColorAsset.requestStatusFailed.color
                    btnCancel.removeGradientBorder()
                    btnViewPrescription.isHidden = true
                    btnNotify.isHidden = true
                case .completed:
                    btnMulti.isHidden = false
                    btnMulti.setTitle(VCLiteral.BOOKAGAIN.localized, for: .normal)
                    btnCancel.isHidden = false
                    btnCancel.setTitle(VCLiteral.RATE.localized, for: .normal)
                    btnCancel.setTitleColor(ColorAsset.appTint.color, for: .normal)
                    btnCancel.isHidden = /obj?.rating != 0.0
                    btnCancel.borderColor = ColorAsset.appTint.color
                    if UserPreference.shared.isGradientViews {
                        btnCancel.applyGradientBorder(borderWidth: 1.0, colors: UserPreference.shared.gradientColors, orientation: .horizontal)
                    }
                    btnViewPrescription.isHidden = !(/obj?.is_prescription)
                    btnNotify.isHidden = true
                case .pending:
                    btnMulti.isHidden = true
                    btnCancel.isHidden = true
                    btnCancel.setTitle(VCLiteral.CANCEL.localized, for: .normal)
                    btnCancel.setTitleColor(ColorAsset.requestStatusFailed.color, for: .normal)
                    btnCancel.borderColor = ColorAsset.requestStatusFailed.color
                    btnCancel.removeGradientBorder()
                    btnViewPrescription.isHidden = true
                    btnNotify.isHidden = true
                default:
                    btnMulti.isHidden = true
                    btnCancel.isHidden = true
                    btnCancel.setTitle(VCLiteral.CANCEL.localized, for: .normal)
                    btnCancel.setTitleColor(ColorAsset.requestStatusFailed.color, for: .normal)
                    btnCancel.borderColor = ColorAsset.requestStatusFailed.color
                    btnCancel.removeGradientBorder()
                    btnViewPrescription.isHidden = true
                    btnNotify.isHidden = !(/obj?.canNotify)
                }
            }
            #if HomeDoctorKhalid
            btnMedicalHistory.isHidden = false
            #else
            btnMedicalHistory.isHidden = true
            #endif
            stackHeight.constant = (btnMulti.isHidden && btnCancel.isHidden && btnViewPrescription.isHidden && btnNotify.isHidden) ? 0 : 56
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch /sender.title(for: .normal) {
        case VCLiteral.RATE.localized:
            let destVC = Storyboard<RateUsPopUpVC>.PopUp.instantiateVC()
            destVC.modalPresentationStyle = .overFullScreen
            destVC.request = item?.property?.model?.request
            destVC.didRequestUpdated = { [weak self] (obj) in
                self?.item?.property?.model?.request = obj!
                self?.didReloadCell?()
            }
            UIApplication.topVC()?.presentVC(destVC)
        case VCLiteral.BOOKAGAIN.localized:
            let request = item?.property?.model?.request
            let service = Service.init(serviceId: request?.service_id, categoryId: request?.to_user?.categoryData?.id)
            switch item?.property?.model?.request?.schedule_type ?? .instant {
            case .instant:
                let destVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                destVC.vendor = request?.to_user
                destVC.service = service
                UIApplication.topVC()?.pushVC(destVC)
            case .schedule:
                let destVC = Storyboard<ChooseDateTimeVC>.Home.instantiateVC()
                destVC.vendor = request?.to_user
                destVC.service = service
                destVC.didSelecteDateTime = { (selectedDateTimeData) in
                    let confirmVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                    confirmVC.vendor = request?.to_user
                    confirmVC.service = service
                    confirmVC.selectedDateTime = selectedDateTimeData
                    UIApplication.topVC()?.pushVC(confirmVC)
                }
                UIApplication.topVC()?.pushVC(destVC)
            }
        case VCLiteral.RESCHEDULE.localized:
            checkValidForReschedule()
        case VCLiteral.CANCEL.localized:
            let alertVC = UIAlertController.init(title: VCLiteral.CANCEL_REQUEST.localized, message: VCLiteral.CANCEL_REQUEST_ALERT.localized, preferredStyle: .alert)
            alertVC.addTextField { (tf) in
                tf.placeholder = String(format: VCLiteral.CANCEL_REASON.localized, "").replacingOccurrences(of: ":", with: "")
            }
            alertVC.addAction(UIAlertAction.init(title: VCLiteral.CANCEL.localized, style: .cancel, handler: { (_) in
                
            }))
            alertVC.addAction(UIAlertAction.init(title: VCLiteral.OK.localized, style: .default, handler: { [weak self] (_) in
                if /alertVC.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.CANCEL_REASON_ALERT.localized)
                } else {
                    self?.cancelRequestAPI(reason: /alertVC.textFields?.first?.text)
                }
            }))
            UIApplication.topVC()?.presentVC(alertVC)
        case VCLiteral.TRACK_STATUS.localized:
            #if Heal || HomeDoctorKhalid || NurseLynx
            let destVC = Storyboard<TrackingVC>.Home.instantiateVC()
            destVC.request = item?.property?.model?.request
            destVC.modalPresentationStyle = .fullScreen
            UIApplication.topVC()?.presentVC(destVC)
            #else

            #endif
        case VCLiteral.VIEW_PRESCRIPTION.localized:
            let url = Configuration.getValue(for: .PROJECT_BASE_PATH) + APIConstants.pdf + "?request_id=\(/item?.property?.model?.request?.id)&client_id=\(Configuration.getValue(for: .PROJECT_PROJECT_ID))&download"
            //for download --&download
            let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            destVC.linkTitle = (url, VCLiteral.PRESC_DETAIL.localized)
            UIApplication.topVC()?.pushVC(destVC)
        case VCLiteral.NOTIFY.localized:
            UIApplication.topVC()?.alertBox(title: VCLiteral.NOTIFY.localized, message: VCLiteral.NOTIFY_DESC.localized, btn1: VCLiteral.CANCEL.localized, btn2: VCLiteral.NOTIFY.localized, tapped1: nil, tapped2: { [weak self] in
                self?.notifyDoctor()
            })
        case VCLiteral.MEDICAL_HISTORY.localized:
            let destVC = Storyboard<MedicalHistoryVC>.Home.instantiateVC()
            destVC.requestID = item?.property?.model?.request?.id
            UIApplication.topVC()?.pushVC(destVC)
        default:
            break
        }
    }
    
    private func notifyDoctor() {
        btnNotify.playAnimation()
        EP_Home.notifyUser(id: item?.property?.model?.request?.id).request { [weak self] (response) in
            Toast.shared.showAlert(type: .success, message: VCLiteral.NOTIFY_MESSAGE.localized)
            self?.btnNotify.stop()
        } error: { [weak self] (error) in
            self?.btnNotify.stop()
        }

    }
    
    @IBAction func btnViewMapAction(_ sender: UIButton) {
        let clinic = item?.property?.model?.request?.service?.clinic_address
        if /item?.property?.model?.request?.isClinicAddress() {
            let mapItem = MKMapItem.init(coordinate: CLLocationCoordinate2D.init(latitude: /clinic?.lat, longitude: /clinic?.long), name: /clinic?.locationName)
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        } else {
            let location = item?.property?.model?.request?.extra_detail
            let mapItem = MKMapItem.init(coordinate: CLLocationCoordinate2D.init(latitude: /Double(/location?.lat), longitude: /Double(/location?.long)), name: /location?.service_address)
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    private func checkValidForReschedule() {
        let request = item?.property?.model?.request
        let service = Service.init(serviceId: request?.service_id, categoryId: request?.to_user?.categoryData?.id)
        let destVC = Storyboard<ChooseDateTimeVC>.Home.instantiateVC()
        destVC.vendor = request?.to_user
        destVC.service = service
        destVC.didSelecteDateTime = { (selectedDateTimeData) in
            let confirmVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
            confirmVC.vendor = request?.to_user
            confirmVC.service = service
            confirmVC.selectedDateTime = selectedDateTimeData
            confirmVC.requestId = String(/request?.id)
            UIApplication.topVC()?.pushVC(confirmVC)
        }
        
        if request?.schedule_type == .instant {
            btnMulti.playAnimation()
            EP_Home.confirmRequest(consultantId: String(/request?.to_user?.id), date: nil, time: nil, serviceId: String(/request?.service_id), scheduleType: ScheduleType.instant, couponCode: nil, requestId: String(/request?.id), tierId: nil).request(success: { [weak self] (responseData) in
                self?.btnMulti.stop()
                UIApplication.topVC()?.pushVC(destVC)
            }) { [weak self] (_) in
                self?.btnMulti.stop()
            }
        } else {
            UIApplication.topVC()?.pushVC(destVC)
        }
    }
    
    private func cancelRequestAPI(reason: String) {
        btnCancel.setAnimationType(.BtnAppTintLoader)
        btnCancel.playAnimation()
        EP_Home.cancelRequest(requestId: String(/item?.property?.model?.request?.id), reason: reason).request(success: { [weak self] (_) in
            self?.item?.property?.model?.request?.status = .canceled
            self?.item?.property?.model?.request?.canCancel = false
            self?.item?.property?.model?.request?.canReschedule = false
            self?.item?.property?.model?.request?.cancel_reason = reason
            self?.btnCancel.stop()
            self?.didReloadCell?()
        }) { [weak self] (_) in
            self?.btnCancel.stop()
        }
    }
}
