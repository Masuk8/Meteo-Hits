//
//  Date+Extension.swift
//  Meteo-Hits
//
//  Created by Macbook on 29.01.2021.
//

import Foundation

extension String {
  var date: Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .init(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    guard let date = dateFormatter.date(from: self) else { return nil }
    return date
  }
}

extension Date {
  func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
    return calendar.dateComponents(Set(components), from: self)
  }

  func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
    return calendar.component(component, from: self)
  }
}
