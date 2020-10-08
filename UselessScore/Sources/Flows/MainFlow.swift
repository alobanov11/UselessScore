//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso

final class MainFlow: Flow<NoOutputFlow>
{
	private let flowFactory: FlowFactory
	private let screenFactory: ScreenFactory

	init(flowFactory: FlowFactory, screenFactory: ScreenFactory) {
		self.flowFactory = flowFactory
		self.screenFactory = screenFactory
	}

	override func createInitialController() -> UIViewController {
		let mainScreen = self.screenFactory.makeMain()

		guard let pageController = mainScreen.controller as? UIPageViewController else {
			fatalError("MainViewController isn't UIPageViewController")
		}

		// Counter flow
		let counterFlow = self.flowFactory.makeCounter()
		counterFlow.observeOutput { output in
			switch output {
			case .showMenu: mainScreen.store.dispatchAction(.setCurrentIndex(1))
			}
		}
		counterFlow.start(with: nextPage(in: pageController))

		// Rating flow
		let ratingScreen = self.screenFactory.makeRating()
		ratingScreen.observeOutput { output in
			switch output {
			case .back: mainScreen.store.dispatchAction(.setCurrentIndex(0))
			}
		}
		ratingScreen.place(with: nextPage(in: pageController))

		// Compare flows
		mainScreen.store.dispatchAction(
			.setControllers(
				[
					counterFlow.initialController,
					ratingScreen.controller,
				].compactMap { $0 }
			)
		)

		return pageController
	}
}

// MARK: - Show modules
private extension MainFlow
{
}

// MARK: - Helpers
private extension MainFlow
{
}

final class SomeViewController: UIViewController
{
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .green
	}

	deinit {
		print(1)
	}
}
