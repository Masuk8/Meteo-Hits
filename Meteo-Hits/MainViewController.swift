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
    getJSON()
    
  }
  
  
  
  func getJSON() {
    
    let token = "M1oRBVUlnNWYmVr8z2R7xGu7V"
    guard let url = URL(string: "https://data.nasa.gov/resource/y77d-th95.json?$$app_token=\(token)") else {
      return
    }
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
        let decodedJSONData = try decoder.decode([Meteorite].self, from: data)
        //var meteoritesAfter2011 = [Any]()
        
        //print(decodedJSONData[0].year)
        if let unwrappedYear = decodedJSONData[0].year {
          print(unwrappedYear)
          
          let yearToCompare = calendarDate(date: self.stringToDate(string: "2007-01-01T00:00:00.000"))
          let meteoriteYear = calendarDate(date: self.stringToDate(string: unwrappedYear))
          
          print(yearToCompare)
          print("mezera")
          print(meteoriteYear)
          
          
          
        }
        for meteorite in decodedJSONData {
          
          if let unwrappedYear = meteorite.year {
            
            
          }
        }
        
        
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
  
  
  func stringToDate(string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .init(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    guard let date = dateFormatter.date(from: string) else { fatalError() }
    return date
  }
}

func calendarDate (date: Date) -> Int {
  let calendar = Calendar.current
  let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
  guard let finalYear = components.year else { fatalError() }
  return finalYear
}


