//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso

protocol IRootFlow: AnyObject
{
	func start()
}

final class RootFlow
{
	private enum Constants
	{
		static let splashLive: TimeInterval = 1
	}

	private let window: UIWindow
	private let flowFactory: FlowFactory
	private let ratingsRepository: IRatingsRepository

	init(
		window: UIWindow,
		flowFactory: FlowFactory,
		ratingsRepository: IRatingsRepository
	) {
		self.window = window
		self.flowFactory = flowFactory
		self.ratingsRepository = ratingsRepository
		self.window.makeKeyAndVisible()
	}
}

extension RootFlow: IRootFlow
{
	func start() {
		self.runSplash()
	}
}

private extension RootFlow
{
	func runSplash() {
		_ = self.ratingsRepository.ratings()
		let splashViewController = SplashViewController()
		splashViewController.executeBlock(delay: Constants.splashLive) { [weak self] in
			self?.runMainFlow()
		}
		self.window.rootViewController = splashViewController
	}

	func runMainFlow() {
		self.flowFactory.makeMain().start(with: root(of: self.window))
	}
}
