//
//  SelectCategoryViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/21/24.
//

import UIKit
import RealmSwift

class SelectCategoryViewController: BaseViewController {

	let categoryTableView = UITableView()
	var categoryList: Results<Category>!

	let repository = TodoListTableRepository()


	var valueSpace: ((Category) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

		categoryList = repository.fetchItem(Category.self)

    }

	override func configureHierarchy() {
		view.addSubview(categoryTableView)
	}

	override func configureLayout() {
		categoryTableView.snp.makeConstraints { make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}
	}

	override func configureView() {
		categoryTableView.delegate = self
		categoryTableView.dataSource = self

	}

}


extension SelectCategoryViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		categoryList.count

	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = categoryList[indexPath.row].name

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		valueSpace!(categoryList[indexPath.row])
		print(categoryList[indexPath.row])
		navigationController?.popViewController(animated: true)
	}



}
