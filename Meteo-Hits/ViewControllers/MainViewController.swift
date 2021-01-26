//
//  ViewController.swift
//  Meteo-Hits
//
//  Created by Macbook on 25.01.2021.
//

import Foundation
import UIKit
import CoreLocation

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Meteo-Hits"
    
    createArrayOfMeteoritesAfter2011()
  }
  
  
  func createArrayOfMeteoritesAfter2011 () {
    
    var finalArray = [Meteorite]()
    
    getJsonFromWeb { (meteoritesData) in
      
      let yearToCompare = self.calendarDate(date: self.stringToDate(string: "2011-01-01T00:00:00.000"))
      
      var index = 0
      for meteorite in meteoritesData {
        
        if let unwrappedYear = meteorite.year {
          let meteoriteYear = self.calendarDate(date: self.stringToDate(string: unwrappedYear))

          if meteoriteYear > yearToCompare {
            
            finalArray.append(meteorite)
          }
        }
      }
      print(finalArray)
    }
    
  }
  
  
  func stringToDate(string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .init(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    guard let date = dateFormatter.date(from: string) else { fatalError() }
    return date
  }
  
  func calendarDate (date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
    guard let finalYear = components.year else { fatalError() }
    return finalYear
  }
  
  func getJsonFromWeb(completion: @escaping ([Meteorite]) -> Void) {
    
    let token = "M1oRBVUlnNWYmVr8z2R7xGu7V"
    if let url = URL(string: "https://data.nasa.gov/resource/y77d-th95.json?$$app_token=\(token)") {
      
      let request = URLRequest(url: url)
      URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
          print(error.localizedDescription)
          return
        }
        guard let data = data else {
          return
        }
        do {
          let decoder = JSONDecoder()
          let decodedJsonData = try decoder.decode([Meteorite].self, from: data)
          completion(decodedJsonData)
          
        } catch DecodingError.dataCorrupted(let context) {
          print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
          print("Key '\(key)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
          print("Value '\(value)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
          print("Type '\(type)' mismatch:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch {
          print("error: ", error)
        }
      }.resume()
    }
  }
}






