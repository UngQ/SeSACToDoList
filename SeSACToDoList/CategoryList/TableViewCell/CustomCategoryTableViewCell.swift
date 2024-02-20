//
//  CustomCategoryTableViewCell.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/20/24.
//

import UIKit
import SnapKit

class CustomCategoryTableViewCell: UITableViewCell {

	let categoryImageView = UIImageView(frame: .zero)
	let categoryTitleLabel = UILabel()
	let categoryCountLabel = UILabel()
	let buttonImageView = UIImageView(frame: .zero)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureHierarchy()
		configureLayout()
		configureCell()
	}

	func configureHierarchy() {
		contentView.addSubview(categoryImageView)
		contentView.addSubview(categoryTitleLabel)
		contentView.addSubview(categoryCountLabel)
		contentView.addSubview(buttonImageView)
	}

	func configureLayout() {
		categoryImageView.snp.makeConstraints { make in
			make.verticalEdges.leading.equalTo(safeAreaLayoutGuide).inset(8)
			make.width.equalTo(categoryImageView.snp.height)
		}


		buttonImageView.snp.makeConstraints { make in
			make.trailing.equalTo(safeAreaLayoutGuide).offset(-8)
			make.size.equalTo(16)
			make.centerY.equalToSuperview()

		}

		categoryCountLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.trailing.equalTo(buttonImageView.snp.leading)
			make.width.equalTo(categoryCountLabel.snp.height)
		}
		categoryTitleLabel.snp.makeConstraints { make in
			make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(8)
			make.leading.equalTo(categoryImageView.snp.trailing).offset(4)

			make.trailing.equalTo(categoryCountLabel.snp.leading).offset(-4)
		}



	}

	func configureCell() {
		backgroundColor = .darkGray

		buttonImageView.image = UIImage(systemName: "chevron.right")
		buttonImageView.contentMode = .scaleAspectFit
		categoryTitleLabel.font = .boldSystemFont(ofSize: 14)
		categoryTitleLabel.textColor = .white
		categoryCountLabel.font = .boldSystemFont(ofSize: 14)
		categoryCountLabel.textColor = .white
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
