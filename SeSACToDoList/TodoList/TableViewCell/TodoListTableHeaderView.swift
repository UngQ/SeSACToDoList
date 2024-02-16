//
//  TodoListTableHeaderView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import UIKit



class TodoListTableHeaderView: BaseView {

	let titleLabel = UILabel()

	override func configrueHierarchy() {
		addSubview(titleLabel)
	}

	override func configureLayout() {
		titleLabel.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

	}

	override func configureView() {

		titleLabel.textColor = .tintColor
		titleLabel.font = .boldSystemFont(ofSize: 28)
		
	}

}
