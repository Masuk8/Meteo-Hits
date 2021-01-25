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
    
    //let token = "nsRQBDzubw8nr0VjqtPbed0Ku9OP42GdBBTU7bGP"
    guard let url = URL(string: "https://data.nasa.gov/resource/y77d-th95.json") else {
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
        print(decodedJSONData[0])
        for i in decodedJSONData {
          //print(i.mass)
          //print(i.year)
          //print(i)
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
}
