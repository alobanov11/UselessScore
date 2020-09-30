//
//  Created by Антон Лобанов on 05.07.2020.
//  Copyright (c) 2020 Антон Лобанов. All rights reserved.
//

import Foundation
import Networking
import PromiseKit

protocol IIncrementRepository: AnyObject
{
	func load() -> Promise<IncrementModel>
	func increment(with newValue: Int) -> Promise<IncrementModel>
}

final class IncrementRepository
{
	private var lastRequestID: String?

	private let netwokring: Networking
	private let lastIncrementStorage: ILastIncrementStorage

	init(
		netwokring: Networking,
		lastIncrementStorage: ILastIncrementStorage
	) {
		self.netwokring = netwokring
		self.lastIncrementStorage = lastIncrementStorage
	}
}

extension IncrementRepository: IIncrementRepository
{
	func load() -> Promise<IncrementModel> {
		self.cancelLastRequestIfNeeded()

		return Promise { seal in
			self.lastRequestID = self.netwokring.get("load") { [weak self] result in
				switch result {
				case .success(let response):
					DispatchQueue.global(qos: .userInteractive).async {
						self?.mapIncrementModelFromResponse(response)
							.done { model in
								DispatchQueue.main.async {
									self?.lastIncrementStorage.value = model
									seal.fulfill(model)
								}
							}
							.catch { error in
								DispatchQueue.main.async {
									seal.reject(error)
								}
							}
					}
				case .failure(let response):
					seal.reject(response.error)
				}
			}
		}
	}

	func increment(with newValue: Int) -> Promise<IncrementModel> {
		let score = (newValue - (self.lastIncrementStorage.value?.counters.total ?? 0))
		let part = FormDataPart(data: Data("\(score)".encoded.utf8), parameterName: "score")

		self.cancelLastRequestIfNeeded()

		return Promise { seal in
			self.lastRequestID = self.netwokring.post("increment", parts: [part]) { [weak self] result in
				switch result {
				case .success(let response):
					DispatchQueue.global(qos: .userInteractive).async {
						self?.mapIncrementModelFromResponse(response)
							.done { model in
								DispatchQueue.main.async {
									self?.lastIncrementStorage.value = model
									seal.fulfill(model)
								}
							}
							.catch { error in
								DispatchQueue.main.async {
									seal.reject(error)
								}
							}
					}
				case .failure(let response):
					seal.reject(response.error)
				}
			}
		}
	}
}

private extension IncrementRepository
{
	func mapIncrementModelFromResponse(_ response: SuccessJSONResponse) -> Promise<IncrementModel> {
		return Promise { seal in
			do {
				let model = try response.map(IncrementModel.self)
				seal.fulfill(model)
			}
			catch {
				seal.reject(AppError.cantDecode)
			}
		}
	}

	func cancelLastRequestIfNeeded() {
		guard let requestID = self.lastRequestID else { return }
		self.netwokring.cancel(requestID)
	}
}
