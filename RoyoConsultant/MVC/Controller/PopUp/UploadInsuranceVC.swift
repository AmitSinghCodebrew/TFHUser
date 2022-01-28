//
//  UploadInsuranceVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 04/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class UploadInsuranceVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tfTitle: JVFloatLabeledTextField!
    @IBOutlet weak var tfDescription: JVFloatLabeledTextField!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var btnAdd: SKButton!
    @IBOutlet weak var btnDoc: UIButton!
    @IBOutlet weak var btnAtch: UIButton!
    
    var didTapAdd: ((_ model: InsuranceInfo?) -> Void)?
    private var mediaURL: String?
    private var mediaType: MediaTypeUpload = .image
    public var insurance: InsuranceInfo?
    private var isUploading = false
    var insuranceExpiry: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))
        localizedTextSetup()
        mediaPicker = SKMediaPicker.init(type: .ImageAndDocs)
        startPopUpWithAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
    }
    
    @IBAction func btnAddAction(_ sender: UIButton) {
        if isUploading {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.DOC_UPLOADING_ALERT.localized)
            return
        }
        switch Validation.shared.validate(values: (.IMAGE_DOC, /mediaURL), (.INSURANCE_NUMBER, /tfTitle.text), (.INSURANCE_EXPIRY, /tfDescription.text)) {
        case .success:
            hideVisulEffectView(callAdd: true)
        case .failure(let type, let message):
            Toast.shared.showAlert(type: type, message: /message.localized)
        }
        
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        hideVisulEffectView()
    }
}

//MARK:- VCFuncs
extension UploadInsuranceVC {
    
    @objc func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.btnDoc.isHidden = true
            self?.imgView.image = image
            self?.btnAtch.isHidden = false
            self?.uploadMediaAPI(image: image, doc: nil, type: .image)
        }, { (url, data, image) in
            //Video
        }, { [weak self] (docs) in
            self?.btnDoc.isHidden = false
            self?.imgView.image = nil
            self?.btnAtch.isHidden = true
            self?.uploadMediaAPI(image: nil, doc: docs?.first, type: .pdf)
        })
    }
    
    private func uploadMediaAPI(image: UIImage?, doc: Document?, type: MediaTypeUpload) {
        playUploadAnimation(on: imgView)
        isUploading = true
        EP_Home.uploadImage(image: image ?? UIImage(), type: type, doc: doc, localAudioPath: nil).request(success: { [weak self] (responseData) in
            self?.stopUploadAnimation()
            self?.mediaURL = (responseData as? ImageUploadData)?.image_name
            self?.mediaType = type
            self?.isUploading = false
        }) { [weak self] (error) in
            self?.stopUploadAnimation()
            self?.isUploading = false
            self?.alertBox(title: VCLiteral.UPLOAD_ERROR.localized, message: error, btn1: VCLiteral.CANCEL.localized, btn2: VCLiteral.RETRY_SMALL.localized, tapped1: {
                self?.imgView.image = nil
            }, tapped2: {
                self?.uploadMediaAPI(image: image, doc: doc, type: type)
            })
        }
    }
    
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        lblTitle.text = VCLiteral.INSURANCE_INFO.localized
        btnAdd.setTitle(VCLiteral.ADD.localized, for: .normal)
        tfTitle.placeholder = VCLiteral.INSURANCE_NUMBER.localized
        tfDescription.placeholder = VCLiteral.INSURANCE_EXPIRY.localized
        
        tfDescription.inputView = SKDatePicker.init(frame: .zero, maxDate: nil, minDate: Date(), configureDate: { [weak self] (date) in
            self?.insuranceExpiry = date
            self?.tfDescription.text = date.toString(DateFormat.custom("MMM d, yyyy"), isForAPI: false)
        })
        
        if let document = insurance {
            mediaURL = document.image
            imgView.setImageNuke(document.image)
            lblTitle.text = VCLiteral.EDIT.localized
            tfTitle.text = /document.insuranceNumber
            tfDescription.text = /document.expiry
            btnAdd.setTitle(VCLiteral.SAVE.localized, for: .normal)
        }
    }
    
    private func hideVisulEffectView(callAdd: Bool? = false) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.insurance = InsuranceInfo.init(self?.mediaURL, (self?.mediaType ?? .image), /self?.tfTitle.text, /self?.insuranceExpiry?.toString(DateFormat.custom("yyyy-MM-dd"), isForAPI: true))
            self?.visualEffectView.isHidden = true
            /callAdd ? self?.didTapAdd?(self?.insurance) : ()
            self?.removePopUp()
//            self?.dismiss(animated: true, completion: {
//
//            })
        }
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
}
