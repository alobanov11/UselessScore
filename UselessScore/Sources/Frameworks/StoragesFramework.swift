//
//  Created by Лобанов Антон on 01/01/2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import DITranquillity

final class StoragesFramework: DIFramework
{
	static func load(container: DIContainer) {

		container.register(KeyValueStorage.init)
			.as(IKeyValueStorage.self)
			.as(IClearKeyValueStorage.self)
			.lifetime(.perContainer(.weak))

		container.register { LastIncrementStorage(localStorage: $0, key: AppConstants.LocalKey.LastIncrement) }
			.as(ILastIncrementStorage.self)
			.lifetime(.perContainer(.weak))

		container.register { PurchasedProductsStorage(localStorage: $0, key: AppConstants.LocalKey.PurchsedProducts) }
			.as(IPurchasedProductsStorage.self)
			.lifetime(.perContainer(.weak))
	}
}
