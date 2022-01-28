//
//  ChooseDateTimeVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 10/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ChooseDateTimeVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblExtraInfo: UILabel!
    @IBOutlet weak var collectionViewDates: UICollectionView!
    @IBOutlet weak var collectionViewSlots: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    
    private var datesDataSource: CollectionDataSource?
    private var slotsDataSource: CollectionDataSource?
    private var timeIntervals: [Interval]?
    private var dates = [DateModel]()
    private var selectedDate: Date? = Date()
    
    public var vendor: User?
    public var service: Service?
    public var selectedDateTime: SelectedDateTime?
    public var didSelecteDateTime: ((_ dateTime: SelectedDateTime?) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        
        if let oldData = selectedDateTime {
            dates = oldData.datesArray ?? []
            timeIntervals = oldData.intervalsArray
            selectedDate = oldData.selectedDate
        } else {
            dates = DateModel.getDates()
            selectedDate = Date()
            getSlotsAPI()
        }
        datesCollectionSetup()
        slotsCollectionSetup()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        popVC()
    }
    
}



//MARK:- VCFuncs
extension ChooseDateTimeVC {
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.CHOOSE_DATE_TIME.localized
        imgView.setImageNuke(/vendor?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        lblName.text = /vendor?.name?.capitalizingFirstLetter()
        lblExtraInfo.text = /vendor?.categoryData?.name?.capitalizingFirstLetter()
        lblNoData.isHidden = true
    }
    
    private func datesCollectionSetup() {
        
        
        datesDataSource = CollectionDataSource.init(dates, ChooseDateCell.identfier, collectionViewDates, CGSize.init(width: L102Language.isRTL ? 96 : 88, height: 72), UIEdgeInsets.init(top: 0, left: 16.0, bottom: 0, right: 16.0), 16, 0, .horizontal)
        
        datesDataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? ChooseDateCell)?.item = item
        }
        
        datesDataSource?.didSelectItem = { [weak self] (indexPath, item) in
            self?.dates.forEach { $0.isSelected = false }
            self?.dates[indexPath.item].isSelected = true
            self?.datesDataSource?.updateData(self?.dates)
            self?.timeIntervals = []
            self?.slotsDataSource?.updateData(self?.timeIntervals)
            self?.selectedDate = (item as? DateModel)?.date
            self?.getSlotsAPI()
        }
        
        guard let indexToScroll: Int = dates.firstIndex(where: {/$0.isSelected}) else {
            return
        }
        collectionViewDates.scrollToItem(at: IndexPath(item: indexToScroll, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func slotsCollectionSetup() {
        let widthOfCell = (UIScreen.main.bounds.width - (16.0 * 4.0)) / 3.0
        slotsDataSource = CollectionDataSource.init(timeIntervals, ChooseTimeCell.identfier, collectionViewSlots, CGSize.init(width: widthOfCell, height: 32), UIEdgeInsets.init(top: 20.0, left: 15.9, bottom: 20.0, right: 16.0), 16.0, 16.0, .vertical)
        
        slotsDataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? ChooseTimeCell)?.item = item
        }
        
        slotsDataSource?.didSelectItem = { [weak self] (indexPath, item) in
            if /(item as? Interval)?.available {
                self?.timeIntervals?.forEach { $0.isSelected = false }
                self?.timeIntervals?[indexPath.row].isSelected = true
                self?.slotsDataSource?.updateData(self?.timeIntervals)
                self?.selectedDateTime = SelectedDateTime.init(self?.selectedDate, (item as? Interval)?.time, self?.dates, self?.timeIntervals)
                self?.popVC(animated: true)
                self?.didSelecteDateTime?(self?.selectedDateTime)
            } else {
                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.SLOT_FULL_ALERT.localized)
            }
        }
    }
    
    private func getSlotsAPI() {
        playLineAnimation()
        lblNoData.isHidden = true
        lblNoData.text = String(format: VCLiteral.NO_TIME_SLOTS.localized, /selectedDate?.toString(DateFormat.custom(UserPreference.shared.dateFormat), isForAPI: false))
        EP_Home.getSlots(vendorId: String(/vendor?.id), date: selectedDate?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local, isForAPI: true), serviceId: String(/service?.service_id), categoryId: String(/service?.category_id)).request(success: { [weak self] (responseData) in
            self?.timeIntervals = (responseData as? SlotsData)?.interval
            self?.lblNoData.isHidden = /self?.timeIntervals?.count != 0
            self?.slotsDataSource?.updateData(self?.timeIntervals)
            self?.stopLineAnimation()
        }) { [weak self] (error) in
            self?.stopLineAnimation()
            self?.lblNoData.isHidden = true
            self?.showErrorView(error: /error, scrollView: self?.collectionViewSlots, tapped: {
                self?.errorView.removeFromSuperview()
                self?.getSlotsAPI()
            })
        }
    }
}
