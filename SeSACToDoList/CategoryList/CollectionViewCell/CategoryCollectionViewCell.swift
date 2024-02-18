//
//  CategoryCollectionViewCell.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/15/24.
//

import UIKit
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {

	let categoryImageView = UIImageView(frame: .zero)
	let categoryTitleLabel = UILabel()
	let categoryCountLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureHierarchy()
		configureLayout()
		configureCell()
	}

	func configureHierarchy() {
		contentView.addSubview(categoryImageView)
		contentView.addSubview(categoryTitleLabel)
		contentView.addSubview(categoryCountLabel)
	}

	func configureLayout() {
		categoryImageView.snp.makeConstraints { make in
			make.width.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
			make.top.equalToSuperview().offset(8)
			make.leading.equalToSuperview().offset(8)
		}

		categoryTitleLabel.snp.makeConstraints { make in
			make.trailing.bottom.equalToSuperview().offset(-12)
			make.leading.equalToSuperview().offset(12)
			make.top.equalTo(categoryImageView.snp.bottom).offset(8)
		}

		categoryCountLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
			make.size.equalTo(categoryImageView.snp.width)
		}
	}

	func configureCell() {
		backgroundColor = .darkGray
		layer.cornerRadius = 8

		let cornerRadius = (UIScreen.main.bounds.width - (12 * 3)) / 16
		categoryImageView.layer.cornerRadius = cornerRadius
		categoryImageView.layer.borderColor = UIColor.darkGray.cgColor
		categoryImageView.layer.borderWidth = 3
		categoryImageView.layer.masksToBounds = true


		categoryTitleLabel.textColor = .lightGray


		categoryCountLabel.textAlignment = .center
		categoryCountLabel.font = .boldSystemFont(ofSize: 32)
		categoryCountLabel.textColor = .white
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
