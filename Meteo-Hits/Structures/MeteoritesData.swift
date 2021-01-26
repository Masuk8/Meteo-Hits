//
//  Meteorite.swift
//  Meteo-Hits
//
//  Created by Macbook on 25.01.2021.
//

import Foundation

struct Meteorite: Codable {
  let name: String
  let mass: String?
  let year: String?
  let geolocation: Geolocation?
}

struct Geolocation: Codable {
  let type: String
  let coordinates: [Double]
}


