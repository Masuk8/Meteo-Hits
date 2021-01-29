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

  @IBOutlet weak var meteoriteImageView: UIView!
  @IBOutlet weak var tableView: UITableView!

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.barTintColor = .black
    checkWithDate()
    tableViewStartUpSettings()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.barStyle = .black
  }

  func tableViewStartUpSettings () {

    tableView.delegate = self
    tableView.dataSource = self
    tableView.layer.cornerRadius = 5
    tableView.layer.masksToBounds = true
    tableView.allowsSelection = true
  }

  func checkWithDate () {

    if let timeCheck = UserDefaultsManager.shared.loadDateCheck() {
      if timeCheck == Date(timeIntervalSince1970: 0) || Calendar.current.isDateInToday(timeCheck) == false {
        print("timeCheck is: timeIntervalSince1970: 0")
        meteoriteImageView.isHidden = false
        createArrayOfMeteoritesAfter2011()
      }
    }
  }

  func createArrayOfMeteoritesAfter2011 () {

    var finalArray = [MeteoritesData]()

    getJsonFromWeb { (meteoritesData) in

      let yearToCompare = self.calendarDate(date: self.stringToDate(string: "2011-01-01T00:00:00.000"))

      for meteorite in meteoritesData {

        if let unwrappedYear = meteorite.year {
          let meteoriteYear = self.calendarDate(date: self.stringToDate(string: unwrappedYear))

          if meteoriteYear >= yearToCompare {
            finalArray.append(meteorite)
          }
        }
      }
      UserDefaultsManager.shared.saveMeteorites(array: finalArray)
      UserDefaultsManager.shared.saveDateCheck(dateCheck: Date())
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
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

  func getJsonFromWeb(completion: @escaping ([MeteoritesData]) -> Void) {

    let token = "M1oRBVUlnNWYmVr8z2R7xGu7V"
    if let url = URL(string: "https://data.nasa.gov/resource/y77d-th95.json?$$app_token=\(token)") {

      let request = URLRequest(url: url)
      URLSession.shared.dataTask(with: request) { (data, _, error) in
        if let error = error {
          print(error.localizedDescription)
          return
        }
        guard let data = data else {
          return
        }
        do {
          print("Fetching JSON.")
          let decoder = JSONDecoder()
          let decodedJsonData = try decoder.decode([MeteoritesData].self, from: data)
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

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let yourVC = segue.destination as? MapViewController {
      yourVC.location = (sender as? [Double] ?? [0, 0])
    }
  }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var index = 0
    let data = UserDefaultsManager.shared.loadMeteorites()
    index = data.count

    return index
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MeteoCell", for: indexPath) as! MeteoTableViewCell
    let data = UserDefaultsManager.shared.loadMeteorites()
    cell.tableViewCellName.sizeToFit()
    cell.tableViewCellName.text = data[indexPath.row].name
    cell.tableViewCellMass.sizeToFit()
    cell.tableViewCellMass.text = data[indexPath.row].mass
    meteoriteImageView.isHidden = true
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let data = UserDefaultsManager.shared.loadMeteorites
    let location = data()[indexPath.row].geolocation?.coordinates
    let destinationVC = MapViewController()
    destinationVC.location = location!

    self.performSegue(withIdentifier: "mapSegue", sender: location)

  }

  func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }
}
