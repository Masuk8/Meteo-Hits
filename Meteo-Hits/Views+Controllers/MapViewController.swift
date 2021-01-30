//
//  MapViewController.swift
//  Meteo-Hits
//
//  Created by Macbook on 25.01.2021.
//
import Foundation
import MapKit
import UIKit

class MapViewController: UIViewController {

  static var recievedLocation: [Double] = []
  static var recievedName: String = ""
  static var recievedYear: Int = 0
  static var recievedMass: String = ""

  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var yearLbl: UILabel!
  @IBOutlet weak var massLbl: UILabel!
  @IBOutlet weak var infoView: UIView!
  @IBOutlet weak var mapView: MKMapView!

  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    navigationController?.navigationBar.barStyle = .default
    placeCustomAnnotation()
    //nameLbl.text =
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    nameLbl.text = "Name: \(MapViewController.recievedName)"
    yearLbl.text = "Impact year: \(MapViewController.recievedYear)"
    massLbl.text = "Mass: \(MapViewController.recievedMass)grams"
    placePin()
  }

  func placeCustomAnnotation () {
    

  }

  private func placePin() {
    let annotation = MKPointAnnotation()
    let location = MapViewController.recievedLocation
    let centerCoordinate = CLLocationCoordinate2DMake(location[1], location[0])
    annotation.coordinate = centerCoordinate
    mapView.addAnnotation(annotation)
    centerMapOnLocation(location: location)
  }

  private func centerMapOnLocation(location: [Double]) {
    let centerCoordinate = CLLocationCoordinate2DMake(location[1], location[0])
    mapView.centerCoordinate = centerCoordinate
  }
}
