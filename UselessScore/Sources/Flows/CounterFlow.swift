//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso
import StoreKit

final class CounterFlow: Flow<NoOutputFlow>
{
	private let flowFactory: FlowFactory
	private let screenFactory: ScreenFactory

	init(flowFactory: FlowFactory, screenFactory: ScreenFactory) {
		self.flowFactory = flowFactory
		self.screenFactory = screenFactory
	}

	override func createInitialController() -> UIViewController {
		let screen = self.screenFactory.makeCounter()
		screen.observeOutput { [weak self] output in
			switch output {
			case .buyProduct(let product): self?.showBuyProduct(with: product, for: screen)
			}
		}
		return screen.controller
	}
}

// MARK: - Show modules
private extension CounterFlow
{
	func showBuyProduct(with product: SKProduct, for screen: AnyScreen<CounterModule>) {
		let buyProductScreen = self.screenFactory.makeBuyProduct(product)
		buyProductScreen.observeOutput { output in
			switch output {
			case .didComplete:
				screen.store.dispatchActions([
					.setInfo(R.string.localizable.counterMultiplierSuccessBuy()),
					.didReloadMultipler,
				])
			case .didFailed(let error):
				screen.store.dispatchAction(.setError(error))
			case .didFinish:
				break
			}
			screen.store.dispatchAction(.setMultiplierLoading(false))
		}
		buyProductScreen.place(with: nextPresentedInFlow)
	}
}
