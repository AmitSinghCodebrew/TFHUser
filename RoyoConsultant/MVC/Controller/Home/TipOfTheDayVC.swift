//
//  TipOfTheDayVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TipOfTheDayVC: BaseVC {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(TipHeaderView.identfier)
        }
    }
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet var accessoryView: UIVisualEffectView!
    @IBOutlet weak var tfComment: UITextField!
    
    private var dataSource: TableDataSource<TipSectionPro, TipCellPro, Any>?
    public var tip: Tip?
    private var items = [TipSectionPro]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        tableViewInit()
        getCommentsAPI()
    }
    
    
    override var inputAccessoryView: UIView? {
        return accessoryView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Fav UnFav
            btnFav.isUserInteractionEnabled = false
            tip?.is_favorite = !(/tip?.is_favorite)
            UIView.transition(with: btnFav, duration: 0.25, options: [.transitionFlipFromRight], animations: {
                
            }) { (_) in
                self.btnFav.tintColor = /self.tip?.is_favorite ? ColorAsset.requestStatusFailed.color : UIColor.white
            }
            EP_Home.addFav(feedId: tip?.id, favorite: /tip?.is_favorite ? .TRUE : .FALSE).request(success: { [weak self] (response) in
                self?.btnFav.isUserInteractionEnabled = true
            }) { [weak self] (_) in
                self?.btnFav.isUserInteractionEnabled = true
            }
        case 2: //Like Unlike
            if !(/(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true)) {
                return
            }
            
            btnLike.isUserInteractionEnabled = false
//            tip?.is_like = !(/tip?.is_like)
            tip?.is_like = true
            UIView.transition(with: btnLike, duration: 0.25, options: [.transitionFlipFromRight], animations: {
                
            }) { (_) in
                self.btnLike.setImage(/self.tip?.is_like ? #imageLiteral(resourceName: "ic_like") : #imageLiteral(resourceName: "ic_like_unfilled"), for: .normal)
            }
            EP_Home.addLike(id: tip?.id).request { [weak self] (response) in
                self?.btnLike.isUserInteractionEnabled = true
            } error: { [weak self] (error) in
                self?.btnLike.isUserInteractionEnabled = true
            }
        case 3: //Comment
            break
        case 4: //Share
            break
        case 5: //Add Comment Accessory
            if /tfComment.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return
            }
            tfComment.resignFirstResponder()
            EP_Home.addComment(id: tip?.id, comment: tfComment.text?.trimmingCharacters(in: .whitespacesAndNewlines)).request { [weak self] (responseData) in
                let comment = responseData as! Comment
                self?.tfComment.text = nil
                if let section = TipSectionPro.getComments(comments: [comment]) {
                    if /self?.items.count == 2 {
                        self?.items.last?.items?.insert(TipCellPro.init((TipCommentCell.identfier, UITableView.automaticDimension, TipOrComment.init(comment)), nil, nil), at: 0)
                    } else {
                        self?.items.append(section)
                    }
                    self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
                }
            } error: { (error) in
                
            }
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension TipOfTheDayVC {
    private func initialSetup() {
        let cornerRadius: CGFloat = 24.0
        tableView.contentInset.top = (UIScreen.main.bounds.width * 0.65) - (44 + UIApplication.statusBarHeight + cornerRadius)
        tableView.contentInset.bottom = 48.0
        headerView.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: cornerRadius)
        imgView.setImageNuke(tip?.image)
        btnFav.tintColor = /tip?.is_favorite ? ColorAsset.requestStatusFailed.color : UIColor.white
        btnLike.setImage(/tip?.is_like ? #imageLiteral(resourceName: "ic_like") : #imageLiteral(resourceName: "ic_like_unfilled"), for: .normal)
    }
    
    private func tableViewInit() {
        items = TipSectionPro.getItems(tip: tip)
        dataSource = TableDataSource<TipSectionPro, TipCellPro, Any>.init(.MultipleSection(items: items), tableView, false)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? TipHeaderView)?.item = item
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? TipDetailCell)?.item = item
            (cell as? TipCommentCell)?.item = item
        }
    }
    
    private func getCommentsAPI() {
        EP_Home.getComments(id: tip?.id).request { [weak self] (responseData) in
            let data = responseData as? CommentData
            if let commentSection = TipSectionPro.getComments(comments: data?.comments) {
                self?.items.append(commentSection)
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
            }
        } error: { (error) in
            
        }
    }
}
