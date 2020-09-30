//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate
{
	private lazy var appContext = AppContext()

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		self.appContext.launch(with: launchOptions)
	}

	func applicationWillTerminate(_ application: UIApplication) {
		self.appContext.willTerminate()
	}
}
