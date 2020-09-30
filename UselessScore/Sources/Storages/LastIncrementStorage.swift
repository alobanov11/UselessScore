//
//  Created by Антон Лобанов on 12.04.2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import Foundation

protocol ILastIncrementStorage: AnyObject
{
	var value: IncrementModel? { get set }
}

final class LastIncrementStorage
{
	private let localStorage: IKeyValueStorage
	private let key: String

	init(localStorage: IKeyValueStorage, key: String) {
		self.localStorage = localStorage
		self.key = key
	}
}

extension LastIncrementStorage: ILastIncrementStorage
{
	var value: IncrementModel? {
		get {
			guard let data = self.localStorage.get(for: self.key, of: Data.self) else { return nil }
			let decoder = JSONDecoder()
			return try? decoder.decode(IncrementModel.self, from: data)
		}
		set {
			let encoder = JSONEncoder()
			guard let data = try? encoder.encode(newValue) else { return }
			self.localStorage.set(value: data, for: self.key)
		}
	}
}
