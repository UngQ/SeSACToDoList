//
//  TodoListViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit

class TodoListViewController: BaseViewController {

	let mainView = TodoListView()

	var addTodoButton: UIBarButtonItem!
	var addCategoryButton: UIBarButtonItem!
	

	override func loadView() {
		view = mainView

	}

    override func viewDidLoad() {
        super.viewDidLoad()

		configureToolbar()



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


extension TodoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath)

		cell.backgroundColor = .white
		return cell
	}
	

}
