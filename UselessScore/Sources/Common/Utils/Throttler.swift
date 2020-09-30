//
//  Throttler.swift
//  LiveCounter
//
//  Created by Антон Лобанов on 21.09.2020.
//

import Foundation

protocol IThrottler: AnyObject
{
	func throttle(_ action: @escaping () -> Void)
	func cancel()
}

final class Throttler
{
	private var workItem = DispatchWorkItem(block: {})
	private let queue: DispatchQueue
	private let delay: TimeInterval

	init(delay: TimeInterval = 0.5, queue: DispatchQueue = .main) {
		self.delay = delay
		self.queue = queue
	}
}

extension Throttler: IThrottler
{
	func throttle(_ action: @escaping () -> Void) {
		self.workItem.cancel()

		self.workItem = DispatchWorkItem {
			action()
		}

		self.queue.asyncAfter(deadline: .now() + delay, execute: self.workItem)
	}

	func cancel() {
		self.workItem.cancel()
	}
}
