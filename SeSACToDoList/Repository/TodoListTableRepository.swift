//
//  TodoListDBManager.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//
import Foundation
import RealmSwift

class TodoListTableRepository {

	private let realm = try! Realm()


	func fetchTotal() -> Results<TodoTable> {
		return realm.objects(TodoTable.self)
	}

	func fetchToday() -> Results<TodoTable> {
		let date = Date().toString()
		let result = date.toDate()

		return realm.objects(TodoTable.self).where {
			$0.endDate == result
		}
	}

	func fetchSchedule() -> Results<TodoTable> {
		let date = Date().toString()
		let result = date.toDate()

		return realm.objects(TodoTable.self).where {
			$0.endDate > result
		}
	}

	func fetchImportant() -> Results<TodoTable> {
		return realm.objects(TodoTable.self).where {
			$0.priority == 1
		}
	}

	func fetchCompleted() -> Results<TodoTable> {
		return realm.objects(TodoTable.self).where {
			$0.doOrNot == true
		}
	}

	func sortEndDate() -> Results<TodoTable> {
		realm.objects(TodoTable.self).sorted(byKeyPath: "endDate", ascending: true)
	}

	func sortTitle() -> Results<TodoTable> {
		realm.objects(TodoTable.self).sorted(byKeyPath: "title", ascending: true)
	}

	func sortPriorityLower() -> Results<TodoTable> {
		realm.objects(TodoTable.self).where {
			$0.priority == PriorityType.lower.rawValue
		}
	}

	func updateDoOrNot(_ item: TodoTable) {
		do {
			try realm.write {
				item.doOrNot.toggle()
			}
		} catch {
			print(error)
		}
	}

}
