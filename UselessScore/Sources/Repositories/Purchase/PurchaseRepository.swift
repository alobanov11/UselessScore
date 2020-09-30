//
//  Created by Антон Лобанов on 29.09.2020.
//

import StoreKit
import PromiseKit

protocol IPurchaseRepository: AnyObject
{
	var purchasedProducts: [String] { get }
	var canBuy: Bool { get }

	func fetchProducts() -> Promise<[SKProduct]>
	func buyProduct(_ product: SKProduct) -> Promise<Void>
	func restore() -> Promise<Void>
}

final class PurchaseRepository: NSObject
{
	private var productsRequest: SKProductRequest?
	private var transactionRequest: SKTransactionRequest?
	private var restoreTransactionRequest: SKRestoreTransactionRequest?

	private let products = AppConstants.products
	private let purchasedProductsStorage: IPurchasedProductsStorage
	private let paymentNotifierRegistrator: IPaymentNotifierRegistrator

	init(
		purchasedProductsStorage: IPurchasedProductsStorage,
		paymentNotifierRegistrator: IPaymentNotifierRegistrator
	) {
		self.purchasedProductsStorage = purchasedProductsStorage
		self.paymentNotifierRegistrator = paymentNotifierRegistrator
	}
}

extension PurchaseRepository: IPurchaseRepository
{
	var purchasedProducts: [String] {
		self.purchasedProductsStorage.value
	}

	var canBuy: Bool {
		SKPaymentQueue.canMakePayments()
	}

	func fetchProducts() -> Promise<[SKProduct]> {
		return Promise { seal in
			guard self.products.isEmpty == false else {
				seal.reject(AppError.noProductIDsFound)
				return
			}
			self.productsRequest = SKProductRequest()
			self.productsRequest?.start(
				with: self.products,
				onSuccess: { [weak self] response in
					self?.productsRequest = nil
					guard response.products.isEmpty == false else {
						seal.reject(AppError.noProductsFound)
						return
					}
					seal.fulfill(response.products)
				},
				onError: { [weak self] _ in
					self?.productsRequest = nil
					seal.reject(AppError.productRequestFailed)
				}
			)
		}
	}

	func buyProduct(_ product: SKProduct) -> Promise<Void> {
		return Promise { seal in
			let transactionRequest = SKTransactionRequest()
			self.paymentNotifierRegistrator.register(transactionRequest)
			self.transactionRequest = transactionRequest
			self.transactionRequest?.start(
				with: product,
				onSuccess: { [weak self] in
					self?.transactionRequest = nil
					self?.purchasedProductsStorage.value.append(product.productIdentifier)
					seal.fulfill(())
				},
				onError: { [weak self] in
					self?.transactionRequest = nil
					seal.reject($0)
				}
			)
		}
	}

	func restore() -> Promise<Void> {
		return Promise { seal in
			let restoreTransactionRequest = SKRestoreTransactionRequest()
			self.paymentNotifierRegistrator.register(restoreTransactionRequest)
			self.restoreTransactionRequest = restoreTransactionRequest
			self.restoreTransactionRequest?.start(
				onSuccess: { [weak self] products in
					self?.restoreTransactionRequest = nil
					guard products.isEmpty == false && products.count != self?.purchasedProductsStorage.value.count else {
						seal.reject(AppError.noProductsFound)
						return
					}
					products.forEach { product in
						self?.purchasedProductsStorage.value.append(product)
					}
					seal.fulfill(())
				},
				onError: { [weak self] in
					self?.restoreTransactionRequest = nil
					seal.reject($0)
				}
			)
		}
	}
}
