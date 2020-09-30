//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso
import StoreKit

enum CounterModule: ScreenModule
{
	static var defaultInitialState: State {
		return State()
	}

	static func createScreen(with store: CounterStore) -> Screen {
		let controller = CounterViewController(store: store.asViewStore())
		return Screen(store, controller)
	}

	enum Action: Equatable
	{
		case viewDidLoad
		case didTapIncrement
		case didTapUpgrade
		case didReload
		case didReloadMultipler
		case setMultiplierLoading(Bool)
		case setError(AppError)
		case setInfo(String)
	}

	enum Output: Equatable
	{
		case buyProduct(SKProduct)
	}

	struct State: Equatable
	{
		var isLoading = false
		var top: Int = 0
		var total: Int = 0
		var me: Int = 0
		var position: Int = 1
		var numberOfParticipants: Int = 1
		var initialDate = Date()
		var error: AppError?
		var info: String?
		var multiplier: String = "-"
		var isMultiplierLast: Bool = false
		var isMultiplierLoading = false
	}
}

extension CounterModule.State
{
	mutating func fill(with otherState: CounterModule.State) {
		self.isLoading = otherState.isLoading
		self.top = otherState.top
		self.total = otherState.total
		self.me = otherState.me
		self.position = otherState.position
		self.numberOfParticipants = otherState.numberOfParticipants
		self.initialDate = otherState.initialDate
		self.error = otherState.error
		self.info = otherState.info
		self.multiplier = otherState.multiplier
		self.isMultiplierLast = otherState.isMultiplierLast
		self.isMultiplierLoading = otherState.isMultiplierLoading
	}
}
