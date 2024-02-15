//
//  TodoListViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import UIKit

class TodoListViewController: BaseViewController {

	let mainView = TodoListView()
	let test = UIButton()
	var list = TodoListDBManager.shared.todoList!

	override func loadView() {
		view = mainView
	}

	override func viewWillAppear(_ animated: Bool) {

	}

    override func viewDidLoad() {
        super.viewDidLoad()


    }

	override func configureView() {
		addPullDownButtonToNavigationBar()

		mainView.todoListTableView.delegate = self
		mainView.todoListTableView.dataSource = self
		mainView.todoListTableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: "TodoListTableViewCell")
	}

	@objc func rightBarButtonItemClicked() {

		}

	func createMenuItems() -> UIMenu {
		let action1 = UIAction(title: "마감일 순") { action in
			self.list = TodoListDBManager.shared.todoList.sorted(byKeyPath: "endDate", ascending: true)

			self.mainView.todoListTableView.reloadData()
		}

		let action2 = UIAction(title: "제목 순") { action in
			self.list = TodoListDBManager.shared.todoList.sorted(byKeyPath: "title", ascending: true)

			self.mainView.todoListTableView.reloadData()
		}

		let action3 = UIAction(title: "우선순위 낮음만") { action in
			self.list = TodoListDBManager.shared.todoList.filter("priority == %d", 2)
			self.mainView.todoListTableView.reloadData()
		}

		let menu = UIMenu(title: "정렬", children: [action1, action2, action3])
		return menu
	}


	func addPullDownButtonToNavigationBar() {
		// Create the menu
		let menu = createMenuItems()

		// Create a bar button item
		let menuBarButton = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)

		// Set the bar button item to the navigation item (typically the right bar button item)
		navigationItem.rightBarButtonItem = menuBarButton
	}
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListTableViewCell", for: indexPath) as! TodoListTableViewCell


		cell.titleLabel.text = "\(list[indexPath.row].title) | \(list[indexPath.row].endDate) | \(PriorityType.allCases[list[indexPath.row].priority].value)"

		return cell
	}
	

}
