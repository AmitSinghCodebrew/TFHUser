//
//  MKMapItem.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 10/02/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import Foundation
import MapKit

extension MKMapItem {
  convenience init(coordinate: CLLocationCoordinate2D, name: String) {
    self.init(placemark: .init(coordinate: coordinate))
    self.name = name
  }
}
