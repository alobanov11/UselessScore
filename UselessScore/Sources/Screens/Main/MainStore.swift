//
//  Created by Антон Лобанов on 20.09.2020.
//

import Lasso

final class MainStore: LassoStore<MainModule>
{
	required init() {
		super.init(with: MainModule.defaultInitialState)
	}

	@available(*, unavailable)
	required init(with initialState: LassoStore<MainModule>.State) {
		fatalError("init(with:) has not been implemented")
	}

	override func handleAction(_ action: LassoStore<MainModule>.Action) {
		switch action {
		case .setCurrentIndex(let index):
			update { state in
				state.currentIndex = index
			}

		case .setControllers(let controllers):
			update { state in
				state.controllers = controllers
			}
		}
	}
}

// MARK: - Actions
private extension MainStore
{
}

// MARK: - Helpers for update
private extension MainStore
{
}
