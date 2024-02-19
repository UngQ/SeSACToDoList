//
//  FileManager.swift
//  SeSACToDoList
//
//  Created by ungQ on 2/19/24.
//

import UIKit

extension UIViewController {

	func loadImageToDocument(filename: String) -> UIImage? {

		guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }

		let photoDirectory = documentDirectory.appendingPathComponent("photo")
		if !FileManager.default.fileExists(atPath: photoDirectory.path) {
			do {
				try FileManager.default.createDirectory(at: photoDirectory, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print("photo directory add fail")
			}
		}

		let fileURL = photoDirectory.appendingPathComponent("\(filename).jpg")

		if FileManager.default.fileExists(atPath: fileURL.path()) {
			return UIImage(contentsOfFile: fileURL.path())
		} else {
			return nil
		}
	}


	func saveImageToDocument(image: UIImage, filename: String) {

		guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

		let photoDirectory = documentDirectory.appendingPathComponent("photo")
		if !FileManager.default.fileExists(atPath: photoDirectory.path) {
			do {
				try FileManager.default.createDirectory(at: photoDirectory, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print("photo directory add fail")
			}
		}


		let fileURL = photoDirectory.appendingPathComponent("\(filename).jpg")

		guard let data = image.jpegData(compressionQuality: 0.5) else { return }

		do {
			try data.write(to: fileURL)
		} catch {
			print(error)
		}

	}
}
