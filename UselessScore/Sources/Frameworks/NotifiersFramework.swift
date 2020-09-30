//
//  Created by Лобанов Антон on 01/01/2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import DITranquillity

final class NotifiersFramework: DIFramework
{
	static func load(container: DIContainer) {

		container.register(PaymentNotifier.init)
			.as(IPaymentListener.self)
			.as(IPaymentNotifierRegistrator.self)
			.as(IPaymentNotifier.self)
			.lifetime(.perContainer(.weak))
	}
}
