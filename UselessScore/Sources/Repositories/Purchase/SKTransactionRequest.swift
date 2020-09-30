//
//  Created by Антон Лобанов on 29.09.2020.
//

import StoreKit

final class SKTransactionRequest: IPaymentListener
{
	private var onSuccess: (() -> Void)?
	private var onError: ((Error) -> Void)?
	private var product: SKProduct?

	func start(
		with product: SKProduct,
		onSuccess: @escaping () -> Void,
		onError: @escaping (Error) -> Void
	) {
		self.onSuccess = onSuccess
		self.onError = onError
		self.product = product
		let payment = SKPayment(product: product)
		SKPaymentQueue.default().add(payment)
	}

	func updatedTransactions(_ transactions: [SKPaymentTransaction]) {
		transactions.forEach { transaction in
			guard self.product?.productIdentifier == transaction.payment.productIdentifier else { return }
			switch transaction.transactionState {

			case .purchased:
				self.onSuccess?()
				SKPaymentQueue.default().finishTransaction(transaction)

			case .failed:
				if let error = transaction.error as? SKError {
					self.onError?(error)
				}
				SKPaymentQueue.default().finishTransaction(transaction)

			default: break
			}
		}
	}

	func restoreFinished() {
		// do nothing
	}

	func restoreWithError(error: Error) {
		// do nothing
	}
}
