//
//  AddTodoViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit

enum OptionType: Int, CaseIterable {
	case date
	case tag
	case rank
	case image

	var title: String {
		switch self {
		case .date:
			"마감일"
		case .tag:
			"태그"
		case .rank:
			"우선 순위"
		case .image:
			"이미지 추가 (작업 중)"
		}
	}
}

class AddTodoViewController: BaseViewController {

	let optionTypeList = OptionType.allCases

	let mainView = AddTodoView()

	override func loadView() {
		view = mainView
	}

    override func viewDidLoad() {
        super.viewDidLoad()

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
}


//extension AddTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		4
//	}
//	
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCollectionViewCell", for: indexPath)
//		
//
//		return cell
//	}
//
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//		let vc = DateViewController()
//
//		navigationController?.pushViewController(vc, animated: true)
//	}
//}





extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return OptionType.allCases.count
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
	}
//	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return " "
//	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as! OptionTableViewCell
		cell.titleLabel.text = OptionType.allCases[indexPath.section].title
//		cell.selectionStyle = .none
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
		else if indexPath.section == OptionType.rank.rawValue {
				let vc = PriorityViewController()
			vc.valueSpace = { value in
				let cell = self.mainView.optionTableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as! OptionTableViewCell
				cell.titleLabel.text = "우선 순위: \(value)"
			}

				navigationController?.pushViewController(vc, animated: true)
			}
		}

	

	@objc func tagReceivedNotification(notification: NSNotification) {
		let cell = self.mainView.optionTableView.cellForRow(at: IndexPath(row: 0, section: OptionType.tag.rawValue)) as! OptionTableViewCell


		if let value = notification.userInfo?["tag"] as? String {
			cell.titleLabel.text = "태그: #\(value)"
		}
	}

}





extension AddTodoViewController: UITextViewDelegate {

	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = "메모"
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
