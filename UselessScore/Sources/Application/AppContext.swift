//
//  Created by Антон Лобанов on 20.06.2020.
//  Copyright © 2020 Антон Лобанов. All rights reserved.
//

import UIKit
import DITranquillity
import Lasso
import Siren
import Networking

final class AppContext
{
	private lazy var container: DIContainer = {
		let container = DIContainer()
		let frameworks: [DIFramework.Type] = [
			RootFramework.self,
			RepositoriesFramework.self,
			NotifiersFramework.self,
			StoragesFramework.self,
			UseCasesFramework.self,
		]
		frameworks.forEach { container.append(framework: $0) }
		return container
	}()

	private lazy var networking: Networking = *self.container
	private lazy var rootFlow: IRootFlow = *self.container
	private lazy var paymentNotifier: IPaymentNotifier = *self.container
}

extension AppContext
{
	func launch(with options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		Siren.shared.wail()
		self.paymentNotifier.startObserving()
		self.setupNetworking()
		self.rootFlow.start()
		return true
	}

	func willTerminate() {
		self.paymentNotifier.stopObserving()
	}
}

private extension AppContext
{
	func setupNetworking() {
		self.networking.setAuthorizationHeader(token: AppConstants.deviceID.encoded)
		self.networking.headerFields = [
			"U-Device-Name": AppConstants.deviceName.base64,
		]
	}
}
