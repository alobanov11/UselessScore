//
//  Created by Антон Лобанов on 29.09.2020.
//

import UIKit
import NVActivityIndicatorView

extension UIButton
{
	private var indicator: NVActivityIndicatorView {
		let indicator = NVActivityIndicatorView(frame: .zero,
												type: .lineScale,
												color: R.color.accent(),
												padding: .some(15))
		return indicator
	}

	func startLoading() {
		let indicator = self.indicator
		self.isEnabled = false
		self.titleLabel?.alpha = 0
		self.addSubview(indicator)
		indicator.pin {
			$0.center.equalToSuperview()
		}
		indicator.startAnimating()
	}

	func stopLoading() {
		self.subviews.filter { $0 is NVActivityIndicatorView }.forEach { $0.removeFromSuperview() }
		self.titleLabel?.alpha = 1
		self.isEnabled = true
	}
}
