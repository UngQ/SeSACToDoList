//
//  TodoTable.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/15/24.
//

import Foundation
import RealmSwift

class TodoTable: Object {



	@Persisted(primaryKey: true) var id: ObjectId
	@Persisted var regDate: Date
	@Persisted var title: String
	@Persisted var memo: String
	@Persisted var endDate: Date
	@Persisted var tag: String
	@Persisted var priority: Int

	convenience init(regDate: Date, title: String, memo: String, endDate: Date, tag: String, priority: Int) {
		self.init()
		self.regDate = regDate
		self.title = title
		self.memo = memo
		self.endDate = endDate
		self.tag = tag
		self.priority = priority
	}

}
