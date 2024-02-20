//
//  TodoListView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/14/24.
//

import UIKit

class CategoryListView: BaseView {

	let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CategoryListView.configureCollectionViewCellLayout())

	let customCategoryTableView = UITableView(frame: .zero, style: .insetGrouped)

	override init(frame: CGRect) {
		super.init(frame: frame)

	}

	override func configureHierarchy() {
		addSubview(categoryCollectionView)
		addSubview(customCategoryTableView)
	}

	override func configureLayout() {
		categoryCollectionView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
			make.height.equalTo(UIScreen.main.bounds.width / 2 + 96)
		}

		customCategoryTableView.snp.makeConstraints { make in
			make.top.equalTo(categoryCollectionView.snp.bottom)
			make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
		}
	}

	override func configureView() {

		categoryCollectionView.backgroundColor = .clear

		customCategoryTableView.backgroundColor = .clear
 
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static func configureCollectionViewCellLayout() -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 18
		let cellWidth = UIScreen.main.bounds.width - (spacing * 3)

		layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 4)
		layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
		layout.minimumLineSpacing = spacing
		layout.minimumInteritemSpacing = 0
		layout.scrollDirection = .vertical

		return layout
	}

}


