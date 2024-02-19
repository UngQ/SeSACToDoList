//
//  ImageViewController.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/19/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class ImageWebSearchViewController: BaseViewController {

	let mainView = ImageWebSearchView()

	var itemList: [Item] = []
	var itemNumber = 1
	var lastPage = 1

	var valueSpace: ((URL) -> Void)?

	override func loadView() {
		view = mainView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func configureView() {
		mainView.searchBar.delegate = self
		mainView.resultCollectionView.delegate = self
		mainView.resultCollectionView.dataSource = self
		mainView.resultCollectionView.prefetchDataSource = self
		mainView.resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "ResultCollectionViewCell")
		mainView.resultCollectionView.collectionViewLayout = mainView.configureCollectionViewCellLayout()
	}
}


//searchBar
extension ImageWebSearchViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		itemNumber = 1

		NaverAPIManager.shared.callRequest(text: searchBar.text!, itemNumber: itemNumber) {

			if $1 == nil {
				guard let result = $0 else { return }
				if result.items.count == 0 {
					self.mainView.totalLabel.text = "검색 결과가 없습니다"
					self.itemList = []
					self.mainView.resultCollectionView.reloadData()
				} else {
					self.itemList = result.items
					self.lastPage = result.total / 30
					self.mainView.totalLabel.text = "\(self.intNumberFormatter(number: result.total)) 개의 검색 결과"

					self.mainView.resultCollectionView.reloadData()

					self.mainView.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
				}
			}
		}}
}

//collectionView
extension ImageWebSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return itemList.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCollectionViewCell", for: indexPath) as! ResultCollectionViewCell

		cell.url = URL(string: itemList[indexPath.row].thumbnail)
		cell.backgroundColor = .clear
		cell.imageView.kf.setImage(with: cell.url)
		cell.imageView.contentMode = .scaleAspectFill

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: IndexPath(item: indexPath.item, section: indexPath.section)) as! ResultCollectionViewCell

		alert(url: cell.url!)
	}
}

//collectionView prefetching
extension ImageWebSearchViewController: UICollectionViewDataSourcePrefetching {

	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		for item in indexPaths {
			if itemList.count - 6 == item.row {
				itemNumber += 30

				NaverAPIManager.shared.callRequest(text: self.mainView.searchBar.text!, itemNumber: itemNumber) {

					if $1 == nil {
						guard let result = $0 else { return }
						self.itemList.append(contentsOf: result.items)
						self.mainView.resultCollectionView.reloadData()
					}
				}
			}
		}
	}
}

extension ImageWebSearchViewController {
	func alert(url: URL) {

		let alert = UIAlertController(title: "사진을 추가하시겠습니까?", message: nil, preferredStyle: .alert)
		let okButton = UIAlertAction(title: "확인", style: .default) { _ in
			self.valueSpace!(url)
			self.dismiss(animated: true)
		}
		let cancelButton = UIAlertAction(title: "취소", style: .cancel)

		alert.addAction(okButton)
		alert.addAction(cancelButton)

		present(alert, animated: true)
	}
}

extension ImageWebSearchViewController {
	func intNumberFormatter(number: Int?) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		let intPrice = number
		let formattedSave = formatter.string(for: intPrice)!

		return formattedSave
	}
}
