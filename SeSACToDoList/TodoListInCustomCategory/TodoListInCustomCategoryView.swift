//
//  TodoListInCustomCategoryView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/21/24.
//

import UIKit
import SnapKit
import FSCalendar


class TodoListInCustomCategoryView: BaseView {

	let calendar = FSCalendar()
	let todoListTableView = UITableView()

	override func configureHierarchy() {
		addSubview(calendar)
		addSubview(todoListTableView)
	}

	override func configureLayout() {

		calendar.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
			make.height.equalTo(200)
		}

		todoListTableView.snp.makeConstraints { make in
			make.top.equalTo(calendar.snp.bottom)
			make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
		}
	}

	override func configureView() {

		calendar.backgroundColor = .black
		calendar.appearance.titleDefaultColor = .white
		calendar.appearance.weekdayTextColor = .white
		calendar.appearance.headerTitleColor = .white
		calendar.appearance.titlePlaceholderColor = .darkGray
		calendar.appearance.titleWeekendColor = .red
		calendar.scrollDirection = .horizontal
		calendar.appearance.eventDefaultColor = .green
		calendar.appearance.todayColor = .darkGray

		todoListTableView.backgroundColor = .clear
		todoListTableView.sectionHeaderTopPadding = 0
	}

}
