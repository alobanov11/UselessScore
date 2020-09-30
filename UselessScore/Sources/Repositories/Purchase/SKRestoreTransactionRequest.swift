//
//  Created by Антон Лобанов on 29.09.2020.
//

import StoreKit

final class SKRestoreTransactionRequest: IPaymentListener
{
	private var onSuccess: (([String]) -> Void)?
	private var onError: ((Error) -> Void)?
	private var products = [String]()

	func start(
		onSuccess: @escaping ([String]) -> Void,
		onError: @escaping (Error) -> Void
	) {
		self.onSuccess = onSuccess
		self.onError = onError
		SKPaymentQueue.default().restoreCompletedTransactions()
	}

	func updatedTransactions(_ transactions: [SKPaymentTransaction]) {
		transactions.forEach { transaction in
			switch transaction.transactionState {
			case .restored: SKPaymentQueue.default().finishTransaction(transaction)
			default: break
			}
		}
		self.products = transactions.map { $0.payment.productIdentifier }
	}

	func restoreFinished() {
		self.onSuccess?(self.products)
	}

	func restoreWithError(error: Error) {
		self.onError?(error)
	}
}
