//
//  MovieNotifier.swift
//  Mowio
//
//  Created by Антон Лобанов on 10.07.2020.
//  Copyright © 2020 Антон Лобанов. All rights reserved.
//

import StoreKit

protocol IPaymentListener: AnyObject
{
	func updatedTransactions(_ transactions: [SKPaymentTransaction])
	func restoreFinished()
	func restoreWithError(error: Error)
}

protocol IPaymentNotifierRegistrator: AnyObject
{
	func register(_ listener: IPaymentListener)
}

protocol IPaymentNotifier: AnyObject
{
	func startObserving()
	func stopObserving()
}

final class PaymentNotifier: NSObject
{
	private var listeners = WeakThreadSafeSet<IPaymentListener>()
}

extension PaymentNotifier: IPaymentNotifierRegistrator
{
	func register(_ listener: IPaymentListener) {
		self.listeners.add(listener)
	}
}

extension PaymentNotifier: IPaymentNotifier
{
	func startObserving() {
		SKPaymentQueue.default().add(self)
	}

	func stopObserving() {
		SKPaymentQueue.default().remove(self)
	}
}

extension PaymentNotifier: SKPaymentTransactionObserver
{
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		self.listeners.forEach { listener in
			DispatchQueue.main.async {
				listener.updatedTransactions(transactions)
			}
		}
	}

	func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
		self.listeners.forEach { listener in
			DispatchQueue.main.async {
				listener.restoreFinished()
			}
		}
	}

	func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
		self.listeners.forEach { listener in
			DispatchQueue.main.async {
				listener.restoreWithError(error: error)
			}
		}
	}
}
