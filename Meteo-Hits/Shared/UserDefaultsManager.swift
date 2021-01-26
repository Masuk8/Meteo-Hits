//
//  UserDefaultsManager.swift
//  Meteo-Hits
//
//  Created by Macbook on 26.01.2021.
//

import Foundation

class UserDefaultsManager {
  
  static let shared = UserDefaultsManager()
  
  func saveJson (array: [Meteorite]) {
    UserDefaults.standard.set(array, forKey: "yourkey")
  }
  
 /* func loadJson () -> [Meteorite] {
    
    return [1]
  }*/
}
  

