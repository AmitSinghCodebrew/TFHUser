//
//  PreAssesmentVC.swift
//  CloudDoc
//
//  Created by Sandeep Kumar on 19/04/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class PreAssesmentVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDone: SKLottieButton!
    @IBOutlet weak var lblHowLonngFelt: UILabel!
    @IBOutlet weak var tfDesc: UITextField!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var tfWeight: UITextField!
    @IBOutlet weak var lblheight: UILabel!
    @IBOutlet weak var tfHeight: UITextField!
    @IBOutlet weak var lblTakingMedication: UILabel!
    @IBOutlet weak var lblAllergies: UILabel!
    @IBOutlet weak var lblSmoke: UILabel!
    @IBOutlet weak var lblDrink: UILabel!
    @IBOutlet weak var switchMedication: UISegmentedControl!
    @IBOutlet weak var switchAllergies: UISegmentedControl!
    @IBOutlet weak var switchSmoke: UISegmentedControl!
    @IBOutlet weak var switchDrinnk: UISegmentedControl!
    
    var request: Requests?
    private var doMedicating: YesNo = .No
    private var doAllergies: YesNo = .No
    private var doSmoke: YesNo = .No
    private var doDrink: YesNo = .No
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedSetup()
    }

    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: // Back
            break
        case 1: //DONE
            addQuestionaireAPI()
        default: break
        }
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.tag {
        case 0: //MEDICATION
            doMedicating = sender.selectedSegmentIndex == 0 ? .Yes :.No
        case 1: //ALLERGIES
            doAllergies = sender.selectedSegmentIndex == 0 ? .Yes :.No
        case 2: //SMOKE
            doSmoke = sender.selectedSegmentIndex == 0 ? .Yes :.No
        case 3: //DRINK
            doDrink = sender.selectedSegmentIndex == 0 ? .Yes :.No
        default: break
        }
    }
}

//MARK:- VCFuncs
extension PreAssesmentVC {
    private func localizedSetup() {
        lblTitle.text = VCLiteral.PRE_ASSESMENT.localized
        lblHowLonngFelt.text = VCLiteral.HOW_LONG_FELT_THIS_WAY.localized
        tfDesc.placeholder = VCLiteral.DESCRIPTION.localized
        lblWeight.text = VCLiteral.WHAT_WEIGHT.localized
        tfWeight.placeholder = VCLiteral.WEIGHT_WITH_UNIT.localized
        lblheight.text = VCLiteral.WHAT_HEIGHT.localized
        tfHeight.placeholder = VCLiteral.HEIGHT_WITH_UNIT.localized
        lblTakingMedication.text = VCLiteral.TAKING_MEDICATION.localized
        lblAllergies.text = VCLiteral.DO_ALLERGIES.localized
        lblSmoke.text = VCLiteral.DO_SMOKE.localized
        lblDrink.text = VCLiteral.DO_DRINK.localized
        [switchMedication, switchAllergies, switchSmoke, switchDrinnk].forEach({
            $0?.setTitle(VCLiteral.YES.localized, forSegmentAt: 0)
            $0?.setTitle(VCLiteral.NO.localized, forSegmentAt: 1)
        })
        
        btnDone.setTitle(VCLiteral.DONE.localized, for: .normal)
        
        switchMedication.selectedSegmentIndex = doMedicating == .Yes ? 0 : 1
        switchAllergies.selectedSegmentIndex = doAllergies == .Yes ? 0 : 1
        switchSmoke.selectedSegmentIndex = doSmoke == .Yes ? 0 : 1
        switchDrinnk.selectedSegmentIndex = doDrink == .Yes ? 0 : 1
    }
    
    private func addQuestionaireAPI() {
        var questionAnswers = [QuestionAnswer]()
        questionAnswers.append(QuestionAnswer.init(VCLiteral.HOW_LONG_FELT_THIS_WAY.localized, tfDesc.text))
        questionAnswers.append(QuestionAnswer.init(VCLiteral.WHAT_WEIGHT.localized, tfWeight.text))
        questionAnswers.append(QuestionAnswer.init(VCLiteral.WHAT_HEIGHT.localized, tfHeight.text))
        questionAnswers.append(QuestionAnswer.init(VCLiteral.TAKING_MEDICATION.localized, doMedicating.rawValue))
        questionAnswers.append(QuestionAnswer.init(VCLiteral.DO_ALLERGIES.localized, doAllergies.rawValue))
        questionAnswers.append(QuestionAnswer.init(VCLiteral.DO_SMOKE.localized, doSmoke.rawValue))
        questionAnswers.append(QuestionAnswer.init(VCLiteral.DO_DRINK.localized, doDrink.rawValue))
        btnDone.playAnimation()

        EP_Home.addCarePlan(requestID: /request?.id, care_plans: nil, question_answers: JSONHelper<[QuestionAnswer]>().toDictionary(model: questionAnswers)).request { [weak self] (responseData) in
            self?.btnDone.stop()
            self?.popTo(toControllerType: VendorDetailVC.self)
            self?.popTo(toControllerType: AppointmentsVC.self)
        } error: { [weak self] (error) in
            self?.btnDone.stop()
        }

    }
}
