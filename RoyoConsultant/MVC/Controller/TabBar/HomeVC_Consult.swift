//
//  HomeVC_Consult.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 27/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeVC_Consult: BaseVC {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(HomeSectionView.identfier)
            tableView.registerXIBForHeaderFooter(HomeSectionViewShort.identfier)
        }
    }
    
    private var items: [HomeSectionProvider]?
    private var categories: [Category]?
    private var dataSource: TableDataSource<HomeSectionProvider, HomeCellProvider, HomeCellModel>?
    public var isClassesScreen: Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInit()

        #if HomeDoctorKhalid
        if /UserPreference.shared.data?.phone == "" && UserPreference.shared.data != nil {
            let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .updatePhone
            self.pushVC(destVC)
        }
        #endif
    }
    override func viewWillAppear(_ animated: Bool) {
        #if HomeDoctorKhalid
        dataSource?.refreshProgrammatically()
        #endif
    }
}

//MARK:- VCFuncs
extension HomeVC_Consult {
    
    private func tableViewInit() {
        dataSource = TableDataSource<HomeSectionProvider, HomeCellProvider, HomeCellModel>.init(.MultipleSection(items: items ?? []), tableView, true)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? HomeSectionView)?.isClassesScreen = self.isClassesScreen
            (view as? HomeSectionView)?.item = item
            (view as? HomeSectionViewShort)?.item = item
            (view as? HomeSectionViewShort)?.didTapAction = { [weak self] (action) in
                self?.headerTapped(for: action)
            }
        }
        
        dataSource?.configureCell = { [weak self] (cell, item, indexPath) in
            (cell as? HomeCollCell)?.item = item
            (cell as? HomeCollCell)?.isClassesScreen = self?.isClassesScreen
            (cell as? Category3StackCell)?.item = item
            (cell as? Category3StackCell)?.isClassesScreen = self?.isClassesScreen
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getBannersAPI()
        }
        #if HomeDoctorKhalid
        #else
        dataSource?.refreshProgrammatically()
        #endif
    }
    
    private func getCategoriesAPI(isRefreshing: Bool? = false) {
        EP_Home.categories(parentId: nil, after: nil, per_page: 10).request(success: { [weak self] (responseData) in
            let data = responseData as? CategoryData
            self?.categories = data?.classes_category
            self?.items?.append(contentsOf: HomeSectionProvider.getCategoriesFor3Stacks(self?.categories, isClasses: /self?.isClassesScreen))
            self?.getHomeDataAPI()
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
            self?.dataSource?.stopInfiniteLoading(data?.after == nil ? .NoContentAnyMore : .FinishLoading)
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            if /self?.items?.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
    
    private func getBannersAPI() {
        EP_Home.banners.request(success: { [weak self] (responseData) in
            let banners = (responseData as? BannersData)?.banners
            if /banners?.count != 0 {
                let bannerSection = HomeSectionProvider.getBanners(banners)
                self?.items = [bannerSection]
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
                self?.dataSource?.stopInfiniteLoading(.FinishLoading)
                self?.getCategoriesAPI()
            } else {
                self?.items = []
                self?.dataSource?.stopInfiniteLoading(.FinishLoading)
                self?.getCategoriesAPI()
            }
            self?.stopLineAnimation()
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
        }
    }
    
    private func getHomeDataAPI() {
        EP_Home.home.request(success: { [weak self] (responseData) in
            let data = (responseData as? HomeData)
            var indexesArray = [Int]()
            
            #if HomeDoctorKhalid
            (UIApplication.topVC() as? HomeVC)?.lblNotificationCount.text = "\(/data?.notification_count)"
            (UIApplication.topVC() as? HomeVC)?.vwNotificationCOunt.isHidden = (/data?.notification_count == 0)
            
            if AppSettings.homeScreenServices.count > 0 {
                self?.items?.insert(HomeSectionProvider.getServices(tip: data?.tips?.first), at: 1)
                indexesArray.append(1)
            }
            #else
            (self?.parent as? HomeVC)?.vwNotificationCOunt.isHidden = true

            #endif
            if AppSettings.showBlogsOnHomeScreen {
                if let blogSection = HomeSectionProvider.getBlogs(feed: data?.top_blogs ?? []) {
                    self?.items?.append(blogSection)
                    indexesArray.append(/self?.items?.count - 1)
                }
            }
            
            if AppSettings.showArticlesOnHomeScreen {
                if let articleSection = HomeSectionProvider.getArticles(feed: data?.top_articles ?? []) {
                    self?.items?.append(articleSection)
                    indexesArray.append(/self?.items?.count - 1)
                }
            }
            
            if AppSettings.showFreeQuestionsOnHomeScreen {
                if let questionSection = HomeSectionProvider.getQuestions(feed: data?.questions ?? []) {
                    self?.items?.append(questionSection)
                    indexesArray.append(/self?.items?.count - 1)
                }
            }
            
            if AppSettings.showTestimonialsOnHomeScreen {
                if let testimonialSection = HomeSectionProvider.getTestimonials(reviews: data?.testimonials) {
                    self?.items?.append(testimonialSection)
                    indexesArray.append(/self?.items?.count - 1)
                }
            }
            
            if AppSettings.showHealthTools {
                self?.items?.append(HomeSectionProvider.getHealthTools())
                indexesArray.append(/self?.items?.count - 1)
            }
            
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .InsertSection(indexSet: IndexSet.init(indexesArray), animation: .automatic))
            
        }) { (error) in
            
        }
    }
    
    private func headerTapped(for customAction: HeaderActionType?) {
        guard let action = customAction else { return }
        switch action {
        case .ViewAllArticles:
            let destVC = Storyboard<BlogArticleListingVC>.Home.instantiateVC()
            destVC.feedType = .article
            pushVC(destVC)
        case .ViewAllBogs:
            let destVC = Storyboard<BlogArticleListingVC>.Home.instantiateVC()
            destVC.feedType = .blog
            pushVC(destVC)
        case .ViewAllQuestions:
            let destVC = Storyboard<BlogArticleListingVC>.Home.instantiateVC()
            destVC.feedType = .question
            pushVC(destVC)
        case .MyQuestions:
            let destVC = Storyboard<MyQuestionsVC>.Home.instantiateVC()
            pushVC(destVC)
        }
    }
}
