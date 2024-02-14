//
//  AddTodoView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit

class AddTodoView: BaseView {


	let fakeView = UIView()

	let titleTextField = UITextField()
	let lineView = UIView()
	let memoTextView = UITextView()

	let optionTableView = UITableView()

	let dateButton = UIButton()

	override func configrueHierarchy() {
		fakeView.addSubview(titleTextField)
		fakeView.addSubview(lineView)
		fakeView.addSubview(memoTextView)
		addSubview(fakeView)
		addSubview(optionTableView)
	}

	override func configureLayout() {

		fakeView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(4)
			make.height.greaterThanOrEqualTo(116)
		}

		titleTextField.snp.makeConstraints { make in
			make.top.horizontalEdges.equalToSuperview().inset(8)
			make.height.equalTo(28)
		}

		lineView.snp.makeConstraints { make in
			make.top.equalTo(titleTextField.snp.bottom).offset(2)
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview()
			make.height.equalTo(1)
		}

		memoTextView.snp.makeConstraints { make in
			make.top.equalTo(lineView.snp.bottom).offset(2)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(84)
		}

		optionTableView.snp.makeConstraints { make in
			make.top.equalTo(memoTextView.snp.bottom).offset(12)
			make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(4)
			make.bottom.equalTo(safeAreaLayoutGuide)
		}
	}

	override func configureView() {
		let cornerRadius: CGFloat = 6

		fakeView.layer.cornerRadius = cornerRadius
		fakeView.backgroundColor = .darkGray

		titleTextField.font = .systemFont(ofSize: 15)
		titleTextField.textColor = .white
		titleTextField.attributedPlaceholder = NSAttributedString(string: "제목", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])

		lineView.backgroundColor = .lightGray

		memoTextView.backgroundColor = .darkGray
		memoTextView.layer.cornerRadius = cornerRadius
		memoTextView.font = .systemFont(ofSize: 14)
		memoTextView.textContainerInset = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4	)
		memoTextView.text = "메모"
		memoTextView.textColor = .lightGray


		optionTableView.backgroundColor = .clear
//		optionTableView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

//		optionTableView.backgroundColor = .brown

//		dateButton.backgroundColor = .brown
//		dateButton.layer.cornerRadius = cornerRadius
//		dateButton.setTitle("마감일", for: .normal)
//		dateButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
//		dateButton.titleLabel?.textAlignment = .left

	}

}
