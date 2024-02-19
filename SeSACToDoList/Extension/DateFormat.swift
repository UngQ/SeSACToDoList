//
//  DateFormat.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import Foundation

extension String {
	func toDate() -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
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
		dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
		return dateFormatter.string(from: self)
	}

	func pickupDayString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd"
		return dateFormatter.string(from: self)
	}
}
