//
//  MeteoriteAnnotation.swift
//  Meteo-Hits
//
//  Created by Macbook on 30.01.2021.
//

import Foundation
import MapKit

class MeteoritePin: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  let title: String?
  let subtitle: String?
  var image: UIImage?

  init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {

    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
    self.image = UIImage()
    super.init()
  }
}
