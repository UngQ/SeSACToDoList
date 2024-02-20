//
//  TodoTable.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/15/24.
//

import UIKit
import RealmSwift

class Category: Object {
	@Persisted(primaryKey: true) var id: ObjectId
	@Persisted var regDate: Date
	@Persisted var name: String
	@Persisted var tintColor: String
	@Persisted var symbol: String
	@Persisted var todo: List<Todo>

	convenience init(name: String, tintColor: String, symbol: String) {
		self.init()
		self.name = name
		self.regDate = Date()
		self.tintColor = tintColor
		self.symbol = symbol
	}

}

class Todo: Object {

	@Persisted(primaryKey: true) var id: ObjectId
	@Persisted var regDate: Date
	@Persisted var title: String
	@Persisted var memo: String?
	@Persisted var endDate: Date?
	@Persisted var tag: String?
	@Persisted var priority: Int
	@Persisted var doOrNot: Bool
	@Persisted(originProperty: "todo") var main: LinkingObjects<Category>

	convenience init(title: String, memo: String? = nil, endDate: Date? = nil, tag: String? = nil, priority: Int = 0) {
		self.init()
		self.regDate = Date()
		self.title = title
		self.memo = memo
		self.endDate = endDate
		self.tag = tag
		self.priority = priority
		self.doOrNot = false
	}

}
