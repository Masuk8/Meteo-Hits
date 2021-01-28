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

  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      print(location)

    }
 

}
