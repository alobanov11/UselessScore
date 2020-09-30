//
//  Created by Антон Лобанов on 21.06.2020.
//  Copyright © 2020 Антон Лобанов. All rights reserved.
//

import UIKit

struct Shadow
{
	let shadowColor: UIColor?
	let shadowOffset: CGSize
	let shadowOpacity: Float
	let shadowRadius: CGFloat

	static let `default` = Shadow(shadowColor: R.color.secondaryBackground(),
								  shadowOffset: CGSize(width: 0.0, height: 1.0),
								  shadowOpacity: 0.1,
								  shadowRadius: 2)
}
