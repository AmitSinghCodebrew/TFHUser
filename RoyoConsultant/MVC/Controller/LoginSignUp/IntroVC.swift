//
//  IntroVC.swift
//  RoyoConsult
//
//  Created by Sandeep Kumar on 01/10/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import LTMorphingLabel

class IntroVC: BaseVC {
    @IBOutlet weak var lblTitle: LTMorphingLabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btn: SKLottieButton!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnSkip: UIButton!
    
    private var dataSource: CollectionDataSource?
    private var items: [Intro] = Intro.getArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = items.count
        pageControl.currentPage = 0
        lblTitle.text = /items.first?.title
        lblDesc.text = /items.first?.description
        btn.isHidden = true
        viewBtn.isHidden = true
        btn.setTitle(VCLiteral.GET_STARTED.localized, for: .normal)
        collectionViewInit()
        UserPreference.shared.isIntroScreensSeen = true
        btnSkip.setTitle(VCLiteral.SKIP.localized, for: .normal)
    }
    
    @IBAction func btnnSkipAction(_ sender: UIButton) {
        #if HealthCarePrashant || Heal || RoyoConsult
        let destVC = Storyboard<LocationRequestVC>.LoginSignUp.instantiateVC()
        pushVC(destVC)
        #else
        let tabNavigationVC = Storyboard<NavgationTabVC>.TabBar.instantiateVC()
        UIWindow.replaceRootVC(tabNavigationVC)
        #endif
    }
    
    @IBAction func btnGetStartedAction(_ sender: SKLottieButton) {
        #if HealthCarePrashant || Heal || RoyoConsult
        let destVC = Storyboard<LocationRequestVC>.LoginSignUp.instantiateVC()
        pushVC(destVC)
        #else
        let tabNavigationVC = Storyboard<NavgationTabVC>.TabBar.instantiateVC()
        UIWindow.replaceRootVC(tabNavigationVC)
        #endif
    }
}

//MARK:- VCFuncs
extension IntroVC {
    private func collectionViewInit() {
        
        let height = UIScreen.main.bounds.height - (UIApplication.topSafeArea + UIApplication.bottomSafeArea)
        
        dataSource = CollectionDataSource.init(items, IntroCell.identfier, collectionView, CGSize.init(width: UIScreen.main.bounds.width, height: height), UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0), 0, 0, .horizontal)
        
        dataSource?.configureCell = { (cell , item, indexPath) in
            (cell as? IntroCell)?.item = item
        }
        
        dataSource?.didChangeCurrentIndex = { [weak self] (indexPath) in
            self?.lblTitle.text = /self?.items[indexPath.item].title
            self?.lblDesc.text = /self?.items[indexPath.item].description
            self?.pageControl.currentPage = indexPath.item
            self?.btnSkip.isHidden = (/self?.items.count == indexPath.item  + 1)
            self?.btn.isHidden = !(/self?.items.count == indexPath.item  + 1)
            self?.viewBtn.isHidden = !(/self?.items.count == indexPath.item  + 1)
        }
        
    }
}
