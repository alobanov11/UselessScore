//
//  Created by Антон Лобанов on 20.05.2020.
//  Copyright © 2020 Лобанов Антон. All rights reserved.
//

import UIKit

// swiftlint:disable force_unwrapping force_cast
enum AppConstants
{
	private static let constants = NSDictionary(contentsOf: R.file.constantsPlist()!)!

	static let termsAndConditionsURL = URL(string: Self.constants["Terms and Conditions URL"] as! String)!
	static let privacyPolicyURL = URL(string: Self.constants["Privacy Policy URL"] as! String)!
	static let settingsURL = URL(string: UIApplication.openSettingsURLString)!
	static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
	static let apiURI = Self.constants["API URL"] as! String
	static let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
	static let salt = Self.constants["Salt"] as! String
	static let saltDelimeter = Self.constants["Salt delimeter"] as! Int
	static let products = Self.constants["Products"] as! [String]
}

extension AppConstants
{
	enum LocalKey
	{
		static let LastIncrement = "LastIncrement"
		static let PurchsedProducts = "PurchsedProducts"

		// Эти ключи не будут удалены при очистки стораджа
		static let RequiredKeys: [String] = []
	}
}
