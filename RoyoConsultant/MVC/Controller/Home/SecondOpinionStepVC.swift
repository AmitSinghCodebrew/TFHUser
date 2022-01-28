//
//  SecondOpinionStepVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 30/10/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class SecondOpinionStepVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRecordDetails: UILabel!
    @IBOutlet weak var tfRecord: JVFloatLabeledTextField!
    @IBOutlet weak var lblAddImages: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var btnDone: SKButton!
    
    public var appt: Requests?
    private var images = [AddMedia(nil, .image)]
    private var dataSource: CollectionDataSource?
    public var sizeProvider: CollectionSizeProvider!
    public var didAddedPrescription: (() -> Void)?
    public var didTaskCompleted: ((_ images: [String], _ title: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        collectionViewInit()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: // Back
            popVC()
        case 1: // Done
            validateData()
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension SecondOpinionStepVC {
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.MEDICAL_RECORD.localized
        lblRecordDetails.text = VCLiteral.RECORD_DETAILS.localized
        tfRecord.placeholder = VCLiteral.RECORD_TITLE.localized
        lblAddImages.text = VCLiteral.ADD_IMAGES.localized
        btnDone.setTitle(VCLiteral.DONE.localized, for: .normal)
    }
    
    private func collectionViewInit() {
        let cellWidth = (UIScreen.main.bounds.width - (16 * 5)) / 4
        
        sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: cellWidth, height: cellWidth), interItemSpacing: 16, lineSpacing: 16, edgeInsets: UIEdgeInsets.init(top: 0, left: 16, bottom: 16, right: 16))
        
        dataSource = CollectionDataSource.init(images, AddImageCell.identfier, collectionView, sizeProvider.cellSize, sizeProvider.edgeInsets, sizeProvider.lineSpacing, sizeProvider.interItemSpacing, .vertical)
        
        dataSource?.configureCell = { [weak self] (cell, item, indexPath) in
            (cell as? AddImageCell)?.item = item
            (cell as? AddImageCell)?.didTapDelete = {
                self?.images.remove(at: indexPath.item)
                self?.dataSource?.items = self?.images
                self?.collectionView.deleteItems(at: [indexPath])
            }
        }
        
        dataSource?.didSelectItem = { [weak self] (indexPath, item) in
            if indexPath.item == 0 {
                self?.mediaPicker.presentPicker({ (image) in
                    self?.addImage(image: image)
                }, nil, nil)
            }
        }
        
        collectionHeight.constant = sizeProvider.getHeightOfTableViewCell(for: 4, gridCount: 4)
    }
    
    private func validateData() {
        if /tfRecord.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.RECORD_TITLE_ALERT.localized)
            btnDone.vibrate()
            return
        } else if /images.count == 1 {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.PRESCRIPTION_IMAGE_ALERT.localized)
            btnDone.vibrate()
            return
        } else if /images.contains(where: {/$0.isUploading}) {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.DOC_UPLOADING_ALERT.localized)
            btnDone.vibrate()
            return
        } else {
            popVC()
            let tempImages = images.filter({$0.url != nil}).map({/($0.url as? String)})
            didTaskCompleted?(tempImages, /tfRecord.text)
        }
    }
    
    private func addImage(image: UIImage) {
        let imageObj = AddMedia.init(image, .image)
        imageObj.isUploading = true
        images.append(imageObj)
        collectionHeight.constant = sizeProvider.getHeightOfTableViewCell(for: images.count < 4 ? 4 : images.count + 1, gridCount: 4)
        dataSource?.items = images
        collectionView.insertItems(at: [IndexPath(row: images.count - 1, section: 0)])
        uploadImageAPI(image: image, indexPath: IndexPath(row: images.count - 1, section: 0))
    }
    
    private func uploadImageAPI(image: UIImage, indexPath: IndexPath) {
        EP_Home.uploadImage(image: image, type: .image, doc: nil, localAudioPath: nil).request(success: { [weak self] (responseData) in
            let tempData = responseData as? ImageUploadData
            self?.images[indexPath.item].isUploading = false
            self?.images[indexPath.item].url = tempData?.image_name
            self?.dataSource?.items = self?.images
            self?.collectionView.reloadItems(at: [indexPath])
        }) { [weak self] (error) in
            self?.images[indexPath.item].isUploading = false
            self?.dataSource?.items = self?.images
            self?.collectionView.reloadItems(at: [indexPath])
            self?.alertBox(title: VCLiteral.UPLOAD_ERROR.localized, message: nil, btn1: VCLiteral.CANCEL.localized, btn2: VCLiteral.RETRY_SMALL.localized, tapped1: {
                self?.images.remove(at: indexPath.item)
                self?.dataSource?.items = self?.images
                self?.collectionView.deleteItems(at: [indexPath])
                self?.collectionHeight.constant = /self?.sizeProvider.getHeightOfTableViewCell(for: /self?.images.count < 4 ? 4 : /self?.images.count + 1, gridCount: 4)
            }, tapped2: {
                self?.images[indexPath.item].isUploading = true
                self?.dataSource?.items = self?.images
                self?.collectionView.reloadItems(at: [indexPath])
                self?.uploadImageAPI(image: image, indexPath: indexPath)
            })
        }
    }
}
