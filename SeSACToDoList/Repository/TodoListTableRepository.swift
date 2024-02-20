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

	func createCategory(_ item: Category) {

		do {
			try realm.write {
				realm.add(item)
			}
		} catch {
			print("createCategory Error")
		}
	}

	func createItemInCategory(category: Category, todo: Todo) {
		do {
			try realm.write {
				category.todo.append(todo)
			}
		} catch {
			print(error)
		}
	}

	func fetchCategory() -> Results<Category> {
		return realm.objects(Category.self)
	}

	func createItem(_ item: Todo) {

		do {
			try realm.write {
				realm.add(item)
			}
		} catch {
			print(error)
		}

	}


	func updateItem(id: ObjectId, title: String, memo: String? = nil, endDate: Date? = nil, tag: String? = nil, priority: Int) {
		do {
			try realm.write {
				realm.create(Todo.self,
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

	func fetchTotal() -> Results<Todo> {
		return realm.objects(Todo.self)
	}

	func fetchTodo(categoryId: LinkingObjects<Category>) -> Results<Todo> {
		return realm.objects(Todo.self).where {
			$0.main == categoryId
		}
	}

	func fetchToday() -> Results<Todo> {
		let start = Calendar.current.startOfDay(for: Date())
		let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
		let predicate = NSPredicate(format: "endDate >= %@ && endDate < %@", start as NSDate, end as NSDate)

		return realm.objects(Todo.self).filter(predicate)
	}

	func fetchSchedule() -> Results<Todo> {
		
		let predicate = NSPredicate(format: "endDate > %@", Date() as NSDate)
		return realm.objects(Todo.self).filter(predicate)
	}

	func fetchImportant() -> Results<Todo> {
		return realm.objects(Todo.self).where {
			$0.priority == 1
		}
	}

	func fetchCompleted() -> Results<Todo> {
		return realm.objects(Todo.self).where {
			$0.doOrNot == true
		}
	}

	func sortEndDate(list: Results<Todo>!) -> Results<Todo> {
		list.sorted(byKeyPath: "endDate", ascending: true)
	}

	func sortTitle(list: Results<Todo>!) -> Results<Todo> {
		list.sorted(byKeyPath: "title", ascending: true)
	}

	func sortPriorityLower(list: Results<Todo>!) -> Results<Todo> {
		list.where {
			$0.priority == PriorityType.lower.rawValue
		}
	}

	func deleteItem(_ item: Todo) {
		do {
			try realm.write {
				realm.delete(item)
			}
		} catch {
			print(error)
		}
	}


	func updateDoOrNot(_ item: Todo) {
		do {
			try realm.write {
				item.doOrNot.toggle()
			}
		} catch {
			print(error)
		}
	}

}
