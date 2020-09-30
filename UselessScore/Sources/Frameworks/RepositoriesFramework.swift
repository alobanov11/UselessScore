//
//  Created by Лобанов Антон on 01/01/2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import Networking
import DITranquillity

final class RepositoriesFramework: DIFramework
{
	static func load(container: DIContainer) {

		container.register { Networking(baseURL: AppConstants.apiURI) }
			.lifetime(.perContainer(.weak))

		container.register(IncrementRepository.init)
			.as(IIncrementRepository.self)
			.lifetime(.perContainer(.weak))

		container.register(PurchaseRepository.init)
			.as(IPurchaseRepository.self)
			.lifetime(.perContainer(.weak))
	}
}
