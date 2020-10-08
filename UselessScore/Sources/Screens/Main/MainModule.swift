//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso
import StoreKit

enum MainModule: ScreenModule
{
	static var defaultInitialState: State {
		return State()
	}

	static func createScreen(with store: MainStore) -> Screen {
		let controller = MainViewController(store: store.asViewStore())
		return Screen(store, controller)
	}

	enum Action: Equatable
	{
		case setCurrentIndex(Int)
		case setControllers([UIViewController])
	}

	enum Output: Equatable
	{
	}

	struct State: Equatable
	{
		var currentIndex: Int?
		var controllers: [UIViewController] = []
	}
}

extension MainModule.State
{
	mutating func fill(with otherState: MainModule.State) {
		self.controllers = otherState.controllers
	}
}
