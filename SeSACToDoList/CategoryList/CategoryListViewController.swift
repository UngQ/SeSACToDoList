//
//  TodoListViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit
import RealmSwift

enum CategoryDefaultType: CaseIterable {

	case total
	case today
	case schedule
	case important
	case completed

	var title: String {
		switch self {
		case .total:
			"전체"
		case .today:
			"오늘"
		case .schedule:
			"예정"
		case .important:
			"중요"
		case .completed:
			"완료"
		}
	}

	var symbol: String {
		switch self {
		case .total:
			return "tray.circle.fill"
		case .today:
			let day = Date().pickupDayString()
			return "\(day).circle.fill"
		case .schedule:
			return "calendar.circle.fill"
		case .important:
			return "flag.circle.fill"
		case .completed:
			return "checkmark.circle.fill"
		}
	}

	var tint: UIColor {
		switch self {
		case .total:
			return .black
		case .today:
			return .tintColor
		case .schedule:
			return .systemOrange
		case .important:
			return .systemYellow
		case .completed:
			return .systemGray
		}
	}
}

class CategoryListViewController: BaseViewController {

	let mainView = CategoryListView()

	var addTodoButton: UIBarButtonItem!
	var addCategoryButton: UIBarButtonItem!

	var categoryList: [String] = CategoryDefaultType.allCases.map { $0.title }
	var customCategoryList: Results<Category>!

	lazy var totalList: Results<Todo>! = repository.fetchItem(Todo.self)
	lazy var todayList: Results<Todo>! = repository.filterTodos(type: .today, list: totalList)
	lazy var scheduleList: Results<Todo>! = repository.filterTodos(type: .schedule, list: totalList)
	lazy var importantList: Results<Todo>! = repository.filterTodos(type: .important, list: totalList)
	lazy var completedList: Results<Todo>! = repository.filterTodos(type: .completed, list: totalList)

	let startOfDay = Calendar.current.startOfDay(for: Date())
    lazy var endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

	let repository = TodoListTableRepository()

	override func loadView() {
		view = mainView
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		mainView.categoryCollectionView.reloadData()
		mainView.customCategoryTableView.reloadData()
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		let realm = try! Realm()
		print(realm.configuration.fileURL)
		do {
			let version = try schemaVersionAtURL(realm.configuration.fileURL!)
			print("Realm Scheme = \(version)")
		} catch {
			print(error)
		}

		configureToolbar()
		
		customCategoryList = repository.fetchItem(Category.self)
    }

	override func configureView() {
		mainView.categoryCollectionView.delegate = self
		mainView.categoryCollectionView.dataSource = self
		mainView.categoryCollectionView.register(CategoryCollectionViewCell.self
												 , forCellWithReuseIdentifier: "CategoryCollectionViewCell")

		mainView.customCategoryTableView.delegate = self
		mainView.customCategoryTableView.dataSource = self
		mainView.customCategoryTableView.register(CustomCategoryTableViewCell.self, forCellReuseIdentifier: "CustomCategoryTableViewCell")
		mainView.customCategoryTableView.rowHeight = 52

	}



	func configureToolbar() {
		self.navigationController?.isToolbarHidden = false

		let customButton = UIButton(type: .system)
			customButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
			customButton.setTitle(" 새로운 할 일", for: .normal)
			customButton.addTarget(self, action: #selector(addTodoButtonClicked), for: .touchUpInside)
			customButton.sizeToFit()

		addTodoButton = UIBarButtonItem(customView: customButton)
		addCategoryButton = UIBarButtonItem(title: "목록 추가", style: .plain, target: self, action: #selector(addCategoryButtonClicked))
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

		self.toolbarItems = [addTodoButton, flexibleSpace, addCategoryButton]
	}

	@objc func addTodoButtonClicked() {

		let vc = AddTodoViewController()

		navigationController?.pushViewController(vc, animated: true)
	}

	@objc func addCategoryButtonClicked() {
		let vc = AddCategoryViewController()
		navigationController?.pushViewController(vc, animated: true)
	}


}


extension CategoryListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()

		let label = UILabel()
		view.addSubview(label)
		label.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.height.equalTo(40)
		}

		label.text = " 나의 목록"
		label.textColor = .white
		label.font = .boldSystemFont(ofSize: 20)

		return view

	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categoryList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
		cell.categoryTitleLabel.text = categoryList[indexPath.row]
		cell.categoryImageView.image = UIImage(systemName: CategoryDefaultType.allCases[indexPath.row].symbol)
		cell.categoryImageView.tintColor = CategoryDefaultType.allCases[indexPath.row].tint
		cell.categoryImageView.backgroundColor = .white

		let index = indexPath.row

		switch CategoryDefaultType.allCases[index] {
		case .total:
			cell.categoryCountLabel.text = "\(totalList.count)"
		case .today:
			cell.categoryCountLabel.text = "\(todayList.count)"
		case .schedule:
			cell.categoryCountLabel.text = "\(scheduleList.count)"
		case .important:
			cell.categoryCountLabel.text = "\(importantList.count)"
		case .completed:
			cell.categoryCountLabel.text = "\(completedList.count)"
		}

		return cell
	}


	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let list = repository.fetchItem(Todo.self)

		let vc = TodoListViewController()

		vc.titleText = CategoryDefaultType.allCases[indexPath.row].title

		switch CategoryDefaultType.allCases[indexPath.row] {
		case .total:
			vc.originalList = list
		case .today:
			vc.originalList = repository.filterTodos(type: .today, list: list)
		case .schedule:
			vc.originalList = repository.filterTodos(type: .schedule, list: list)
		case .important:
			vc.originalList = repository.filterTodos(type: .important, list: list)
		case .completed:
			vc.originalList = repository.filterTodos(type: .completed, list: list)
		}

		navigationController?.pushViewController(vc, animated: true)
	}
}


extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return customCategoryList.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCategoryTableViewCell", for: indexPath) as! CustomCategoryTableViewCell

		cell.categoryImageView.image = UIImage(systemName: customCategoryList[indexPath.row].symbol)
		cell.categoryImageView.tintColor = UIColor(named: customCategoryList[indexPath.row].tintColor)
		cell.categoryTitleLabel.text = customCategoryList[indexPath.row].name
		cell.categoryCountLabel.text = "\(customCategoryList[indexPath.row].todo.count)"
		
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = TodoListInCustomCategoryViewController()
		vc.category = customCategoryList[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let modify = UIContextualAction(style: .normal, title: "수정") { (action, view, completionHandler) in

			print("수정")
			completionHandler(true)

			let vc = AddCategoryViewController()
			vc.addOrModify = true
			vc.category = self.customCategoryList[indexPath.row]


			self.navigationController?.pushViewController(vc, animated: true)
		}

		let delete = UIContextualAction(style: .normal, title: "삭제") { (action, view, completionHandler) in

			print("삭제")
			completionHandler(true)

			self.repository.deleteItem(self.customCategoryList[indexPath.row])
			self.mainView.customCategoryTableView.reloadData()
			self.mainView.categoryCollectionView.reloadData()
		}

		modify.backgroundColor = .gray
		delete.backgroundColor = .orange

		let config = UISwipeActionsConfiguration(actions: [delete, modify])
		// 끝까지 안늘어나게 함
		config.performsFirstActionWithFullSwipe = false

		return config
	}
	
}
