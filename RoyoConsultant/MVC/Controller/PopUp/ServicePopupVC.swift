//
//  UploadInsuranceVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 04/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ServicePopupVC: BaseVC {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionServices: UICollectionView!
    
    private var collectionDataSource: CollectionDataSource?
    private var services: [Service]?
    public var category: Category?

    var didSelected: ((_ service: Service?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizedTextSetup()
        getServicesAPI()
        
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
        default:
            break
        }
    }
}

extension ServicePopupVC {
    
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        lblTitle.text = VCLiteral.SERVICE_TYPE.localized
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
}
extension ServicePopupVC {
    
    private func getServicesAPI() {
        EP_Home.services(categoryId: String(/category?.id)).request(success: { [weak self] (responseData) in
            self?.services = (responseData as? ServicesData)?.services
            self?.collectionDataSource?.updateData(self?.services)
            UIView.animate(withDuration: 0.3) {
                self?.collectionServices.isHidden = /self?.services?.count <= 0
            }
            self?.collectionViewInit()
        }) { (error) in
            
        }
    }
    
    private func collectionViewInit() {
        
        let width = (UIScreen.main.bounds.width - 48.0) / 2.0
        
        collectionDataSource = CollectionDataSource.init(services, ServicesCollCell.identfier, collectionServices, CGSize.init(width: width, height: 40), UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16), 16, 16, .vertical)
        
        collectionDataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? ServicesCollCell)?.item = item
        }
        
        collectionDataSource?.didSelectItem = { [weak self] (indexPath, item) in
            self?.dismiss(animated: true, completion: {
                self?.didSelected?(item as? Service)
            })
        }
    }
}

