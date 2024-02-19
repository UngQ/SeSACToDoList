//
//  ResultCollectionViewCell.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/20/24.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
	let imageView = UIImageView()

	var url: URL?

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureHierarchy()
		configureLayout()
		configureCell()
	}

	func configureHierarchy() {
		addSubview(imageView)
	}

	func configureLayout() {
		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}


	func configureCell() {
		imageView.backgroundColor = .red
		imageView.clipsToBounds = true
		imageView.tintColor = .white
		imageView.layer.cornerRadius = 12
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
