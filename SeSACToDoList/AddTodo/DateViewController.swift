//
//  DateViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit

class DateViewController: BaseViewController {

	let userTextField = UITextField()

	let datePickerView = UIPickerView()

	var valueSpace: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()


    }

	override func viewDidAppear(_ animated: Bool) {
		userTextField.becomeFirstResponder()
	}

	override func configureHierarchy() {
		view.addSubview(userTextField)
	}

	override func configureLayout() {
		userTextField.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(40)

			

		}
	}

	override func configureView() {
		let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
		navigationItem.rightBarButtonItem = saveButton

		let datePicker = UIDatePicker()
		datePicker.preferredDatePickerStyle = .inline
		datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

		userTextField.borderStyle = .none
		userTextField.textColor = .white
		userTextField.backgroundColor = .clear
		userTextField.attributedPlaceholder = NSAttributedString(string: "날짜를 선택해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
		userTextField.font = .boldSystemFont(ofSize: 24)
		userTextField.textAlignment = .center
		userTextField.tintColor = .clear
		userTextField.inputView = datePicker

	}

	@objc func datePickerValueChanged(_ sender: UIDatePicker) {
		let pickedDate = sender.date
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy년 MM월 dd일"
		let result = formatter.string(from: pickedDate)
		userTextField.text = result

	}

	@objc func saveButtonClicked() {
		valueSpace!(userTextField.text!)
		navigationController?.popViewController(animated: true)
	}



}

