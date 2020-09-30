//
//  Created by Антон Лобанов on 29.09.2020.
//

import StoreKit
import PromiseKit

protocol IIncrementUseCase: AnyObject
{
	var multiplier: String { get } // 1x .. 2x or 4x

	func increment(_ counters: IncrementModel.Counters) -> IncrementModel.Counters
	func upgrade() -> Promise<SKProduct?>
}

final class IncrementUseCase
{
	private enum Constants
	{
		static let defaultMultiplier = 1
		static let suffix = "x"
		static let prefix = "upgrade"
		static let delimeter = "."

		static func nextMultiplier(for multiplier: Int) -> Int {
			return multiplier * 2
		}
	}

	private var multiplierNumber: Int {
		guard let multiplier = self.purchaseRepository
			.purchasedProducts
			.filter({ $0.range(of: Constants.prefix) != nil })
			.compactMap({ $0.components(separatedBy: Constants.delimeter).last })
			.compactMap({ $0.components(separatedBy: Constants.suffix).compactMap { Int($0) }.first })
			.max()
		else {
			return Constants.defaultMultiplier
		}
		return multiplier
	}

	private let purchaseRepository: IPurchaseRepository

	init(purchaseRepository: IPurchaseRepository) {
		self.purchaseRepository = purchaseRepository
	}
}

extension IncrementUseCase: IIncrementUseCase
{
	var multiplier: String {
		return ["\(self.multiplierNumber)", Constants.suffix].joined()
	}

	func increment(_ counters: IncrementModel.Counters) -> IncrementModel.Counters {
		let total = counters.total + (1 * self.multiplierNumber)
		let me = counters.me + (1 * self.multiplierNumber)
		var top = counters.top
		if me > top {
			top = me
		}
		return .init(top: top, total: total, me: me)
	}

	func upgrade() -> Promise<SKProduct?> {
		return Promise { seal in
			self.purchaseRepository.fetchProducts()
				.done { products in
					var neededProduct: SKProduct?

					products.forEach { product in
						let id = product.productIdentifier
						guard
							id.range(of: Constants.prefix) != nil,
							let multplierString = id.components(separatedBy: Constants.delimeter).last,
							let multplier = multplierString.components(separatedBy: Constants.suffix).compactMap({ Int($0) }).first,
							Constants.nextMultiplier(for: self.multiplierNumber) == multplier
						else { return }
						neededProduct = product
					}

					seal.fulfill(neededProduct)
				}
				.catch { seal.reject($0) }
		}
	}
}
