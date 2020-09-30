//
//  Created by Лобанов Антон on 24/11/2019.
//  Copyright © 2019 Лобанов Антон. All rights reserved.
//

import UIKit
import SnapKit

extension UIView
{
	var safeArea: ConstraintBasicAttributesDSL {
		#if swift(>=3.2)
			if #available(iOS 11.0, *) {
				return self.safeAreaLayoutGuide.snp
			}
			else {
				return self.snp
			}
		#else
			return self.snp
		#endif
	}

	func pin(_ configure: (_ maker: ConstraintMaker) -> Void) {
		self.snp.makeConstraints(configure)
	}

	func repin(_ configure: (_ maker: ConstraintMaker) -> Void) {
		self.snp.remakeConstraints(configure)
	}

	func addSubviews(_ views: [UIView]) {
		views.forEach { self.addSubview($0) }
	}

	func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: self.bounds,
								byRoundingCorners: corners,
								cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
}

// Сахар
extension UIView
{
	func pinToSuperviewSafeArea() {
		guard let superview = self.superview else {
			assertionFailure("Сначала нужно добавить вьюху")
			return
		}
		self.pin {
			$0.top.equalTo(superview.safeArea.top)
			$0.left.equalTo(superview.safeArea.left)
			$0.right.equalTo(superview.safeArea.right)
			$0.bottom.equalTo(superview.safeArea.bottom)
		}
	}

	func pinToSuperview() {
		self.pin { $0.edges.equalToSuperview() }
	}
}
