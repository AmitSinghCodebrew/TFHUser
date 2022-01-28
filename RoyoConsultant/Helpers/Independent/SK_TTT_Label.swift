//
//  SK_TTT_Label.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 30/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import TTTAttributedLabel

fileprivate class SKTTT_ATTR {
    var originalText: String?
    var attr: [NSAttributedString.Key : Any]
    var btnAttr: [NSAttributedString.Key : Any]
    var readMoreText: String?
    var readLessText: String?
    var characterCount: Int?
    
    init(_ text: String?, _attr: [NSAttributedString.Key : Any], _btnAttr: [NSAttributedString.Key : Any]) {
        originalText = text
        attr = _attr
        btnAttr = _btnAttr
    }
}

class SK_TTT_Label: TTTAttributedLabel, TTTAttributedLabelDelegate {
    

    var didTapReadMoreOrLess: (() -> Void)?
    fileprivate var attr: SKTTT_ATTR?
    
    func showText(str: String, readMoreText: String, readLessText: String, charatersBeforeReadMore: Int, isReadMoreTapped: Bool, attr: [NSAttributedString.Key : Any], btnAttr: [NSAttributedString.Key : Any]) {
        
        delegate = self
        self.attr = SKTTT_ATTR.init(str, _attr: attr, _btnAttr: btnAttr)
        self.attr?.readMoreText = readMoreText
        self.attr?.readLessText = readLessText
        self.attr?.characterCount = charatersBeforeReadMore

        let text = str + readLessText
        let attributedFullText = NSMutableAttributedString.init(string: text, attributes: attr)
        let rangeLess = NSString(string: text).range(of: readLessText, options: String.CompareOptions.caseInsensitive)
        //Swift 5
        // attributedFullText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: rangeLess)
        attributedFullText.addAttributes(attr, range: rangeLess)
        
        var subStringWithReadMore = ""
        if text.count > charatersBeforeReadMore {
//            let start = String.Index(encodedOffset: 0)
//            let end = String.Index(encodedOffset: charatersBeforeReadMore)
            let start = String.Index.init(utf16Offset: 0, in: text)
            let end = String.Index.init(utf16Offset: charatersBeforeReadMore, in: text)

            subStringWithReadMore = String(text[start..<end]) + readMoreText
        }
        let attributedLessText = NSMutableAttributedString.init(string: subStringWithReadMore, attributes: attr)
//        let attributedLessText = NSMutableAttributedString.init(string: subStringWithReadMore)
        let nsRange = NSString(string: subStringWithReadMore).range(of: readMoreText, options: String.CompareOptions.caseInsensitive)
        //Swift 5
        // attributedLessText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: nsRange)
        attributedLessText.addAttributes(btnAttr, range: nsRange)

        self.linkAttributes = btnAttr
        self.addLink(toTransitInformation: [VCLiteral.READ_MORE.localized:"1"], with: nsRange)

        if isReadMoreTapped {
            self.numberOfLines = 0
            self.attributedText = attributedFullText
            self.addLink(toTransitInformation: [VCLiteral.READ_LESS.localized: "1"], with: rangeLess)
        }
        if isReadMoreTapped == false {
            self.numberOfLines = 3
            self.attributedText = attributedLessText
        }
    }
    
    internal func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithTransitInformation components: [AnyHashable : Any]!) {
        if let _ = components as? [String: String] {
            if let value = components[VCLiteral.READ_MORE.localized] as? String, value == "1" {
                showText(str: /attr?.originalText, readMoreText: /attr?.readMoreText, readLessText: /attr?.readLessText, charatersBeforeReadMore: /attr?.characterCount, isReadMoreTapped: true, attr: attr?.attr ?? [:], btnAttr: attr?.btnAttr ?? [:])
                didTapReadMoreOrLess?()
            }
            if let value = components[VCLiteral.READ_LESS.localized] as? String, value == "1" {
                showText(str: /attr?.originalText, readMoreText: /attr?.readMoreText, readLessText: /attr?.readLessText, charatersBeforeReadMore: /attr?.characterCount, isReadMoreTapped: false, attr: attr?.attr ?? [:], btnAttr: attr?.btnAttr ?? [:])
                didTapReadMoreOrLess?()
            }
        }
    }
}


extension UILabel {
    func setAtrributedText(original: (text: String, font: UIFont, color: UIColor), toReplace: (text: String, font: UIFont, color: UIColor)) {
        
        let originalAttributes = [NSAttributedString.Key.foregroundColor : original.color,
                                  NSAttributedString.Key.font: original.font]
        
        let replacableAttributes = [NSAttributedString.Key.foregroundColor : toReplace.color,
                                    NSAttributedString.Key.font: toReplace.font]
        
        let mutableAttributedString = NSMutableAttributedString.init(string: original.text, attributes: originalAttributes)
        let toReplaceText = NSMutableAttributedString.init(string: toReplace.text, attributes: replacableAttributes)
        
        if let rangeToReplace = original.text.range(of: toReplace.text) {
            mutableAttributedString.replaceCharacters(in: NSRange.init(rangeToReplace, in: original.text), with: toReplaceText)
        }
        
        attributedText = mutableAttributedString
    }
}

