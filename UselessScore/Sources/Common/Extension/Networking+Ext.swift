//
//  Created by Антон Лобанов on 23.07.2020.
//  Copyright © 2020 Антон Лобанов. All rights reserved.
//

import Foundation
import Networking

extension SuccessJSONResponse
{
	func map<T: Codable>(_ model: T.Type) throws -> T {
		let decoder = JSONDecoder()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		return try decoder.decode(model.self, from: self.data)
	}
}

extension FailureJSONResponse
{
	var error: AppError {
		let json = self.dictionaryBody
		guard let errorCode = json["code"] as? Int else { return .unknown }
		return AppError(rawValue: errorCode) ?? AppError.serverError
	}
}
