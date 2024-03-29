//
//  PriorityViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/15/24.
//

import UIKit

enum PriorityType: Int, CaseIterable {

	case none
	case upper
	case middle
	case lower

	var value: String {
		switch self {
		case .none: "없음"
		case .upper: "상"
		case .middle: "중"
		case .lower: "하"
		}
	}

	var symbol: String {
		switch self {
		case .none: ""
		case .upper: "★★★"
		case .middle: "★★"
		case .lower: "★"
		}
	}

}

class PriorityViewController: BaseViewController {
	
	let items = PriorityType.allCases.map { $0.value }
	lazy var segmented = UISegmentedControl(items: items)
	var selectedIndex = 0

	var valueSpace: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

	
    }
    

	override func configureHierarchy() {
		view.addSubview(segmented)
	}

	override func configureLayout() {
		segmented.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(50)
			make.width.equalTo(200)
		}
	}

	override func configureView() {
		let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
		navigationItem.rightBarButtonItem = saveButton

		segmented.backgroundColor = .brown
		segmented.selectedSegmentIndex = selectedIndex
		segmented.addTarget(self, action: #selector(test), for: .valueChanged)

	}

	@objc func test(sender: UISegmentedControl) {
		selectedIndex = sender.selectedSegmentIndex
	}

	@objc func saveButtonClicked() {
		valueSpace!(items[selectedIndex])
		navigationController?.popViewController(animated: true)
	}


}
