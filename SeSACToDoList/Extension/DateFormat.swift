//
//  DateFormat.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import Foundation

extension String {
	func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy. MM. dd."
		dateFormatter.timeZone = TimeZone(identifier: "UTC")
		if let date = dateFormatter.date(from: self) {
			return date
		} else {
			return nil
		}
	}
}

extension Date {
	func toString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy. MM. dd."
		dateFormatter.timeZone = TimeZone(identifier: "UTC")
		return dateFormatter.string(from: self)
	}

	func pickupDayString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd"
		dateFormatter.timeZone = TimeZone(identifier: "UTC")
		return dateFormatter.string(from: self)
	}
}

extension Date {

}
