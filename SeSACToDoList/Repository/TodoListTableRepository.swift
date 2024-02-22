//
//  TodoListDBManager.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//
import Foundation
import RealmSwift

enum SortType {
	case endDate
	case title
	case priorityLower
}

class TodoListTableRepository {

	private let realm = try! Realm()

	//신규 생성
	func createItem<T: Object>(_ item: T) {

		do {
			try realm.write {
				realm.add(item)
			}
		} catch {
			print("create Error")
		}
	}

	//카테고리가 포함된 투두 생성
	func createTodoInCategory(category: Category, todo: Todo) {
		do {
			try realm.write {
				category.todo.append(todo)
			}
		} catch {
			print(error)
		}
	}

	//카테고리 업데이트
	func updateCategory(id: ObjectId,
						name: String,
						tintColor: String,
						symbol: String) {
		do {
			try realm.write {
				realm.create(Category.self,
							 value: ["id": id,
								"name": name,
									 "tintColor": tintColor,
									 "symbol": symbol],
							 update: .modified)
			}
		} catch {
			print(error)
		}
	}

	//투두 업데이트
	func updateTodo(id: ObjectId,
					title: String,
					memo: String? = nil,
					endDate: Date? = nil,
					tag: String? = nil,
					priority: Int,
					newCategory: Category? = nil) {
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

					if let newCategory = newCategory, let todoToUpdate = realm.object(ofType: Todo.self, forPrimaryKey: id) {
						if let oldCategory = todoToUpdate.main.first {
							if let index = oldCategory.todo.index(of: todoToUpdate) {
								oldCategory.todo.remove(at: index)
							}
						}

						newCategory.todo.append(todoToUpdate)
					}
			}
		} catch {
			print(error)
		}
	}

	//삭제
	func deleteItem<T: Object>(_ item: T) {
		do {
			try realm.write {
				if let categoryItem = item as? Category {
					realm.delete(categoryItem.todo)
				}
				realm.delete(item)
			}
		}
		catch {
			print("delete error")

		}
	}

	func fetchItem<T: Object>(_ type: T.Type) -> Results<T> {
		return realm.objects(type)
	}

	func filterTodos(type: CategoryDefaultType, list: Results<Todo>) -> Results<Todo> {
		switch type {
		case .total:
			return list
		case .today:
			let start = Calendar.current.startOfDay(for: Date())
			let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
			let predicate = NSPredicate(format: "endDate >= %@ && endDate < %@", argumentArray: [start, end])
			return list.filter(predicate)

		case .schedule:
			let predicate = NSPredicate(format: "endDate > %@", Date() as NSDate)
			return list.filter(predicate)

		case .important:
			return list.filter("priority == 1")

		case .completed:
			return list.filter("doOrNot == true")
		}
	}



	func sortTodos(list: Results<Todo>, type: SortType) -> Results<Todo> {
		switch type {
		case .endDate:
			return list.sorted(byKeyPath: "endDate", ascending: true)
		case .title:
			return list.sorted(byKeyPath: "title", ascending: true)
		case .priorityLower:
			return list.filter("priority == %@", PriorityType.lower.rawValue)
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
