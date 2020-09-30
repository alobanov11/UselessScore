//
//  Created by Антон Лобанов on 10.07.2020.
//  Copyright © 2020 Антон Лобанов. All rights reserved.
//

import Foundation

public final class WeakThreadSafeSet<T>
{
	private struct WeakWrapper
	{
		weak var value: AnyObject?
	}

	private var array = [WeakWrapper]()
	private let queue = DispatchQueue(label: "WeakThreadSafeSet", attributes: .concurrent)

	public init() { }

	public func add(_ object: T) {
		let object = object as AnyObject
		self.queue.async(flags: .barrier) { [weak object] in
			if self.array.contains(where: { $0.value === object }) {
				// do nothing
			}
			else {
				self.array.append(WeakWrapper(value: object))
			}
		}
	}

	public func remove(_ object: T) {
		let object = object as AnyObject
		self.queue.async(flags: .barrier) { [weak object] in
			self.array.removeAll {
				guard let value = $0.value else { return true }
				return value === object
			}
		}
	}

	public func forEach(_ body: (T) -> Void) {
		self.queue.sync {
			return self.array.compactMap { $0.value as? T }.forEach(body)
		}
	}

	public func contains(_ object: T) -> Bool {
		return self.queue.sync {
			return self.array.contains {
				return $0.value === object as AnyObject
			}
		}
	}

	public func count() -> Int {
		return self.queue.sync {
			return self.array.compactMap { $0.value as? T }.count
		}
	}

	public func flush() {
		self.queue.async(flags: .barrier) {
			self.array.removeAll { $0.value == nil }
		}
	}
}
