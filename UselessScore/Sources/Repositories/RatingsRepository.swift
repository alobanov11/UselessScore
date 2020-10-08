//
//  Created by Антон Лобанов on 08.10.2020.
//  Copyright (c) 2020 Anton Lobanov. All rights reserved.
//

import Foundation
import PromiseKit
import Networking

protocol IRatingsRepository: AnyObject
{
	func ratings() -> Promise<[RatingUser]>
}

final class RatingsRepository
{
	private var lastRequestID: String?

	private let netwokring: Networking

	init(
		netwokring: Networking
	) {
		self.netwokring = netwokring
	}
}

extension RatingsRepository: IRatingsRepository
{
	func ratings() -> Promise<[RatingUser]> {
		self.netwokring.cancel(self.lastRequestID)
		return Promise { seal in
			self.lastRequestID = self.netwokring.get("ratings") { result in
				switch result {
				case .success(let response):
					DispatchQueue.global(qos: .userInteractive).async {
						do {
							let model = try response.map([RatingUser].self)
							DispatchQueue.main.async { seal.fulfill(model) }
						}
						catch {
							DispatchQueue.main.async { seal.reject(AppError.cantDecode) }
						}
					}
				case .failure(let response):
					seal.reject(response.error)
				}
			}
		}
	}
}

private extension RatingsRepository
{
}
