//
//  AddMoneyVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
#if HealthCarePrashant
import Razorpay
#endif
import Lottie

class AddMoneyVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInputAmount: UILabel!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var btnAmount1: UIButton!
    @IBOutlet weak var btnAmount2: UIButton!
    @IBOutlet weak var btnAmount3: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(PaymentHeaderView.identfier)
        }
    }
    @IBOutlet weak var btnPay: SKButton!
    @IBOutlet weak var viewForLoader: UIVisualEffectView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var lblLoadingText: UILabel!
    
    #if HealthCarePrashant
    internal var razorpay: RazorpayCheckout!
    internal var razorpayOrderId: String?
    #endif
    
    private var dataSource: TableDataSource<PaymentHeaderProvider, PaymentCellProvider, PaymentCellModel>?
    private var items: [PaymentHeaderProvider] = PaymentHeaderProvider.getInitialItems()
    
    lazy var walletAnimation: AnimationView = {
        let anView = AnimationView()
        anView.animationSpeed = 2.0
        anView.backgroundColor = UIColor.clear
        anView.animation = Animation.named(LottieFiles.Wallet.getFileName(), bundle: .main, subdirectory: nil, animationCache: nil)
        anView.loopMode = .loop
        anView.contentMode = .scaleAspectFill
        return anView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        #if HealthCarePrashant
        btnPay.isHidden = false
        razorpay = RazorpayCheckout.initWithKey(/UserPreference.shared.clientDetail?.gateway_key, andDelegate: self)
        #elseif HomeDoctorKhalid || Heal || AirDoc || CloudDoc
        btnPay.isHidden = false
        #else
        tableViewInit()
        getCardsAPI()
        btnPay.isHidden = true
        #endif
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
            dismissVC()
        case 1: //Proceed to payment
            break
        case 2: //Amount 1
            tfAmount.text = "\(AddMoneyAmounts.Amount1.rawValue)"
            updatePriceInsideCell(price: /tfAmount.text)
        case 3: //Amount 2
            tfAmount.text = "\(AddMoneyAmounts.Amount2.rawValue)"
            updatePriceInsideCell(price: /tfAmount.text)
        case 4: //Amount 3
            tfAmount.text = "\(AddMoneyAmounts.Amount3.rawValue)"
            updatePriceInsideCell(price: /tfAmount.text)
        case 5: //Pay
            if /tfAmount.text == "" {
                btnPay.vibrate()
                return
            }
            tfAmount.resignFirstResponder()
            #if HealthCarePrashant
            btnPay.playAnimation()
            addMoneyViaRazorPay()
            #elseif HomeDoctorKhalid || AirDoc || CloudDoc
            btnPay.playAnimation()
            addMoneyViaWebsiteTypeSDK()
            #elseif Heal
            showCardOptions()
            #endif
        default:
            break
        }
    }
    
    @IBAction func tfTxtChangeAction(_ sender: UITextField) {
        updatePriceInsideCell(price: /sender.text)
    }
}

//MARK:- VCFuncs
extension AddMoneyVC {
    
    private func updatePriceInsideCell(price: String) {
        if let selectedSectionIndex: Int = items.firstIndex(where: {/$0.headerProperty?.model?.isSelected}) {
            items[selectedSectionIndex].items?.first?.property?.model?.priceToPay = price.trimmingCharacters(in: .whitespacesAndNewlines)
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .Reload(indexPaths: [IndexPath.init(row: 0, section: selectedSectionIndex)], animation: .none))
        }
    }
    
    private func getCardsAPI() {
        EP_Home.cards.request(success: { [weak self] (responseData) in
            let cards = (responseData as? CardsData)?.cards
            self?.items = PaymentHeaderProvider.getCardItems(cards) + (self?.items ?? [])
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
        }) { (error) in
            
        }
    }
    
    private func tableViewInit() {
        
        tableView.contentInset.top = 16.0
        
        dataSource = TableDataSource<PaymentHeaderProvider, PaymentCellProvider, PaymentCellModel>.init(.MultipleSection(items: items), tableView)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? PaymentHeaderView)?.item = item
            (view as? PaymentHeaderView)?.didSelectHeader = { [weak self] (headerModel) in
                self?.handleHeaderTap(headerModel, section: section)
            }
        }
        
        dataSource?.configureCell = { [weak self] (cell, item, indexPath) in
            (cell as? PayWithExistingCardCell)?.item = item
            (cell as? PayWithExistingCardCell)?.cardDeleted = {
                self?.items.remove(at: indexPath.section)
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .DeleteSection(indexSet: IndexSet.init(integer: indexPath.section), animation: .automatic))
            }
            (cell as? PayWithNewCardCell)?.item = item
        }
        
    }
    
    private func handleHeaderTap(_ model: PaymentHeaderModel?, section: Int?) {
        if /model?.isSelected { return }
        
        items.forEach({$0.headerProperty?.model?.isSelected = false})
        items[/section].headerProperty?.model?.isSelected = true
        
        if let sectionIndexOpened: Int = self.items.firstIndex(where: {/$0.items?.count != 0 }) {
            items[sectionIndexOpened].items = []
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .DeleteRowsAt(indexPaths: [IndexPath(row: 0, section: sectionIndexOpened)], animation: .none))
        }
        
        let type = model?.type ?? .CreditCard
        switch type {
        case .CreditCard, .DebitCard:
            items[/section].items = [PaymentCellProvider.init((PayWithNewCardCell.identfier, UITableView.automaticDimension, PaymentCellModel.init(type, /tfAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines))), nil, nil)]
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .FullReload)
        case .GooglePay, .BhimUPI:
            items.forEach({$0.headerProperty?.model?.isSelected = false})
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .FullReload)
        case .WithCard(_):
            items[/section].items = [PaymentCellProvider.init((PayWithExistingCardCell.identfier, UITableView.automaticDimension, PaymentCellModel.init(type, /tfAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines))), nil, nil)]
            dataSource?.updateAndReload(for: .MultipleSection(items: items), .FullReload)
        }
    }
    
    private func localizedTextSetup() {
        tfAmount.becomeFirstResponder()
        viewForLoader.isHidden = true
        lblTitle.text = VCLiteral.ADD_MONEY.localized
        lblInputAmount.text = VCLiteral.INPUT_AMOUNT.localized
        lblCurrency.text = UserPreference.shared.getCurrencyAbbr()
        [btnAmount1, btnAmount2, btnAmount3].forEach {
            $0?.titleLabel?.adjustsFontSizeToFitWidth = true
            $0?.titleLabel?.numberOfLines = 1
            $0?.titleLabel?.minimumScaleFactor = 0.5
        }
        btnAmount1.setTitle(AddMoneyAmounts.Amount1.formattedText, for: .normal)
        btnAmount2.setTitle(AddMoneyAmounts.Amount2.formattedText, for: .normal)
        btnAmount3.setTitle(AddMoneyAmounts.Amount3.formattedText, for: .normal)
        btnPay.setTitle(VCLiteral.PAY.localized, for: .normal)
        lblLoadingText.text = VCLiteral.COMPLETING_PAYMENT.localized
    }
    
    internal func playWalletAnimation() {
        walletAnimation.removeFromSuperview()
        walletAnimation.backgroundColor = .clear
        walletAnimation.frame = lottieView.bounds
        lottieView.backgroundColor = .clear
        lottieView.addSubview(walletAnimation)
        walletAnimation.play()
        viewForLoader.isHidden = false
    }
    
    internal func stopWalletAnimation() {
        walletAnimation.stop()
        walletAnimation.removeFromSuperview()
        viewForLoader.isHidden = true
    }
}
