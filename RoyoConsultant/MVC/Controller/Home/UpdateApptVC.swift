//
//  UpdateApptVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 20/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import SZTextView

class UpdateApptVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfSymtomDesc: SZTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnConntinue: SKButton!
    @IBOutlet weak var btnSkip: SKLottieButton!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var heightCollectionImages: NSLayoutConstraint!
    
    private var dataSource: CollectionDataSource? //Symptoms
    private var imagesDataSource: CollectionDataSource? //Upload images
    public var sizeProvider: CollectionSizeProvider! //for imagesDataSource

    private var items: [Symptom]?
    private var after: String?
    private var images = [AddMedia(nil, .image)]

    var request: Requests?

    override func viewDidLoad() {
        super.viewDidLoad()
        mediaPicker = SKMediaPicker.init(type: .ImageAndDocs)
        localizedTextSetup()
        collectionViewImagesInit()
        collectionViewInit()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popTo(toControllerType: VendorDetailVC.self)
        case 1: //Submit
            if /tfSymtomDesc.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.SYMPTOM_DESC_ALERT.localized)
                btnConntinue.vibrate()
                return
            }
//            else if image_URL == nil {
//                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.REPORT_UPLOAD_ALERT.localized)
//                btnConntinue.vibrate()
//                return
//            } else if /items?.filter({/$0.isSelected}).count == 0 {
//                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.SELECT_SYMPTOM_ALERT.localized)
//                btnConntinue.vibrate()
//                return
//            }
            updateApptSymptomsAPI()
        case 2: //Skip
            popTo(toControllerType: VendorDetailVC.self)
        default:
            break
        }
    }
    
    
}

