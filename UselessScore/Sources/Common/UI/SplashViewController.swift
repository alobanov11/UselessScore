//
//  Created by Антон Лобанов on 08.10.2020.
//

import UIKit

final class SplashViewController: ViewController
{
	private var complition: (() -> Void)?
	private var timer: Timer?

	private lazy var splashViewController: UIViewController? = {
		let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
		return storyboard.instantiateInitialViewController()
	}()

	deinit {
		self.timer?.invalidate()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let childVC = self.splashViewController else { return }

		self.addChild(childVC)
		self.view.addSubview(childVC.view)
		childVC.didMove(toParent: self)
		childVC.view.pinToSuperview()
	}

	func executeBlock(delay: TimeInterval, complition: @escaping () -> Void) {
		self.complition = complition
		self.setTimer(with: delay)
	}

	private func setTimer(with delay: TimeInterval) {
		guard self.complition != nil else { return }
		self.timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
			self?.complition?()
		}
	}
}
