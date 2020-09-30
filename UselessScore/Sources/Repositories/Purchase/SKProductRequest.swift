//
//  Created by Антон Лобанов on 29.09.2020.
//

import StoreKit

final class SKProductRequest: NSObject, SKProductsRequestDelegate
{
	private var onSuccess: ((SKProductsResponse) -> Void)?
	private var onError: ((Error) -> Void)?
	private var request: SKProductsRequest?

	func start(
		with products: [String],
		onSuccess: @escaping (SKProductsResponse) -> Void,
		onError: @escaping (Error) -> Void
	) {
		self.onSuccess = onSuccess
		self.onError = onError
		self.request = SKProductsRequest(productIdentifiers: Set(products))
		self.request?.delegate = self
		self.request?.start()
	}

	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		self.onSuccess?(response)
	}

	func request(_ request: SKRequest, didFailWithError error: Error) {
		self.onError?(error)
	}
}
