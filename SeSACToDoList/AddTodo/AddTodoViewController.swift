//
//  AddTodoViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit
import RealmSwift
import Toast

enum OptionType: Int, CaseIterable {
	case date
	case tag
	case priority
	case image

	var title: String {
		switch self {
		case .date:
			"마감일 (선택):"
		case .tag:
			"태그 (선택):"
		case .priority:
			"우선 순위: 없음"
		case .image:
			"이미지 추가 (작업 중)"
		}
	}
}

class AddTodoViewController: BaseViewController {

	let optionTypeList = OptionType.allCases

	let mainView = AddTodoView()

	let repository = TodoListTableRepository()

	//true일 경우, 수정 화면
	var addOrModify = false
	var item: TodoTable?

	var endDate: Date?
	var tag: String?
	var priority: Int?


	override func loadView() {
		view = mainView
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let selectedIndexPath = mainView.optionTableView.indexPathForSelectedRow {
			mainView.optionTableView.deselectRow(at: selectedIndexPath, animated: animated)
		}

	}

    override func viewDidLoad() {
        super.viewDidLoad()

		if addOrModify == false {
			let saveButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(saveButtonClicked))
			navigationItem.rightBarButtonItem = saveButton
		} else {
			let modifyButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(modifyButtonClicked))
			navigationItem.rightBarButtonItem = modifyButton


			mainView.titleTextField.text = item?.title
			mainView.memoTextView.text = item?.memo
			print(item?.priority)

		}

		NotificationCenter.default.addObserver(self,
											   selector: #selector(tagReceivedNotification),
											   name: NSNotification.Name("TagReceived"),
											   object: nil)
    }

	override func configureView() {
		mainView.memoTextView.delegate = self

		mainView.optionTableView.delegate = self
		mainView.optionTableView.dataSource = self
		mainView.optionTableView.register(OptionTableViewCell.self, forCellReuseIdentifier: "OptionTableViewCell")
	}


	@objc func saveButtonClicked() {

		guard mainView.titleTextField.text != "" else {
			self.view.makeToast("", position: .top, title: "제목은 필수사항 입니다!")
			return }

		var memo = mainView.memoTextView.text

		if mainView.memoTextView.text == "메모 (선택)" {
			memo = nil
		}

		let data = TodoTable(regDate: Date(),
							 title: mainView.titleTextField.text!,
							 memo: memo,
							 endDate: endDate,
							 tag: tag,
							 priority: priority ?? 0)

		repository.createItem(data)

		navigationController?.popViewController(animated: true)

	}

	@objc func modifyButtonClicked() {

		guard mainView.titleTextField.text != "" else {
			self.view.makeToast("", position: .top, title: "제목은 필수사항 입니다!")
			return }

		var memo = mainView.memoTextView.text

		if mainView.memoTextView.text == "메모 (선택)" {
			memo = nil
		}

		print("수정")
		repository.updateItem(id: item!.id, title: mainView.titleTextField.text!, memo: memo, endDate: endDate ?? nil, tag: tag ?? nil, priority: priority ?? 0)

		navigationController?.popViewController(animated: true)


	}
}

extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return OptionType.allCases.count
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as! OptionTableViewCell
		cell.titleLabel.text = OptionType.allCases[indexPath.section].title

		switch OptionType.allCases[indexPath.section] {
		case .date:
			if self.endDate != nil  {
				cell.titleLabel.text = "마감일: \(self.endDate!.toString())"
			}
		case .tag:
			if self.tag != nil {
				cell.titleLabel.text = "태그: #\(tag!)"
			}
		case .priority:
			if self.priority != nil {
				cell.titleLabel.text = "우선 순위: \(PriorityType.allCases[priority!].value)"
			}
		case .image:
			cell //공사중
		}

		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	
//		let index = indexPath.row

//		switch optionTypeList[index] {
//		case .date:
//		case .image:
//		case .rank:
//		case .tag:
//		}

		//클로저 값전달
		if indexPath.section == OptionType.date.rawValue {
			let vc = DateViewController()
			vc.valueSpace = { value in
				let cell = self.mainView.optionTableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as! OptionTableViewCell

				print(value)
				if let date = value.toDate() {
					self.endDate = date
					print(date)
				}

				cell.titleLabel.text = "마감일: \(value)"
			}
			navigationController?.pushViewController(vc, animated: true)
		}

		//노티피케이션 값전달
		else if indexPath.section == OptionType.tag.rawValue {
			let vc  = TagViewController()

			navigationController?.pushViewController(vc, animated: true)
		}

		//클로저 값전달
		else if indexPath.section == OptionType.priority.rawValue {
				let vc = PriorityViewController()
			vc.valueSpace = { value in
				let cell = self.mainView.optionTableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as! OptionTableViewCell
	
				for i in PriorityType.allCases {
					if i.value == value {
						self.priority = i.rawValue
						print(i.rawValue)
					}
				}

				cell.titleLabel.text = "우선 순위: \(value)"
			}

				navigationController?.pushViewController(vc, animated: true)
			}
		}

	

	@objc func tagReceivedNotification(notification: NSNotification) {
		let cell = self.mainView.optionTableView.cellForRow(at: IndexPath(row: 0, section: OptionType.tag.rawValue)) as! OptionTableViewCell


		if let value = notification.userInfo?["tag"] as? String {
			tag = value
			cell.titleLabel.text = "태그: #\(value)"
		}
	}

}





extension AddTodoViewController: UITextViewDelegate {

	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = "메모 (선택)"
			textView.textColor = .lightGray
		}
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == .lightGray {
			textView.text = nil
			textView.textColor = .white
		}
	}

	func textViewDidChange(_ textView: UITextView) {

		let size = CGSize(width: view.frame.width, height: .infinity)
		let estimatedSize = textView.sizeThatFits(size)

		textView.constraints.forEach { (constraint) in

			if estimatedSize.height <= 84 || estimatedSize.height > 180 {}
			else {
				if constraint.firstAttribute == .height {
					constraint.constant = estimatedSize.height
				}
			}
		}
	}
}
