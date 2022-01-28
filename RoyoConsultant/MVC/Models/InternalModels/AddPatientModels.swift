//
//  AddPatientModels.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 27/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

class FamilyMemberType {
    var title: VCLiteral?
    var isSelected: Bool? = false
    
    init(_ _title: VCLiteral) {
        title = _title
    }
    
    class func getArray(type: PatientType) -> [FamilyMemberType] {
        switch type {
        case .Elder:
            return [FamilyMemberType(.FATHER),
                    FamilyMemberType(.MOTHER),
                    FamilyMemberType(.GRAND_FATHER),
                    FamilyMemberType(.GRAND_MOTHER),
                    FamilyMemberType(.OTHER)]
        case .Children:
            return [FamilyMemberType(.SON),
                    FamilyMemberType(.DAUGHTER),
                    FamilyMemberType(.OTHER)]
        case .None:
            return []
        }
       
    }
}


class Disease {
    var title: VCLiteral?
    var isSelected: Bool? = false
    
    init(_ _title: VCLiteral) {
        title = _title
    }
    
    class func getArray() -> [Disease] {
        
        return [Disease(.CHRONIC_DISEASE_0),
                Disease(.CHRONIC_DISEASE_1),
                Disease(.CHRONIC_DISEASE_2),
                Disease(.CHRONIC_DISEASE_4)]
        
    }
}
