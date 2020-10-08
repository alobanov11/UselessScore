//
//  Created by Антон Лобанов on 20.09.2020.
//

import DITranquillity
import Lasso
import StoreKit

final class ScreenFactory
{
	private let container: DIContainer

	init(container: DIContainer) {
		self.container = container
	}

	func makeMain() -> AnyScreen<MainModule> {
		let store = MainStore()
		let screen = MainModule.createScreen(with: store)
		return screen
	}

	func makeCounter() -> AnyScreen<CounterModule> {
		let store = CounterStore(
			with: CounterModule.defaultInitialState,
			incrementRepository: *self.container,
			incrementUseCase: *self.container,
			throttler: Throttler(delay: 1, queue: .main)
		)
		let screen = CounterModule.createScreen(with: store)
		return screen
	}

	func makeBuyProduct(_ product: SKProduct) -> AnyScreen<BuyProductModule> {
		let store = BuyProductStore(
			product: product,
			purchaseRepository: *self.container
		)
		let screen = BuyProductModule.createScreen(with: store)
		return screen
	}

	func makeRating() -> AnyScreen<RatingModule> {
		let store = RatingStore(
			with: RatingModule.defaultInitialState,
			ratingsRepository: *self.container
		)
		let screen = RatingModule.createScreen(with: store)
		return screen
	}
}
