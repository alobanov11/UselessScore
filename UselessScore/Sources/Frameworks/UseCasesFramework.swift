//
//  Created by Лобанов Антон on 01/01/2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import DITranquillity

final class UseCasesFramework: DIFramework
{
	static func load(container: DIContainer) {

		container.register(IncrementUseCase.init)
			.as(IIncrementUseCase.self)
			.lifetime(.perContainer(.weak))
	}
}
