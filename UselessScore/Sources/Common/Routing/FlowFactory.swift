//
//  Created by Антон Лобанов on 20.09.2020.
//

import DITranquillity
import Lasso
import StoreKit

final class FlowFactory
{
	private let container: DIContainer

	init(container: DIContainer) {
		self.container = container
	}

	func makeMain() -> MainFlow {
		return MainFlow(
			flowFactory: self,
			screenFactory: *self.container
		)
	}

	func makeCounter() -> CounterFlow {
		return CounterFlow(
			flowFactory: self,
			screenFactory: *self.container
		)
	}
}
