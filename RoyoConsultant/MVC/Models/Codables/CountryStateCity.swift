//
//  CountryStateCity.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class CountryStateCityData: Codable {
    private var state: [State]?
    private var city: [City]?
    private var country: [CountryBackend]?
    
    func getStates() -> [PickerStateModel] {
        var array = [PickerStateModel]()
        state?.forEach{ array.append(PickerStateModel.init(/$0.name, $0))}
        return array
    }
    
    func getCities() -> [PickerCityModel] {
        var array = [PickerCityModel]()
        city?.forEach{ array.append(PickerCityModel.init($0.name, $0)) }
        return array
    }
    
    func getCountries() -> [PickerCountryModel] {
        var array = [PickerCountryModel]()
        country?.forEach{ array.append(PickerCountryModel.init($0.name, $0)) }
        return array
    }
}

final class CountryBackend: Codable {
    var id: Int?
    var name: String?
    
    init(_ _id: Int?, _ _name: String?) {
        id = _id
        name = _name
    }
}

final class State: Codable {
    var id: Int?
    var name: String?
    
    init(_ _id: Int?, _ _name: String?) {
        id = _id
        name = _name
    }
}

final class City: Codable {
    var id: Int?
    var name: String?
    
    init(_ _id: Int?, _ _name: String?) {
        id = _id
        name = _name
    }
}

final class PickerCountryModel: SKGenericPickerModelProtocol {
    
    typealias ModelType = CountryBackend

    var title: String?
    
    var model: CountryBackend?
    
    required init(_ _title: String?, _ _model: CountryBackend?) {
        title = _title
        model = _model
    }
}

final class PickerCityModel: SKGenericPickerModelProtocol {
    
    typealias ModelType = City

    var title: String?
    
    var model: City?
    
    required init(_ _title: String?, _ _model: City?) {
        title = _title
        model = _model
    }
}

final class PickerStateModel: SKGenericPickerModelProtocol {
    
    typealias ModelType = State

    var title: String?
    
    var model: State?
    
    required init(_ _title: String?, _ _model: State?) {
        title = _title
        model = _model
    }
}
