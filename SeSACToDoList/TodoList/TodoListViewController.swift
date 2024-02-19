//
//  TodoListViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import UIKit
import RealmSwift
import FSCalendar

class TodoListViewController: BaseViewController {

	let mainView = TodoListView()


	var titleText: String?
	var list: Results<TodoTable>!
	var base: (() -> Results<TodoTable>)?
	let repository = TodoListTableRepository()

	override func loadView() {
		view = mainView
	}

	override func viewWillAppear(_ animated: Bool) {
		mainView.todoListTableView.reloadData()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func configureView() {
		addPullDownButtonToNavigationBar()

		mainView.calendar.delegate = self
		mainView.calendar.dataSource = self

		mainView.todoListTableView.delegate = self
		mainView.todoListTableView.dataSource = self
		mainView.todoListTableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: "TodoListTableViewCell")
		mainView.todoListTableView.rowHeight = 80
	}

	func createMenuItems() -> UIMenu {
		let action1 = UIAction(title: "마감일 순") { action in
			self.list = self.base!()
			self.list = self.repository.sortEndDate(list: self.list)
			self.mainView.todoListTableView.reloadData()
		}

		let action2 = UIAction(title: "제목 순") { action in
			self.list = self.base!()
			self.list = self.repository.sortTitle(list: self.list)
			self.mainView.todoListTableView.reloadData()
		}

		let action3 = UIAction(title: "우선순위 낮음만") { action in
			self.list = self.repository.sortPriorityLower(list: self.list)
			self.mainView.todoListTableView.reloadData()
		}

		let menu = UIMenu(title: "정렬", children: [action1, action2, action3])
		return menu
	}


	func addPullDownButtonToNavigationBar() {
		let menu = createMenuItems()
		let menuBarButton = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
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
		cell.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)

		cell.titleLabel.attributedText = list[indexPath.row].title.removeStrikeThrough()
		cell.titleLabel.text = list[indexPath.row].title
		cell.priorityLabel.text = "\(PriorityType.allCases[list[indexPath.row].priority].symbol)"
		cell.memoLabel.text = ""
		cell.endDateLabel.text = ""
		cell.tagLabel.text = ""
		cell.photoImageView.isHidden = true

		if let memo = list[indexPath.row].memo {
			cell.memoLabel.text = memo
		}

		if let endDate = list[indexPath.row].endDate {
			cell.endDateLabel.text = "\(endDate.toString())  "
		}

		if let tag = list[indexPath.row].tag {
			cell.tagLabel.text = "#\(tag)"
		}

		if let image = loadImageToDocument(filename: "\(list[indexPath.row].id)") {
			cell.photoImageView.isHidden = false
			cell.photoImageView.image = image
		}

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

			let vc = AddTodoViewController()
			vc.addOrModify = true
			vc.item = self.list[indexPath.row]
			

			vc.endDate = self.list[indexPath.row].endDate
			vc.tag = self.list[indexPath.row].tag
			vc.priority = self.list[indexPath.row].priority
			
			if let image = self.loadImageToDocument(filename: "\(self.list[indexPath.row].id)") {
				vc.selectedImage = image
			}
			

			self.navigationController?.pushViewController(vc, animated: true)
		}

		let delete = UIContextualAction(style: .normal, title: "삭제") { (action, view, completionHandler) in

			print("삭제")
			completionHandler(true)
			self.repository.deleteItem(self.list[indexPath.row])
			self.mainView.todoListTableView.reloadData()
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


extension TodoListViewController: FSCalendarDelegate, FSCalendarDataSource {

	func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

		let start = Calendar.current.startOfDay(for: date)

		let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

		let predicate = NSPredicate(format: "endDate >= %@ && endDate < %@", start as NSDate, end as NSDate)

		return base!().filter(predicate).count
	}

	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		//오늘 시작 날짜
		let start = Calendar.current.startOfDay(for: date)

		//내일 시작 날짜
		let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()

		//쿼리 작성, 변순데 스트링이 들어갈경우 %@, 네모박스라고 생각
		let predicate = NSPredicate(format: "endDate >= %@ && endDate < %@", start as NSDate, end as NSDate)

		list = base!().filter(predicate)


		mainView.todoListTableView.reloadData()
	}

}
