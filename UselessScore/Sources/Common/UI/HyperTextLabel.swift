//
//  Created by Антон Лобанов on 20.05.2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import UIKit
import ActiveLabel

final class HyperTextLabel: View
{
	private lazy var activeLabel = ActiveLabel(frame: .zero)

	init(text: String,
		 links: [String: URL] = [:],
		 textColor: UIColor? = .white,
		 textFont: UIFont? = .default,
		 textAlignment: NSTextAlignment = .left,
		 linkColor: UIColor = .link,
		 numberOfLines: Int = 0,
		 didSelectUrl: @escaping (URL) -> Void) {

		super.init()

		let customTypes = links.map { ActiveType.custom(pattern: "\\s\($0.key)\\b") }

		self.activeLabel.font = textFont
		self.activeLabel.numberOfLines = numberOfLines
		self.activeLabel.enabledTypes = customTypes
		self.activeLabel.textColor = textColor
		self.activeLabel.customColor = Dictionary(uniqueKeysWithValues: customTypes.map { ($0, linkColor) })
		self.activeLabel.textAlignment = textAlignment

		customTypes.forEach {
			self.activeLabel.handleCustomTap(for: $0) {
				guard let url = links[$0] else { return }
				didSelectUrl(url)
			}
		}

		self.activeLabel.text = text

		self.addSubview(self.activeLabel)
		self.activeLabel.pinToSuperview()
	}
}
