//
//  BaseView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit
import SnapKit

class BaseView: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = .black

		configureHierarchy()
		configureLayout()
		configureView()
	}

	func configureHierarchy() {

	}

	func configureLayout() {

	}

	func configureView() {

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
