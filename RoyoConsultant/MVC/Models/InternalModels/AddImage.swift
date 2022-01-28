//
//  AddImage.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 30/10/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class AddMedia {
    var url: Any?
    var isUploading = false
    var type: MediaTypeUpload = .image
    var doc: Document?
    
    
    init(_ _url: Any?, _ _type: MediaTypeUpload) {
        type = _type
        url = _url
    }
    
    init(_ _url: Any?, _ _type: MediaTypeUpload, _ _doc: Document?) {
        type = _type
        url = _url
        doc = _doc
    }
}

class MediaObj: Codable {
    var image: String?
    var type: MediaTypeUpload?
    
    init(_ _media: String?, _ _type: MediaTypeUpload?) {
        image = _media
        type = _type
    }
    
    class func getArrayToUp(items: [AddMedia]?) -> [MediaObj] {
        var uploadItems = [MediaObj]()
        items?.forEach({ (media) in
            if let url = media.url as? String {
                uploadItems.append(MediaObj.init(url, media.type))
            }
        })
        return uploadItems
    }
}


class InsuranceInfo: Codable {
    var image: String?
    var type: MediaTypeUpload?
    var insuranceNumber: String?
    var expiry: String?
    
    
    init(_ _url: String?, _ _type: MediaTypeUpload, _ _number: String?, _ _expiry: String) {
        image = _url
        type = _type
        insuranceNumber = _number
        expiry = _expiry
    }
}

class GenderOption: SKGenericPickerModelProtocol {
    
    typealias ModelType = FilterOption

    var title: String?
    
    var model: FilterOption?
    
    required init(_ _title: String?, _ _model: FilterOption?) {
        title = _title
        model = _model
    }
}
