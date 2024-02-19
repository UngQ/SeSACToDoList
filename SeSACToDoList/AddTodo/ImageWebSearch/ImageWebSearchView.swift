//
//  ImageWebSearchView.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/20/24.
//

import UIKit

class ImageWebSearchView: BaseView {


	let searchBar = UISearchBar()
	let totalLabel = UILabel()
	let resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

	override func configureHierarchy() {
		addSubview(searchBar)
		addSubview(totalLabel)
		addSubview(resultCollectionView)
	}



	override func configureLayout() {
		searchBar.snp.makeConstraints { make in

			make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
			make.height.equalTo(60)

		}

		totalLabel.snp.makeConstraints { make in
			make.top.equalTo(searchBar.snp.bottom)
			make.horizontalEdges.equalTo(safeAreaLayoutGuide)
			make.height.equalTo(20)
		}

		resultCollectionView.snp.makeConstraints { make in
			make.top.equalTo(totalLabel.snp.bottom)
			make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
		}
	}

	override func configureView() {
		totalLabel.backgroundColor = .green
		resultCollectionView.backgroundColor = .blue
	}

	func configureCollectionViewCellLayout() -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 12
		let cellWidth = UIScreen.main.bounds.width - (spacing * 4)

		layout.itemSize = CGSize(width: cellWidth / 3, height: cellWidth / 3)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: 0, right: spacing)
		layout.minimumLineSpacing = spacing
		layout.minimumInteritemSpacing = 0
		layout.scrollDirection = .vertical

		return layout
	}


}


