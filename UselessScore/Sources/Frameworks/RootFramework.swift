//
//  Created by Лобанов Антон on 01/01/2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import UIKit
import DITranquillity

final class RootFramework: DIFramework
{
	static func load(container: DIContainer) {
		container.register { UIWindow(frame: UIScreen.main.bounds) }
			.lifetime(.perContainer(.strong))

		container.register(FlowFactory.init)
			.lifetime(.perContainer(.weak))

		container.register(ScreenFactory.init)
			.lifetime(.perContainer(.weak))

		container.register(RootFlow.init)
			.as(IRootFlow.self)
			.lifetime(.perContainer(.weak))
	}
}
