//
//  AddCategoryViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/20/24.
//

import UIKit

class AddCategoryViewController: BaseViewController {

	//true 일 경우 수정화면
	var addOrModify = false
	var category: Category?

	let mainView = AddCategoryView()

	let repository = TodoListTableRepository()

	override func loadView() {
		view = mainView
	}

    override func viewDidLoad() {
        super.viewDidLoad()


		if addOrModify == false {
			let saveButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(saveButtonClicked))
			navigationItem.rightBarButtonItem = saveButton
		} else {
			let modifyButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(modifyButtonClicked))
			navigationItem.rightBarButtonItem = modifyButton
		}

    }

	@objc func saveButtonClicked() {
		print(#function)

		let data = Category(name: mainView.nameTextField.text!,
							tintColor: "green",
							symbol: "list.bullet.circle.fill")

		repository.createItem(data)

		navigationController?.popViewController(animated: true)
	}
	
	@objc func modifyButtonClicked() {
		print(#function)



		guard let category = category else { return }
		repository.updateCategory(id: category.id, name: mainView.nameTextField.text!, tintColor: "blue", symbol: "circle.fill")

		navigationController?.popViewController(animated: true)
	}


}
