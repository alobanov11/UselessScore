//
//  Created by Антон Лобанов on 29.09.2020.
//

import StoreKit

extension SKProduct
{
	var formattedPrice: String? {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = self.priceLocale
		return formatter.string(from: self.price)
	}
}
