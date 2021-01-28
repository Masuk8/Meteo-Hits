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
    placePin()
    
  }
  func placePin() {
    let lat = location[1]
    let lon = location[0]
    let annotation = MKPointAnnotation()
    let centerCoordinate = CLLocationCoordinate2DMake(lat, lon)
    annotation.coordinate = centerCoordinate
    mapView.addAnnotation(annotation)
    centerMapOnLocation()
  }
  
  func centerMapOnLocation() {
    let lat = location[1]
    let lon = location[0]
    let coordinate = CLLocationCoordinate2DMake(lat, lon)
    mapView.centerCoordinate = coordinate
    }
}

