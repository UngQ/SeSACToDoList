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

	func createItem(_ item: TodoTable) {

		do {
			try realm.write {
				realm.add(item)
			}
		} catch {
			print(error)
		}

	}


	func updateItem(id: ObjectId, title: String, memo: String?, endDate: Date?, tag: String?, priority: Int) {
		do {
			try realm.write {
				realm.create(TodoTable.self,
							 value: ["id": id,
								"title": title,
									 "memo": memo,
									 "endDate": endDate,
									 "tag": tag,
									 "priority": priority],
							 update: .modified)
			}
		} catch {
			print(error)
		}
	}

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

	func sortEndDate(list: Results<TodoTable>!) -> Results<TodoTable> {
		list.sorted(byKeyPath: "endDate", ascending: true)
	}

	func sortTitle(list: Results<TodoTable>!) -> Results<TodoTable> {
		list.sorted(byKeyPath: "title", ascending: true)
	}

	func sortPriorityLower(list: Results<TodoTable>!) -> Results<TodoTable> {
		list.where {
			$0.priority == PriorityType.lower.rawValue
		}
	}

	func deleteItem(_ item: TodoTable) {
		do {
			try realm.write {
				realm.delete(item)
			}
		} catch {
			print(error)
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
