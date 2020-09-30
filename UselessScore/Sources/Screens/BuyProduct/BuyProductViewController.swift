//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso

final class BuyProductViewController: UIAlertController
{
	var store: BuyProductModule.ViewStore?

	func addActions() {
		guard let store = self.store else { return }

		let buyAction = UIAlertAction(
			title: R.string.localizable.commonBuy(store.state.price),
			style: .default,
			handler: { [weak store] _ in store?.dispatchAction(.didTapBuy) }
		)

		let restoreAction = UIAlertAction(
			title: R.string.localizable.commonRestore(),
			style: .default,
			handler: { [weak store] _ in store?.dispatchAction(.didTapRestore) }
		)

		let cancelAction = UIAlertAction(
			title: R.string.localizable.commonCancel(),
			style: .cancel,
			handler: { [weak store] _ in store?.dispatchAction(.didTapCancel) }
		)

		self.addAction(buyAction)
		self.addAction(restoreAction)
		self.addAction(cancelAction)
	}
}

final class BuyProductView: LassoView
{
	let store: BuyProductModule.ViewStore
	let alert: BuyProductViewController

	init(store: BuyProductModule.ViewStore) {
		self.store = store
		self.alert = BuyProductViewController(
			title: self.store.state.title,
			message: self.store.state.message,
			preferredStyle: .alert
		)
		self.alert.store = store
		self.alert.addActions()
	}
}
