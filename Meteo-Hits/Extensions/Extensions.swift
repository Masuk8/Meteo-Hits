//
//  Extensions.swift
//  Meteo-Hits
//
//  Created by Macbook on 30.01.2021.
//
import UIKit
import Foundation

extension UIView {
  class func viewFromNibName(_ name: String) -> UIView? {
    let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
    return views?.first as? UIView
  }
}

