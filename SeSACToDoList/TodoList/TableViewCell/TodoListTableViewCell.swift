//
//  TodoListTableViewCell.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/16/24.
//

import UIKit
import SnapKit

class TodoListTableViewCell: UITableViewCell {

	let checkButton = UIButton()
	let priorityLabel = UILabel()
	let titleLabel = UILabel()
	let memoLabel = UILabel()
	let endDateLabel = UILabel()
	let tagLabel = UILabel()

	let photoImageView = BaseImageView(frame: .zero)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		configureHierarchy()
		configureLayout()
		configureCell()
	}

	func configureHierarchy() {
		contentView.addSubview(checkButton)
		contentView.addSubview(priorityLabel)
		contentView.addSubview(titleLabel)
		contentView.addSubview(memoLabel)
		contentView.addSubview(endDateLabel)
		contentView.addSubview(tagLabel)
		contentView.addSubview(photoImageView)
	}

	func configureLayout() {

		checkButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.leading.equalToSuperview().offset(8)
			make.size.equalTo(20)
		}

		photoImageView.snp.makeConstraints { make in
			make.verticalEdges.trailing.equalToSuperview().inset(8)
			make.width.equalTo(photoImageView.snp.height)
		}



		priorityLabel.snp.makeConstraints { make in
			make.trailing.equalTo(photoImageView.snp.leading).offset(-8)
			make.top.equalToSuperview().offset(8)
			make.height.equalTo(20)
			make.width.greaterThanOrEqualTo(0)
		}



		titleLabel.snp.makeConstraints { make in
			make.leading.equalTo(checkButton.snp.trailing).offset(4)
			make.trailing.equalTo(priorityLabel.snp.leading).offset(-4)
			make.top.equalToSuperview().offset(8)
			make.height.equalTo(20)
		}

		memoLabel.snp.makeConstraints { make in
			make.leading.equalTo(checkButton.snp.trailing).offset(4)
			make.top.equalTo(titleLabel.snp.bottom).offset(4)
			make.trailing.equalToSuperview().offset(-4)
			make.height.greaterThanOrEqualTo(0)
		}

		endDateLabel.snp.makeConstraints { make in
			make.leading.equalTo(checkButton.snp.trailing).offset(4)
			make.top.equalTo(memoLabel.snp.bottom).offset(4)
			make.height.greaterThanOrEqualTo(0)
			make.width.greaterThanOrEqualTo(0)
		}

		tagLabel.snp.makeConstraints { make in
			make.leading.equalTo(endDateLabel.snp.trailing)
			make.top.equalTo(memoLabel.snp.bottom).offset(4)
			make.trailing.equalTo(photoImageView.snp.leading).offset(-4)
			make.height.greaterThanOrEqualTo(0)
		}

	}

	func configureCell() {
		backgroundColor = .clear

		titleLabel.textColor = .white
		priorityLabel.textColor = .yellow
		memoLabel.textColor = .lightGray
		endDateLabel.textColor = .lightGray
		tagLabel.textColor = .link

		titleLabel.font = .boldSystemFont(ofSize: 15)
		priorityLabel.font = .boldSystemFont(ofSize: 15)
		memoLabel.font = .systemFont(ofSize: 13)
		endDateLabel.font = .systemFont(ofSize: 13)
		tagLabel.font = .boldSystemFont(ofSize: 13)

		photoImageView.contentMode = .scaleAspectFill



	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
