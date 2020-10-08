//
//  Created by Антон Лобанов on 20.09.2020.
//

import Lasso

final class RatingStore: LassoStore<RatingModule>
{
	private let ratingsRepository: IRatingsRepository

	required init(
		with initialState: LassoStore<RatingModule>.State,
		ratingsRepository: IRatingsRepository
	) {
		self.ratingsRepository = ratingsRepository
		super.init(with: initialState)
	}

	@available(*, unavailable)
	required init(with initialState: LassoStore<RatingModule>.State) {
		fatalError("init(with:) has not been implemented")
	}

	override func handleAction(_ action: LassoStore<RatingModule>.Action) {
		switch action {
		case .viewDidLoad, .didReload: self.load()
		case .didTapBack: self.dispatchOutput(.back)
		case .setError(let error): self.setError(error)
		}
	}
}

// MARK: - Actions
private extension RatingStore
{
	func load() {
		self.setLoading(true)
		self.ratingsRepository.ratings()
			.done { self.setUsers($0) }
			.catch { self.setError($0.asAppError) }
			.finally { self.setLoading(false) }
	}
}

// MARK: - Helpers for update
private extension RatingStore
{
	func setLoading(_ enabled: Bool) {
		update { $0.isLoading = enabled }
	}

	func setUsers(_ users: [RatingUser]) {
		update { state in
			state.users = users
		}
	}

	func setError(_ error: AppError?) {
		update { state in
			state.error = error
		}
	}
}
