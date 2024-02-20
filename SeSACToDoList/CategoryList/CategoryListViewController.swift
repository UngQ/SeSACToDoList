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

	var totalList: Results<Todo>!
	var todayList: Results<Todo>!
	var scheduleList: Results<Todo>!
	var importantList: Results<Todo>!
	var completedList: Results<Todo>!

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


		configureToolbar()
		
		customCategoryList = repository.fetchCategory()

		totalList = repository.fetchTotal()
		todayList = repository.fetchToday()
		scheduleList = repository.fetchSchedule()
		importantList = repository.fetchImportant()
		completedList = repository.fetchCompleted()

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
		let vc = TodoListViewController()
		vc.titleText = CategoryDefaultType.allCases[indexPath.row].title

		switch CategoryDefaultType.allCases[indexPath.row] {
		case .total:
			vc.list = repository.fetchTotal()
			vc.base = repository.fetchTotal
		case .today:
			vc.list = repository.fetchToday()
			vc.base = repository.fetchToday
		case .schedule:
			vc.list = repository.fetchSchedule()
			vc.base = repository.fetchSchedule
		case .important:
			vc.list = repository.fetchImportant()
			vc.base = repository.fetchImportant
		case .completed:
			vc.list = repository.fetchCompleted()
			vc.base = repository.fetchCompleted
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

	
}
