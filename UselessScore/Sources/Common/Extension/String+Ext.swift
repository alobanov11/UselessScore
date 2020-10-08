//
//  Created by Антон Лобанов on 22.09.2020.
//

import Foundation

extension String
{
	var base64: String {
		return Data(self.utf8).base64EncodedString()
	}

	var encoded: String {
		let salt = AppConstants.salt
		let delimeter = AppConstants.saltDelimeter
		let firstEncoded = "\(self)\(salt)".base64
		let secondEncoded = "\(firstEncoded)\(salt)".base64
		let firstHalf = secondEncoded.prefix(secondEncoded.count / delimeter)
		let secondHalf = secondEncoded.suffix(secondEncoded.count / delimeter)
		let encoded = "\(secondHalf)\(firstHalf)\(salt)".base64
		return encoded
	}
}
