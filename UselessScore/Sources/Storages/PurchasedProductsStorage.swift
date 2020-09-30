//
//  Created by Антон Лобанов on 12.04.2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import Foundation

protocol IPurchasedProductsStorage: AnyObject
{
	// Identifiers
	var value: [String] { get set }
}

final class PurchasedProductsStorage
{
	private let localStorage: IKeyValueStorage
	private let key: String

	init(localStorage: IKeyValueStorage, key: String) {
		self.localStorage = localStorage
		self.key = key
	}
}

extension PurchasedProductsStorage: IPurchasedProductsStorage
{
	var value: [String] {
		get {
			self.localStorage.get(for: self.key, of: [String].self) ?? []
		}
		set {
			self.localStorage.set(value: Array(Set(newValue)), for: self.key)
		}
	}
}
