//
//  NaverAPIManger.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/20/24.
//

import Foundation
import Alamofire


final class NaverAPIManager {

	static let shared = NaverAPIManager()

	private init() {}


	func callRequest(text: String,
					 itemNumber: Int,
					 completionHandler: @escaping ((NaverImageModel?, AFError?) -> Void)) {
		let url = "https://openapi.naver.com/v1/search/image"

		let headers: HTTPHeaders = [
			"X-Naver-Client-Id": APIKey.naverClientID,
			"X-Naver-Client-Secret": APIKey.naverClientSecret
		]


		let parameters: Parameters = [
			"query": text,
			"start": itemNumber,
			"display": "30",
		]

		AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: NaverImageModel.self) { response in
			switch response.result {
			case .success(let success):
				completionHandler(success, nil)

			case .failure(let failure):
				completionHandler(nil, failure)
			}
		}
	}
}
