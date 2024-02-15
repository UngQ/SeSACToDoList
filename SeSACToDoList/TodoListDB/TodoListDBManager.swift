//
//  TodoListDBManager.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import RealmSwift

class TodoListDBManager {

	static let shared = TodoListDBManager()

	private init() {}

	var todoList: Results<TodoTable>!

	func setTodoList() {
		let realm = try! Realm()
		todoList = realm.objects(TodoTable.self)
		print(realm.configuration.fileURL)

	}
}
