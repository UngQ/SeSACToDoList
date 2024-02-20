//
//  AddCategoryViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/20/24.
//

import UIKit

class AddCategoryViewController: BaseViewController {

	let mainView = AddCategoryView()

	let repository = TodoListTableRepository()

	override func loadView() {
		view = mainView
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonClicked))
		navigationItem.rightBarButtonItem = saveButton


    }

	@objc func saveButtonClicked() {
		print(#function)

		let data = Category(name: mainView.nameTextField.text!,
							tintColor: "green",
							symbol: "list.bullet.circle.fill")

		repository.createCategory(data)

		navigationController?.popViewController(animated: true)
	}




}
