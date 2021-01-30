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

  @IBOutlet weak var nameAndMassBackground: UIView!
  @IBOutlet weak var tableView: UITableView!

  private let refreshControl = UIRefreshControl()
  private var yearSections: [[Int]] = []

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.barStyle = .black
    checkIfUpdateIsNeeded()
    tableViewStartUpSettings()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    checkIfUpdateIsNeeded()
    nameAndMassBackground.layer.cornerRadius = 5
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
  }

  private func tableViewStartUpSettings () {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.layer.cornerRadius = 5
    tableView.layer.masksToBounds = true
    tableView.allowsSelection = true
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshMeteoritesData(_:)), for: .valueChanged)
  }

  @objc private func refreshMeteoritesData(_ sender: Any) {
    createArrayOfMeteoritesAfter2011 {
      DispatchQueue.main.async { [weak self] in
        self?.refreshControl.endRefreshing()
        self?.tableView.reloadData()
      }
    }
  }

  private func checkIfUpdateIsNeeded () {
    guard let timeCheck = UserDefaultsManager.shared.loadDateCheck() else {return}
    if timeCheck == Date(timeIntervalSince1970: 0) ||
        Calendar.current.isDateInToday(timeCheck) == false {
      print("timeCheck is: timeIntervalSince1970: 0")
      refreshControl.layoutIfNeeded()
      refreshControl.beginRefreshingManually()
      createArrayOfMeteoritesAfter2011 {
        DispatchQueue.main.async {[weak self] in
          self?.tableView.reloadData()
        }
      }
    }
  }

  private func createArrayOfMeteoritesAfter2011(completion: @escaping () -> Void) {
    getJsonFromWeb {[weak self] (meteoritesData) in

      guard let yearToCompare = "2011-01-01T00:00:00.000".date else { return }

      let filteredMeteorites = meteoritesData.filter { meteorite -> Bool in
        guard let date = meteorite.date else { return false }
        let isAfter2011 = date > yearToCompare
        return isAfter2011
      }

      guard let sortedMeteorites = self?.sortMeteorites(meteoritesData: filteredMeteorites) else { return }


      UserDefaultsManager.shared.saveMeteorites(array: sortedMeteorites)
      UserDefaultsManager.shared.saveDateCheck(dateCheck: Date())

      completion()
    }
  }

  private func sortMeteorites(meteoritesData: [MeteoritesData]) -> [MeteoritesData] {
    return meteoritesData.sorted().reversed()
  }

  private func calendarDate (date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
    guard let finalYear = components.year else { fatalError() }
    return finalYear
  }

  private func getJsonFromWeb(completion: @escaping ([MeteoritesData]) -> Void) {
    let token = "M1oRBVUlnNWYmVr8z2R7xGu7V"
    if let url = URL(string: "https://data.nasa.gov/resource/y77d-th95.json?$$app_token=\(token)&$where=date_extract_y(year)%3e=2010") {
      print(url)
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
  }


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var index = 0
    let data = UserDefaultsManager.shared.loadMeteorites()
    index = data.count

    return index
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MeteoCell",
            for: indexPath) as? MeteoTableViewCell else {
      return UITableViewCell()
    }

    let data = UserDefaultsManager.shared.loadMeteorites()
    cell.tableViewCellName.sizeToFit()
    cell.tableViewCellName.text = data[indexPath.row].name
    cell.tableViewCellMass.sizeToFit()
    cell.tableViewCellMass.text = data[indexPath.row].mass

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let data = UserDefaultsManager.shared.loadMeteorites()
    guard let location = data[indexPath.row].geolocation?.coordinates else { return }
    guard let theYear = data[indexPath.row].year else { return }
    MapViewController.recievedLocation = location
    MapViewController.recievedName = data[indexPath.row].name
    MapViewController.recievedYear = Int(theYear.date?.get(.year) ?? 0)
    MapViewController.recievedMass = data[indexPath.row].mass ?? ""
    performSegue(withIdentifier: "mapSegue", sender: nil)
  }



  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }
}

extension UIRefreshControl {
  func beginRefreshingManually() {
    if let scrollView = superview as? UIScrollView {
      scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
    }
    beginRefreshing()
  }
}

