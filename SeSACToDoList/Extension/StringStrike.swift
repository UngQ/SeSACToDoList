//
//  StringStrike.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/18/24.
//

import UIKit

extension String {

	func strikeThrough() -> NSAttributedString {
		let attributeString = NSMutableAttributedString(string: self)
		attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
		return attributeString
	}

	func removeStrikeThrough() -> NSAttributedString {
		let attributeString = NSMutableAttributedString(string: self)
		attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
		return attributeString
	}
}
