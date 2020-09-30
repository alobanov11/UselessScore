//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso
import StoreKit

enum BuyProductModule: ScreenModule
{
	static var defaultInitialState: State {
		return State()
	}

	static func createScreen(with store: BuyProductStore) -> Screen {
		let controller = BuyProductView(store: store.asViewStore())
		return Screen(store, controller.alert)
	}

	enum Action: Equatable
	{
		case didTapBuy
		case didTapRestore
		case didTapCancel
	}

	enum Output: Equatable
	{
		case didComplete
		case didFailed(AppError)
		case didFinish
	}

	struct State: Equatable
	{
		var title: String = ""
		var message: String = ""
		var price: String = ""
	}
}

extension BuyProductModule.State
{
	mutating func fill(with otherState: BuyProductModule.State) {
		self.title = otherState.title
		self.message = otherState.message
		self.price = otherState.price
	}
}
