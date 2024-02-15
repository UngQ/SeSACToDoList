//
//  TodoListTableViewCell.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import UIKit
import SnapKit

class TodoListTableViewCell: UITableViewCell {

	let titleLabel = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		configureHierarchy()
		configureLayout()
		configureCell()
	}

	func configureHierarchy() {
		contentView.addSubview(titleLabel)
	}

	func configureLayout() {
		titleLabel.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	func configureCell() {

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
