//
//  Created by Антон Лобанов on 07.10.2020.
//

import UIKit
import Lasso

final class MainViewController: UIPageViewController, LassoView
{
	let store: MainModule.ViewStore

	init(store: MainModule.ViewStore) {
		self.store = store
		super.init(
			transitionStyle: .scroll,
			navigationOrientation: .horizontal,
			options: nil
		)
		self.delegate = self
		self.dataSource = self
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = R.color.background()
		self.setUpBindings()
	}
}

extension MainViewController: UIPageViewControllerDataSource
{
	func pageViewController(
		_ pageViewController: UIPageViewController,
		viewControllerBefore viewController: UIViewController
	) -> UIViewController? {
		guard let index = self.state.controllers.firstIndex(of: viewController), index > 0 else { return nil }
		return self.state.controllers[index - 1]
	}

	func pageViewController(
		_ pageViewController: UIPageViewController,
		viewControllerAfter viewController: UIViewController
	) -> UIViewController? {
		guard let index = self.state.controllers.firstIndex(of: viewController),
			  index < self.state.controllers.count - 1
		else {
			return nil
		}
		return self.state.controllers[index + 1]
	}

	func pageViewController(
		_ pageViewController: UIPageViewController,
		didFinishAnimating finished: Bool,
		previousViewControllers: [UIViewController],
		transitionCompleted completed: Bool
	) {
		guard completed,
			  let viewController = self.viewControllers?.first,
			  let index = self.state.controllers.firstIndex(of: viewController)
		else {
			return
		}
		self.dispatchAction(.setCurrentIndex(index))
	}
}

extension MainViewController: UIPageViewControllerDelegate
{
}

private extension MainViewController
{
	func setUpBindings() {
		self.store.observeState(\.currentIndex) { [weak self] currentIndex in
			guard let self = self,
				  let currentIndex = currentIndex,
				  let viewController = self.viewControllers?.first,
				  let index = self.state.controllers.firstIndex(of: viewController),
				  index != currentIndex,
				  currentIndex < self.state.controllers.count
			else {
				return
			}
			self.setViewControllers(
				[self.state.controllers[currentIndex]],
				direction: currentIndex < index ? .reverse : .forward,
				animated: true,
				completion: nil
			)
		}

		self.store.observeState(\.controllers) { [weak self] controllers in
			guard let controller = controllers.first else { return }
			self?.setViewControllers([controller], direction: .forward, animated: false, completion: nil)
		}
	}
}
