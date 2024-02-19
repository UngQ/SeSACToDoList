//
//  OptionTableViewCell.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

	let fakeView = UIView()

	let titleLabel = UILabel()
	let buttonImage = UIImageView()

	let photoImageView = BaseImageView(frame: .zero)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		contentView.addSubview(titleLabel)
		contentView.addSubview(buttonImage)
		contentView.addSubview(photoImageView)



		titleLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(10)
			make.leading.equalToSuperview().offset(8)
			make.height.equalTo(40)
			make.width.greaterThanOrEqualTo(160)
		}

		buttonImage.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-8)
			make.centerY.equalToSuperview()
			make.size.equalTo(16)

		}
		photoImageView.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom)
			make.leading.equalToSuperview().offset(20)
			make.size.equalTo(100)

		}



		layer.masksToBounds = true
		layer.cornerRadius = 6
		backgroundColor = .darkGray


		titleLabel.textColor = .white
		titleLabel.font = .boldSystemFont(ofSize: 14)
		buttonImage.image = UIImage(systemName: "chevron.right")

		photoImageView.image = UIImage(systemName: "photo.badge.plus.fill")
//		photoImageView.contentMode = .
		photoImageView.isHidden = true


	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
