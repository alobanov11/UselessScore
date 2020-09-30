//
//  Created by Антон Лобанов on 30.09.2020.
//

import Lasso

extension AnyViewStore
{
	func dispatchActions(_ viewActions: [ViewAction]) {
		viewActions.forEach { self.dispatchAction($0) }
	}
}
