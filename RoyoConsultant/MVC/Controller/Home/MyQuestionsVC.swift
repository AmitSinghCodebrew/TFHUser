//
//  MyQuestionsVC.swift
//  RoyoConsult
//
//  Created by Sandeep Kumar on 12/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class MyQuestionsVC: BaseVC {
    @IBOutlet weak var btnAsk: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Question>, DefaultCellModel<Question>, Question>?
    private var items: [Question]?
    private var after: String?
    private var canAsk: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getQuestionsAPI(isRefreshing: true)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Ask
            #if Heal || RoyoConsult
            if !canAsk {
                Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.ASK_QUESTION_ALERT.localized)
                return
            }
            let destVC = Storyboard<SubCategoryVC>.Home.instantiateVC()
            destVC.navigationType = .AskQuestion
            pushVC(destVC)
            #else
            let destVC = Storyboard<AskQuestionVC>.Home.instantiateVC()
            destVC.didAddedQuestion = { [weak self] (question) in
                self?.errorView.removeFromSuperview()
                self?.items?.insert(question!, at: 0)
                self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
                #if Heal || RoyoConsult
                self?.canAsk = false
                #endif
            }
            pushVC(destVC)
            #endif
        default:
            break
        }
    }
}

//MARK: -VCFuncs
extension MyQuestionsVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.MY_QUESTIONS.localized
        btnAsk.setTitle(VCLiteral.ASK.localized, for: .normal)
    }
    
    private func tableViewInit() {
                
        dataSource = TableDataSource<DefaultHeaderFooterModel<Question>, DefaultCellModel<Question>, Question>.init(.SingleListing(items: items ?? [], identifier: MyQuestionCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? MyQuestionCell)?.item = item
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getQuestionsAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getQuestionsAPI(isRefreshing: false)
            }
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            let destVC = Storyboard<QuestionDetailVC>.Home.instantiateVC()
            destVC.question = item?.property?.model
            self?.pushVC(destVC)
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func getQuestionsAPI(isRefreshing: Bool? = false) {
        EP_Home.getQuestions(after: /isRefreshing ? nil : after).request(success: { [weak self] (responseData) in
            let newItems = (responseData as? QuestionsData)?.questions
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            
            let response = responseData as? QuestionsData
            self?.canAsk = /response?.can_ask_question
            self?.after = response?.after
            if /isRefreshing {
                self?.items = newItems ?? []
            } else {
                self?.items = (self?.items ?? []) + (newItems ?? [])
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoQuestions, scrollView: self?.tableView) : self?.errorView.removeFromSuperview()
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
            
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
}
