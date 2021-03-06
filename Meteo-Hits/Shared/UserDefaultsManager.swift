//
//  UserDefaultsManager.swift
//  Meteo-Hits
//
//  Created by Macbook on 26.01.2021.
//

import Foundation

class UserDefaultsManager {

  static let shared = UserDefaultsManager()

  func saveMeteorites (array: [MeteoritesData]) {
    UserDefaults.standard.set(try? PropertyListEncoder().encode(array), forKey: "meteoKey")
  }

  func loadMeteorites() -> [MeteoritesData] {
    guard let data = UserDefaults.standard.value(forKey: "meteoKey") as? Data else {return []}
    let meteorites = try? PropertyListDecoder().decode(Array<MeteoritesData>.self, from: data)
    guard let unwrappedMeteorites = meteorites else { return [] }
    return unwrappedMeteorites
  }

  func saveDateCheck (dateCheck: Date) {
    UserDefaults.standard.set(dateCheck, forKey: "keyCheck")
  }

  func loadDateCheck () -> Date? {
    let userDefs = UserDefaults.standard
    guard let dateCheck = userDefs.value(forKey: "keyCheck") as? Date else {
      return Date(timeIntervalSince1970: 0)
    }
    return dateCheck
  }
}
