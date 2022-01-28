//
//  ClassCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<ClassObj>
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblExtraInfo: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnOccupy: SKLottieButton!
    
    var didReloadCellWithObj: ((_ obj: ClassObj?) -> Void)?
    
    var item: DefaultCellModel<ClassObj>? {
        didSet {
            obj = item?.property?.model
        }
    }
    
    var item2: VD_Cell_Provider? {
        didSet {
            obj = item2?.property?.model?.classObj
        }
    }
    
    var obj: ClassObj? {
        didSet {
            imgView.setImageNuke(/obj?.created_by?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            lblName.text = /obj?.created_by?.profile?.title + " " + /obj?.created_by?.name?.capitalizingFirstLetter()
            lblExtraInfo.text = /obj?.category_data?.name
            lblType.text = /obj?.name?.capitalizingFirstLetter()
            lblDate.text = Date.init(fromString: /obj?.class_date, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc).toString(DateFormat.custom("dd MMM yyyy · hh:mm a"), timeZone: .local, isForAPI: false)
            lblPrice.text = /obj?.price?.getFormattedPrice()
            btnOccupy.setTitle(/obj?.isOccupied ? VCLiteral.JOIN_CLASS.localized : VCLiteral.OCCUPY_CLASS.localized, for: .normal)
            btnOccupy.setAnimationType(.BtnAppTintLoader)
            btnOccupy.isHidden = obj?.status == .completed
        }
    }

    @IBAction func btnOccupyAction(_ sender: UIButton) {
        switch /sender.title(for: .normal) {
        case VCLiteral.OCCUPY_CLASS.localized:
            classOccupyAlert()
        case VCLiteral.JOIN_CLASS.localized:
            classJoinAPI()
        default:
            break
        }
    }
    
    private func classOccupyAlert() {
        UIApplication.topVC()?.alertBoxOKCancel(title: VCLiteral.OCCUPY_CLASS.localized, message: VCLiteral.OCCUPY_CLASS_ALERT_MESSAGE.localized, tapped: { [weak self] in
            self?.enrollUserAPI()
        }, cancelTapped: nil)
    }
    
    private func classJoinAPI() {
        btnOccupy.playAnimation()
        EP_Home.classJoin(classId: String(/obj?.id)).request(success: { [weak self] (_) in
            self?.btnOccupy.stop()
            (UIApplication.shared.delegate as? AppDelegate)?.startJitsiCall(roomName: String(/self?.obj?.id) , subject: /self?.obj?.name, isVideo: true)
            
//            (UIApplication.shared.delegate as? AppDelegate)?.startJitsiCall(roomName: /UserPreference.shared.clientDetail?.getJitsiUniqueID(.CLASS, id: /self?.obj?.id), subject: /self?.obj?.name, isVideo: true)
            
        }) { [weak self] (_) in
            self?.btnOccupy.stop()
        }
    }
    
    private func enrollUserAPI() {
        btnOccupy.playAnimation()
        EP_Home.enrollUser(classId: String(/obj?.id)).request(success: { [weak self] (_) in
            self?.btnOccupy.stop()
            self?.obj?.isOccupied = true
            self?.didReloadCellWithObj?(self?.obj)
        }) { [weak self] (_) in
            self?.btnOccupy.stop()
        }
    }
}
