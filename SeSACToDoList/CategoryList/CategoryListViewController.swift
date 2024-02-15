//
//  TodoListViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit

class CategoryListViewController: BaseViewController {

	let mainView = CategoryListView()

	var addTodoButton: UIBarButtonItem!
	var addCategoryButton: UIBarButtonItem!

	var categoryList = ["전체", "오늘", "예정", "중요", "완료"]

	override func loadView() {
		view = mainView
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		mainView.categoryCollectionView.reloadData()
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		configureToolbar()
		
		TodoListDBManager.shared.setTodoList()
		
    }

	override func configureView() {
		mainView.categoryCollectionView.delegate = self
		mainView.categoryCollectionView.dataSource = self
		mainView.categoryCollectionView.register(CategoryCollectionViewCell.self
												 , forCellWithReuseIdentifier: "CategoryCollectionViewCell")
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
		print(#function)
	}


}


extension CategoryListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

	

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categoryList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell

		cell.categoryCountLabel.text = "\(TodoListDBManager.shared.todoList.count)"
		cell.categoryTitleLabel.text = categoryList[indexPath.row]


		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let vc = TodoListViewController()

		navigationController?.pushViewController(vc, animated: true)
	}


}
