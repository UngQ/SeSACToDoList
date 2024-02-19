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
			"이미지"
		}
	}
}

class AddTodoViewController: BaseViewController {

	let mainView = AddTodoView()

	let repository = TodoListTableRepository()

	//true일 경우, 수정 화면
	var addOrModify = false
	var item: TodoTable?

	var endDate: Date?
	var tag: String?
	var priority: Int?

	var selectedImage: UIImage?
	var selectedURL: URL?

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
			if item?.memo != nil {
				mainView.memoTextView.text = item?.memo
			}

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

		if let image = selectedImage {
			saveImageToDocument(image: image, filename: "\(data.id)")
		}

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
		saveImageToDocument(image: selectedImage!, filename: "\(item!.id)")
		repository.updateItem(id: item!.id, title: mainView.titleTextField.text!, memo: memo, endDate: endDate, tag: tag, priority: priority ?? 0)

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


			cell.photoImageView.isHidden = false
			if let image = selectedImage {
				cell.photoImageView.image = image
				cell.photoImageView.contentMode = .scaleAspectFill
			} else if let url = selectedURL {
				cell.photoImageView.kf.setImage(with: url)
				cell.photoImageView.contentMode = .scaleAspectFill
			}

		}

		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if indexPath.section == OptionType.image.rawValue {
			return 170
		}


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

		else if indexPath.section == OptionType.image.rawValue {

			let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			let gallery = UIAlertAction(title: "사진첩", style: .default) { action in

				let vc = UIImagePickerController()
//				vc.allowsEditing = true
				vc.delegate = self
				self.present(vc, animated: true)
			}
			let camera = UIAlertAction(title: "카메라", style: .default) { action in

				let vc = UIImagePickerController()
				vc.sourceType = .camera
				self.present(vc, animated: true)
			}
			let web = UIAlertAction(title: "인터넷 검색", style: .default) { action in

				let vc = ImageWebSearchViewController()
				vc.valueSpace = {
					self.selectedURL = $0
					self.selectedImage = nil
					self.mainView.optionTableView.reloadRows(at: [IndexPath(row: 0, section: OptionType.image.rawValue)], with: .none)
				}

				self.present(vc, animated: true)

			}
			let cancel = UIAlertAction(title: "취소", style: .cancel)

			alert.addAction(gallery)
			alert.addAction(camera)
			alert.addAction(web)
			alert.addAction(cancel)

			present(alert, animated: true)

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



extension AddTodoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

		print(#function)
		if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

			selectedImage = pickedImage
			selectedURL = nil
			mainView.optionTableView.reloadRows(at: [IndexPath(row: 0, section: OptionType.image.rawValue)], with: .none)
		}



		dismiss(animated: true)
	}
}
