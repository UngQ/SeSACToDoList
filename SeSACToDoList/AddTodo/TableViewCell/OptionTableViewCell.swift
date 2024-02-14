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

	

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		fakeView.addSubview(titleLabel)
		fakeView.addSubview(buttonImage)

		contentView.addSubview(fakeView)


		titleLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.leading.equalToSuperview().offset(8)
			make.height.equalTo(40)
			make.width.equalTo(160)
		}

		buttonImage.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-8)
			make.centerY.equalToSuperview()
			make.size.equalTo(16)

		}

		fakeView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalToSuperview()
			make.height.equalTo(48)
		}

		backgroundColor = .clear

		fakeView.layer.cornerRadius = 6
		fakeView.backgroundColor = .darkGray


		titleLabel.textColor = .white
		titleLabel.font = .boldSystemFont(ofSize: 14)
		buttonImage.image = UIImage(systemName: "chevron.right")

	
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
