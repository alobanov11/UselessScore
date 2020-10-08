//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso
import StoreKit

enum RatingModule: ScreenModule
{
	static var defaultInitialState: State {
		return State()
	}

	static func createScreen(with store: RatingStore) -> Screen {
		let controller = RatingViewController(store: store.asViewStore())
		return Screen(store, controller)
	}

	enum Action: Equatable
	{
		case viewDidLoad
		case didReload
		case didTapBack
		case setError(AppError)
	}

	enum Output: Equatable
	{
		case back
	}

	struct State: Equatable
	{
		var isLoading = false
		var users: [RatingUser] = []
		var error: AppError?
	}
}

extension RatingModule.State
{
	mutating func fill(with otherState: RatingModule.State) {
		self.isLoading = otherState.isLoading
		self.users = otherState.users
		self.error = otherState.error
	}
}
