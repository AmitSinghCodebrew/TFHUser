//
//  QuestionDetailVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class QuestionDetailVC: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblQuestionDesc: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var question: Question?
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Answer>, DefaultCellModel<Answer>, Answer>?
    private var answers: [Answer]?
    public var questionId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = questionId {
            questionDetailAPI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setData()
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        popVC()
    }
}

//MARK:- VCFuncs
extension QuestionDetailVC {
    
    public func questionDetailAPI() {
        playLineAnimation()
        EP_Home.questionDetail(questionId: questionId).request { [weak self] (responseData) in
            self?.question = (responseData as? QuestionsData)?.question
            self?.setData()
            self?.stopLineAnimation()
        } error: { [weak self] (error) in
            self?.stopLineAnimation()
        }
    }
    
    private func setData() {
        errorView.removeFromSuperview()
        lblTitle.text = VCLiteral.QUESTION_DETAIL_TITLE.localized
        lblQuestion.text = /question?.title
        lblQuestionDesc.text = /question?.description
        lblAnswer.text = /question?.answers?.count == 1 ? VCLiteral.ANSWER.localized : VCLiteral.ANSWERS.localized
        answers = question?.answers
        tableViewInit()
        if /question?.answers?.count == 0 {
            showVCPlaceholder(type: .NoAnswers, scrollView: tableView)
        }
    }
    
    private func tableViewInit() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<Answer>, DefaultCellModel<Answer>, Answer>.init(.SingleListing(items: answers ?? [], identifier: AnswerCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, false)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? AnswerCell)?.item = item
        }
    }
}
