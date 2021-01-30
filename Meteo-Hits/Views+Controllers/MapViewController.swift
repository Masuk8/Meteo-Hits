//
//  MapViewController.swift
//  Meteo-Hits
//
//  Created by Macbook on 25.01.2021.
//
import Foundation
import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {

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
    navigationController?.isNavigationBarHidden = false
    navigationController?.navigationBar.barStyle = .default

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    nameLbl.text = "Meteorite name: \(MapViewController.recievedName)"
    yearLbl.text = "Impact year: \(MapViewController.recievedYear)"
    massLbl.text = "Mass: \(MapViewController.recievedMass) grams"
    placeCustomPin()
  }

  private func placeCustomPin() {
    let location = MapViewController.recievedLocation
    let name = MapViewController.recievedName
    let year = MapViewController.recievedYear
    let coordinates = CLLocationCoordinate2DMake(location[1], location[0])
    let pin = MeteoritePin(title: "\(name)", subtitle: "\(year)", coordinate: coordinates)

    self.mapView.addAnnotation(pin)
    centerMapOnLocation(location: location)
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation { return nil }
    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
    let pinImage = UIImage(named: "MeteoIcon")?.resized(toWidth: 50)
    annotationView.image = pinImage
    annotationView.canShowCallout = true
    return annotationView
  }

  private func centerMapOnLocation(location: [Double]) {
    let centerCoordinate = CLLocationCoordinate2DMake(location[1], location[0])
    mapView.centerCoordinate = centerCoordinate
  }
}
