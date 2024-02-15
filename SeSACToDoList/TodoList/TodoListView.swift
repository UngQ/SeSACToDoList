//
//  TodoListView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import UIKit
import SnapKit


class TodoListView: BaseView {

	let todoListTableView = UITableView()

	override func configrueHierarchy() {

		addSubview(todoListTableView)
	}

	override func configureLayout() {

		todoListTableView.snp.makeConstraints { make in
			make.edges.equalTo(safeAreaLayoutGuide)
		}
	}

	override func configureView() {
		todoListTableView.backgroundColor = .brown
	}

}
