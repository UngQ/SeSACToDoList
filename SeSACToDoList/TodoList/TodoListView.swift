//
//  TodoListView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit

class TodoListView: BaseView {

	let todoListTableView = UITableView()

	override init(frame: CGRect) {
		super.init(frame: frame)

	}

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


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
