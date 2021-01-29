//
//  Meteorite.swift
//  Meteo-Hits
//
//  Created by Macbook on 25.01.2021.
//

import Foundation

struct MeteoritesData: Codable {
  let name: String
  let mass: String?
  let year: String?
  let geolocation: Geolocation?
  var date: Date? {
    return year?.date
  }
}

extension MeteoritesData: Comparable {
  static func < (lhs: MeteoritesData, rhs: MeteoritesData) -> Bool {
    guard let lhsMass = Double(lhs.mass ?? "0"), let rhsMass = Double(rhs.mass ?? "0") else { return false }
    return lhsMass < rhsMass
  }

  static func == (lhs: MeteoritesData, rhs: MeteoritesData) -> Bool {
    guard let lhsMass = Double(lhs.mass ?? "0"), let rhsMass = Double(rhs.mass ?? "0") else { return false }
    return lhsMass == rhsMass
  }
}

struct Geolocation: Codable {
  let type: String
  let coordinates: [Double]
}