//MARK:- VCFuncs
extension UpdateApptVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.UPDATE_APPT_TITLE.localized
        tfSymtomDesc.placeholder = VCLiteral.SYMPTOM_DESC_PLACEHOLDER.localized
        btnSkip.setTitle(VCLiteral.SKIP.localized, for: .normal)
        btnConntinue.setTitle(VCLiteral.SUBMIT.localized, for: .normal)
        if L102Language.isRTL {
            tfSymtomDesc.makeTextWritingDirectionRightToLeft(true)
        }

    }
    
    private func getSymptomsAPI(isRefreshing: Bool? = false) {
        EP_Home.symptoms(type: .all_symptom_options, symptomId: nil).request { [weak self] (responseData) in
            let response = responseData as? SymptomsData
            self?.after = response?.after
            if /isRefreshing {
                self?.items = response?.symptoms ?? []
            } else {
                self?.items = (self?.items ?? []) + (response?.symptoms ?? [])
            }
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateData(self?.items)

        } error: { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            
            if /self?.items?.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.collectionView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
    
    private func updateApptSymptomsAPI() {
        let ids = self.items?.filter({/$0.isSelected}).map({String(/$0.id)}).joined(separator: ",")
        btnConntinue.playAnimation()
        
        let mediaToUp = JSONHelper<[MediaObj]>().toDictionary(model: MediaObj.getArrayToUp(items: images))
        
        EP_Home.updateRequestSymptoms(requestId: request?.id, option_ids: ids, symptom_details: tfSymtomDesc.text, images: mediaToUp).request { [weak self] (responseData) in
            self?.btnConntinue.stop()
            self?.popTo(toControllerType: VendorDetailVC.self)
            self?.popTo(toControllerType: AppointmentsVC.self)
        } error: { [weak self] (error) in
            self?.btnConntinue.stop()
        }
    }
    
    private func collectionViewImagesInit() {
        
        let cellWidth = (UIScreen.main.bounds.width - (16 * 5)) / 4
        
        sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: cellWidth, height: cellWidth), interItemSpacing: 16, lineSpacing: 16, edgeInsets: UIEdgeInsets.init(top: 0, left: 16, bottom: 16, right: 16))
        
        imagesDataSource = CollectionDataSource.init(images, AddImageCell.identfier, collectionImages, sizeProvider.cellSize, sizeProvider.edgeInsets, sizeProvider.lineSpacing, sizeProvider.interItemSpacing, .vertical)
        
        imagesDataSource?.configureCell = { [weak self] (cell, item, indexPath) in
            (cell as? AddImageCell)?.item = item
            (cell as? AddImageCell)?.didTapDelete = {
                self?.images.remove(at: indexPath.item)
                self?.dataSource?.items = self?.images
                self?.collectionImages.deleteItems(at: [indexPath])
            }
        }
        
        imagesDataSource?.didSelectItem = { [weak self] (indexPath, item) in
            if indexPath.item == 0 {
                self?.mediaPicker.presentPicker({ (image) in
                    self?.addImage(image: image)
                }, nil, { (docs) in
                    self?.addDoc(doc: docs?.first)
                })
            }
        }
        
        heightCollectionImages.constant = sizeProvider.getHeightOfTableViewCell(for: 4, gridCount: 4)
    }
    
    private func addDoc(doc: Document?) {
        let docObj = AddMedia.init(doc?.url, .pdf, doc)
        docObj.isUploading = true
        images.append(docObj)
        heightCollectionImages.constant = sizeProvider.getHeightOfTableViewCell(for: images.count < 4 ? 4 : images.count + 1, gridCount: 4)
        imagesDataSource?.items = images
        collectionImages.insertItems(at: [IndexPath(row: images.count - 1, section: 0)])
        uploadImageAPI(image: UIImage(), indexPath: IndexPath(row: images.count - 1, section: 0), doc: doc, type: .pdf)
    }
    
    private func addImage(image: UIImage) {
        let imageObj = AddMedia.init(image, .image)
        imageObj.isUploading = true
        images.append(imageObj)
        heightCollectionImages.constant = sizeProvider.getHeightOfTableViewCell(for: images.count < 4 ? 4 : images.count + 1, gridCount: 4)
        imagesDataSource?.items = images
        collectionImages.insertItems(at: [IndexPath(row: images.count - 1, section: 0)])
        uploadImageAPI(image: image, indexPath: IndexPath(row: images.count - 1, section: 0), doc: nil, type: .image)
    }
    
    private func uploadImageAPI(image: UIImage, indexPath: IndexPath, doc: Document?, type: MediaTypeUpload) {
        EP_Home.uploadImage(image: image, type: type, doc: doc, localAudioPath: nil).request(success: { [weak self] (responseData) in
            let tempData = responseData as? ImageUploadData
            self?.images[indexPath.item].isUploading = false
            self?.images[indexPath.item].url = tempData?.image_name
            self?.imagesDataSource?.items = self?.images
            self?.collectionImages.reloadItems(at: [indexPath])
        }) { [weak self] (error) in
            self?.images[indexPath.item].isUploading = false
            self?.imagesDataSource?.items = self?.images
            self?.collectionView.reloadItems(at: [indexPath])
            self?.alertBox(title: VCLiteral.UPLOAD_ERROR.localized, message: nil, btn1: VCLiteral.CANCEL.localized, btn2: VCLiteral.RETRY_SMALL.localized, tapped1: {
                self?.images.remove(at: indexPath.item)
                self?.imagesDataSource?.items = self?.images
                self?.collectionImages.deleteItems(at: [indexPath])
                self?.heightCollectionImages.constant = /self?.sizeProvider.getHeightOfTableViewCell(for: /self?.images.count < 4 ? 4 : /self?.images.count + 1, gridCount: 4)
            }, tapped2: {
                self?.images[indexPath.item].isUploading = true
                self?.imagesDataSource?.items = self?.images
                self?.collectionImages.reloadItems(at: [indexPath])
                self?.uploadImageAPI(image: image, indexPath: indexPath, doc: doc, type: type)
            })
        }
    }
    
    private func collectionViewInit() {
//        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .center)
//        layout.scrollDirection = .vertical
//
//        layout.minimumInteritemSpacing = 16
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
//        layout.sectionHeadersPinToVisibleBounds = true
//        layout.estimatedItemSize = CGSize(width: 50, height: 48)
//        collectionView.collectionViewLayout = layout
               
        let width = ((UIScreen.main.bounds.width - 32) - 32) / 3
        dataSource = CollectionDataSource.init(items, OptionCell.identfier, collectionView, CGSize.init(width: width, height: 48.0), UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16), 16, 16, .vertical)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? OptionCell)?.item = item
        }
        
        dataSource?.addPullToRefreshVertically({ [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getSymptomsAPI(isRefreshing: true)
        })
        
        dataSource?.addInfiniteScrollVertically = { [weak self] in
            if self?.after != nil {
                self?.getSymptomsAPI(isRefreshing: false)
            }
        }
        
        dataSource?.didSelectItem = { [weak self] (indexPath, item) in
            (item as? Symptom)?.isSelected = !(/(item as? Symptom)?.isSelected)
            self?.collectionView.reloadData()
        }
        
        dataSource?.refreshProgrammatically()
    }
}
