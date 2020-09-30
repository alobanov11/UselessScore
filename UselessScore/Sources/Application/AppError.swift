//
//  Created by Антон Лобанов on 28.06.2020.
//  Copyright © 2020 Антон Лобанов. All rights reserved.
//

import Foundation

enum AppError: Int, Error, Equatable
{
	// Common
	case serverError
	case unknown
	case cantDecode

	// Purchase
	case cantBuy
	case cantRestore
	case paymentWasCancelled
	case noProductIDsFound
	case noProductsFound
	case productRequestFailed
}

extension AppError: LocalizedError
{
	var localizedDescription: String {
		switch self {
		case .serverError: return R.string.localizable.errorServerError()
		case .unknown: return R.string.localizable.errorUnknown()
		case .cantDecode: return R.string.localizable.errorCantDecode()

		case .cantBuy: return R.string.localizable.errorCantBuy()
		case .cantRestore: return R.string.localizable.errorCantRestore()
		case .paymentWasCancelled: return R.string.localizable.errorPaymentWasCancelled()
		case .noProductIDsFound: return R.string.localizable.errorNoProductIDsFound()
		case .noProductsFound: return R.string.localizable.errorNoProductsFound()
		case .productRequestFailed: return R.string.localizable.errorProductRequestFailed()
		}
	}
}

extension Error
{
	var asAppError: AppError {
		guard let error = self as? AppError else {
			return .unknown
		}
		return error
	}
}
