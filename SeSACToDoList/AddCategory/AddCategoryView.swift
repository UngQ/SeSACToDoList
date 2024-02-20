//
//  AddCategoryView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/20/24.
//

import UIKit
import SnapKit

class AddCategoryView: BaseView {

	let nameTextField = UITextField()

	override func configureHierarchy() {
		addSubview(nameTextField)
	}
	override func configureLayout() {
		nameTextField.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
			make.height.equalTo(40)
		}
	}

	override func configureView() {
		nameTextField.backgroundColor = .brown
	}


}
