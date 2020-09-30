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
	private let flowFactory: FlowFactory
	private let window: UIWindow

	init(window: UIWindow, flowFactory: FlowFactory) {
		self.flowFactory = flowFactory
		self.window = window
		self.window.makeKeyAndVisible()
	}
}

extension RootFlow: IRootFlow
{
	func start() {
		self.runMainFlow()
	}
}

private extension RootFlow
{
	func runMainFlow() {
		self.flowFactory.makeCounter().start(with: root(of: self.window))
	}
}
