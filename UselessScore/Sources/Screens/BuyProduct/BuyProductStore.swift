//
//  Created by Антон Лобанов on 20.09.2020.
//

import Lasso
import StoreKit

final class BuyProductStore: LassoStore<BuyProductModule>
{
	private let product: SKProduct
	private let purchaseRepository: IPurchaseRepository

	required init(
		product: SKProduct,
		purchaseRepository: IPurchaseRepository
	) {
		self.product = product
		self.purchaseRepository = purchaseRepository
		super.init(
			with: .init(
				title: product.localizedTitle,
				message: product.localizedDescription,
				price: product.formattedPrice ?? ""
			)
		)
	}

	@available(*, unavailable)
	required init(with initialState: LassoStore<BuyProductModule>.State) {
		fatalError("init(with:) has not been implemented")
	}

	override func handleAction(_ action: LassoStore<BuyProductModule>.Action) {
		switch action {
		case .didTapBuy: self.buy()
		case .didTapRestore: self.restore()
		case .didTapCancel: self.dispatchOutput(.didFinish)
		}
	}
}

// MARK: - Actions
private extension BuyProductStore
{
	func buy() {
		guard self.purchaseRepository.canBuy else {
			self.dispatchOutput(.didFailed(.cantBuy))
			return
		}
		self.purchaseRepository.buyProduct(self.product)
			.done { self.dispatchOutput(.didComplete) }
			.catch { self.dispatchOutput(.didFailed($0.asAppError)) }
	}

	func restore() {
		self.purchaseRepository.restore()
			.done { self.dispatchOutput(.didComplete) }
			.catch { self.dispatchOutput(.didFailed($0.asAppError)) }
	}
}
