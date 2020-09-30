//
//  Created by Антон Лобанов on 12.04.2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import Foundation

protocol IClearKeyValueStorage: AnyObject
{
	func clear()
}

/// KeyValueStorage is an abstraction over the UserDefaults.
/// - Save data locally
/// - Get local saved data
/// - Get local saved data in preferred data type
protocol IKeyValueStorage: AnyObject
{
	/// Save data locally
	///
	/// - Parameters:
	///   - value: data to be stored
	///   - key: key
	func set(value: Any?, for key: String)

	/// Get locally saved data if exists
	///
	/// - Parameter key: key against which the data is stored
	/// - Returns: data stored against the key, nil of no data present
	func get(for key: String) -> Any?

	/// Get locally saved data with specific data type if exists
	///
	/// - Parameters:
	///   - key: key against which the data is stored
	///   - type: data type of the data
	/// - Returns: data with the specified data type or nil of no data present/invalid data type
	func get<T>(for key: String, of type: T.Type) -> T?
}

final class KeyValueStorage
{
	private let defaults = UserDefaults.standard
	private let requiredKeys = AppConstants.LocalKey.RequiredKeys
}

extension KeyValueStorage: IKeyValueStorage
{
	func set(value: Any?, for key: String) {
		self.defaults.set(value, forKey: key)
	}

	func get(for key: String) -> Any? {
		return self.defaults.value(forKey: key)
	}

	func get<T>(for key: String, of type: T.Type) -> T? {
		return self.defaults.value(forKey: key) as? T
	}
}

extension KeyValueStorage: IClearKeyValueStorage
{
	func clear() {
		let dictionary = self.defaults.dictionaryRepresentation()
		dictionary.keys.forEach {
			guard self.requiredKeys.contains($0) == false else { return }
			self.defaults.removeObject(forKey: $0)
		}
	}
}
