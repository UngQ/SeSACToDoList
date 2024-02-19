//
//  BaseImageView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/20/24.
//

import UIKit

class BaseImageView: UIImageView {

	override init(frame: CGRect) {
		super.init(frame: frame)


		clipsToBounds = true
//		backgroundColor = .black
		contentMode = .scaleAspectFit
		tintColor = .white
		layer.cornerRadius = 12
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
