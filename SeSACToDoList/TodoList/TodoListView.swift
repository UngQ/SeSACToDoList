//
//  TodoListView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit

class TodoListView: BaseView {

	let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: TodoListView.configureCollectionViewCellLayout())

	override init(frame: CGRect) {
		super.init(frame: frame)

	}

	override func configrueHierarchy() {
		addSubview(categoryCollectionView)
	}

	override func configureLayout() {
		categoryCollectionView.snp.makeConstraints { make in
			make.edges.equalTo(safeAreaLayoutGuide)
		}
	}

	override func configureView() {
		categoryCollectionView.backgroundColor = .brown
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static func configureCollectionViewCellLayout() -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 12
		let cellWidth = UIScreen.main.bounds.width - (spacing * 3)

		layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 4)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: 0, right: spacing)
		layout.minimumLineSpacing = spacing
		layout.minimumInteritemSpacing = 0
		layout.scrollDirection = .vertical

		return layout
	}

}


