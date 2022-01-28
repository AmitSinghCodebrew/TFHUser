//
//  AskQuestionVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SZTextView

class AskQuestionVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfQuestion: JVFloatLabeledTextField!
    @IBOutlet weak var tfDesc: SZTextView!
    @IBOutlet weak var btnSubmit: SKButton!
    @IBOutlet weak var lblDesc: UILabel!
    
    var didAddedQuestion: ((_ question: Question?) -> Void)?
    private var supportPackages: [Package]?
    public var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        #if HealthCarePrashant
        getSupportPackages()
        #endif
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Submit
            if /tfQuestion.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || /tfDesc.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                btnSubmit.vibrate()
                return
            }
            view.endEditing(true)
            #if HealthCarePrashant
            let destVC = Storyboard<ResponseTimePopUpVC>.PopUp.instantiateVC()
            destVC.modalPresentationStyle = .overFullScreen
            destVC.items = supportPackages
            destVC.didTapped = { [weak self] (obj) in
                self?.askQuestionAPI(obj: obj)
            }
            presentVC(destVC)
            #else
            askQuestionAPI(obj: nil)
            #endif
        default:
            break
        }
    }
    
}

//MARK: -VCFuncs
extension AskQuestionVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.ASK_FREE_QUESTIONS.localized
        tfQuestion.placeholder = VCLiteral.QUESTION.localized
        btnSubmit.setTitle(VCLiteral.SUBMIT.localized, for: .normal)
        lblDesc.text = VCLiteral.DESCRIPTION.localized
        if L102Language.isRTL {
            tfDesc.makeTextWritingDirectionRightToLeft(true)
        }
    }
    
    private func askQuestionAPI(obj: Package?) {
        view.endEditing(true)
        btnSubmit.playAnimation()
        EP_Home.submitQuestion(title: /tfQuestion.text?.trimmingCharacters(in: .whitespacesAndNewlines), desc: tfDesc.text.trimmingCharacters(in: .whitespacesAndNewlines), package_id: obj?.id, categoryId: category?.id).request { [weak self] (responseData) in
            self?.didAddedQuestion?((responseData as? QuestionsData)?.question)
            self?.btnSubmit.stop()
            self?.popTo(toControllerType: MyQuestionsVC.self)
        } error: { [weak self] (error) in
            self?.btnSubmit.stop()
        }

    }
    
    private func getSupportPackages() {
        EP_Home.supportPackages(after: nil).request { [weak self] (responseData) in
            let response = (responseData as? PackagesData)
            #if CloudDoc
            
            #else
            self?.supportPackages = response?.support_packages
            #endif
        } error: { (error) in
            
        }
    }
}
