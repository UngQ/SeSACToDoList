//
//  TodoListViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import UIKit
import RealmSwift

class TodoListViewController: BaseViewController {

	let mainView = TodoListView()


	var titleText: String?
	var list: Results<TodoTable>!
	let repository = TodoListTableRepository()

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
		mainView.todoListTableView.rowHeight = 80
	}

	@objc func rightBarButtonItemClicked() {

		}

	func createMenuItems() -> UIMenu {
		let action1 = UIAction(title: "마감일 순") { action in
			self.list = self.repository.sortEndDate()
			self.mainView.todoListTableView.reloadData()
		}

		let action2 = UIAction(title: "제목 순") { action in
			self.list = self.repository.sortTitle()
			self.mainView.todoListTableView.reloadData()
		}

		let action3 = UIAction(title: "우선순위 낮음만") { action in
			self.list = self.repository.sortPriorityLower()
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

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		60
	}

	

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = TodoListTableHeaderView()
		view.titleLabel.text = titleText
		return view
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListTableViewCell", for: indexPath) as! TodoListTableViewCell
		cell.selectionStyle = .none
		cell.checkButton.tag = indexPath.row
		cell.checkButton.addTarget(self, action: #selector(checkButtonClicked), for: .touchUpInside)
		cell.titleLabel.attributedText = list[indexPath.row].title.removeStrikeThrough()
		cell.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)

		cell.memoLabel.text = ""
		cell.endDateLabel.text = ""
		cell.tagLabel.text = ""


		if let memo = list[indexPath.row].memo {
			cell.memoLabel.text = memo
		}

		if let endDate = list[indexPath.row].endDate {
			cell.endDateLabel.text = "\(endDate.toString())  "
		}

		if let tag = list[indexPath.row].tag {
			cell.tagLabel.text = "#\(tag)"
		}

		cell.titleLabel.text = list[indexPath.row].title

		cell.priorityLabel.text = "\(PriorityType.allCases[list[indexPath.row].priority].symbol)"


		if list[indexPath.row].doOrNot == true {
			cell.checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
			cell.titleLabel.attributedText = list[indexPath.row].title.strikeThrough()
		}


		return cell
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let modify = UIContextualAction(style: .normal, title: "수정") { (action, view, completionHandler) in

			print("수정")
			completionHandler(true)
		}

		let delete = UIContextualAction(style: .normal, title: "삭제") { (action, view, completionHandler) in

			print("삭제")
			completionHandler(true)

		}

		modify.backgroundColor = .gray
		delete.backgroundColor = .orange

		let config = UISwipeActionsConfiguration(actions: [delete, modify])
		// 끝까지 안늘어나게 함
		config.performsFirstActionWithFullSwipe = false

		return config
	}

	@objc func checkButtonClicked(_ sender: UIButton) {
		print("check")
		repository.updateDoOrNot(list[sender.tag])
		mainView.todoListTableView.reloadData()
	}




}
