//
//  SKGenericPicker.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import IQKeyboardManagerSwift
import UIKit

protocol SKGenericPickerModelProtocol {
    
    associatedtype ModelType
    
    var title: String? { get set }
    var model: ModelType? { get set }
    
    init(_ _title: String?, _ _model: ModelType?)
}

class SKGenericPicker<T: SKGenericPickerModelProtocol>: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    typealias DidSelectItem = (_ item: T?) -> ()

    public var configureItem: DidSelectItem?
    private var items: [T]?
    private var selectedItem: T?
    
    init(frame: CGRect, items: [T]?, configureItem: @escaping DidSelectItem) {
        super.init(frame: frame)
        self.configureItem = configureItem
        self.items = items
        super.dataSource = self
        super.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func tappedDone() {
        if let selectedOne = selectedItem {
            configureItem?(selectedOne)
        } else {
            configureItem?(items?.first)
        }
    }
    
    public func updateItems(_ _items: [T]?) {
        items = _items
        reloadAllComponents()
    }
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        (self.inputAccessoryView as? IQToolbar)?.doneBarButton.invocation = IQInvocation.init(self, #selector(tappedDone))
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return /items?.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items?[row].title
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let item = configureItem {
            selectedItem = items?[row]
            item(selectedItem)
        }
    }
}



