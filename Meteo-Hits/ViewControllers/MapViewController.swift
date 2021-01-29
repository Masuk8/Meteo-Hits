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

  var location: [Double] = []

  @IBOutlet weak var mapView: MKMapView!

  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.barTintColor = .black
    placePin()
  }

  func placePin() {
    let annotation = MKPointAnnotation()
    let centerCoordinate = CLLocationCoordinate2DMake(location[1], location[0])
    annotation.coordinate = centerCoordinate
    mapView.addAnnotation(annotation)
    centerMapOnLocation()
  }

  func centerMapOnLocation() {
    let centerCoordinate = CLLocationCoordinate2DMake(location[1], location[0])
    mapView.centerCoordinate = centerCoordinate
  }
}
