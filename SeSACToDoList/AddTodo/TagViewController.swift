//
//  TagViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/15/24.
//

import UIKit

class TagViewController: BaseViewController {

	let tagTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()


    }

	override func configureHierarchy() {
		view.addSubview(tagTextField)
	}

	override func configureLayout() {
		tagTextField.snp.makeConstraints { make in
			make.width.equalTo(300)
			make.height.equalTo(48)
			make.centerX.equalTo(view)
			make.top.equalTo(view.safeAreaLayoutGuide)
		}
	}

	override func configureView() {
		let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
		navigationItem.rightBarButtonItem = saveButton

		tagTextField.attributedPlaceholder = NSAttributedString(string: "태그를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])

		tagTextField.textColor = .white
		
	}

	@objc func saveButtonClicked() {

		guard tagTextField.text!.count > 0 &&
			tagTextField.text!.count <= 6  else {
				self.view.makeToast("", position: .top, title: "6글자 이하로 입력하세요.")
				return
		}

		NotificationCenter.default.post(name: NSNotification.Name("TagReceived"),
										object: nil,
										userInfo: ["tag": tagTextField.text!])
		navigationController?.popViewController(animated: true)
	}
}
