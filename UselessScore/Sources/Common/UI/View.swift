//
//  Created by Лобанов Антон on 14/11/2019.
//  Copyright © 2019 Лобанов Антон. All rights reserved.
//

import UIKit

// swiftlint:disable required_final
open class View: UIView
{
	var cornerRadius: CGFloat?
	var shadow: Shadow?

	private var shadowLayer: CAShapeLayer?
	private var shadowBackgroundColor: UIColor?

	public init() {
		super.init(frame: .zero)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		if let cornerRadius = self.cornerRadius, let shadow = self.shadow {
			self.applyCornerRadiusWithShadow(cornerRadius, shadow: shadow)
		}
		else if let cornerRadius = self.cornerRadius {
			self.applyCornerRadius(cornerRadius)
		}
		else if let shadow = self.shadow {
			self.applyShadow(shadow)
		}
	}

	@available(*, unavailable)
	required public init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension View
{
	func applyShadow(_ shadow: Shadow) {
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0).cgPath
		self.layer.shadowColor = shadow.shadowColor?.cgColor
		self.layer.shadowOffset = shadow.shadowOffset
		self.layer.shadowOpacity = shadow.shadowOpacity
		self.layer.shadowRadius = shadow.shadowRadius
	}

	func applyCornerRadiusWithShadow(_ cornerRadius: CGFloat, shadow: Shadow) {
		guard self.shadowLayer == nil else { return }
		let shadowLayer = CAShapeLayer()

		shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath

		if self.shadowBackgroundColor == nil {
			self.shadowBackgroundColor = self.backgroundColor
			self.backgroundColor = .clear
			shadowLayer.fillColor = self.backgroundColor?.cgColor
		}

		shadowLayer.fillColor = self.shadowBackgroundColor?.cgColor

		shadowLayer.shadowColor = shadow.shadowColor?.cgColor
		shadowLayer.shadowPath = shadowLayer.path
		shadowLayer.shadowOffset = shadow.shadowOffset
		shadowLayer.shadowOpacity = shadow.shadowOpacity
		shadowLayer.shadowRadius = shadow.shadowRadius

		self.layer.insertSublayer(shadowLayer, at: 0)
		self.shadowLayer = shadowLayer
	}

	func applyCornerRadius(_ cornerRadius: CGFloat) {
		self.layer.cornerRadius = cornerRadius
		self.layer.masksToBounds = true
	}
}
