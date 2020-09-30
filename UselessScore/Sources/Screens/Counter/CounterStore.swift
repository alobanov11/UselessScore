//
//  Created by Антон Лобанов on 20.09.2020.
//

import Lasso

final class CounterStore: LassoStore<CounterModule>
{
	private let incrementRepository: IIncrementRepository
	private let incrementUseCase: IIncrementUseCase
	private let throttler: IThrottler

	required init(
		with initialState: LassoStore<CounterModule>.State,
		incrementRepository: IIncrementRepository,
		incrementUseCase: IIncrementUseCase,
		throttler: IThrottler
	) {
		self.incrementRepository = incrementRepository
		self.incrementUseCase = incrementUseCase
		self.throttler = throttler
		super.init(with: initialState)
	}

	@available(*, unavailable)
	required init(with initialState: LassoStore<CounterModule>.State) {
		fatalError("init(with:) has not been implemented")
	}

	override func handleAction(_ action: LassoStore<CounterModule>.Action) {
		switch action {
		case .viewDidLoad, .didReload: self.load()
		case .didReloadMultipler: self.reloadMultipler()
		case .didTapIncrement: self.increment()
		case .didTapUpgrade: self.upgrade()
		case .setError(let error): self.setError(error)
		case .setInfo(let info): self.setInfo(info)
		case .setMultiplierLoading(let enabled): self.setMultiplierLoading(enabled)
		}
	}
}

// MARK: - Actions
private extension CounterStore
{
	func load() {
		self.setLoading(true)
		self.incrementRepository.load()
			.done { self.setState(with: $0, multiplier: self.incrementUseCase.multiplier) }
			.catch { self.setError($0.asAppError) }
			.finally { self.setLoading(false) }
	}

	func increment() {
		self.throttler.throttle { [weak self] in
			guard let self = self else { return }
			self.incrementRepository.increment(with: self.state.total)
				.done { self.setState(with: $0, multiplier: self.incrementUseCase.multiplier) }
				.catch { self.setError($0.asAppError) }
		}

		let state = self.state
		let counters: IncrementModel.Counters = .init(top: state.top, total: state.total, me: state.me)
		let newCounters = self.incrementUseCase.increment(counters)

		self.setCounters(newCounters)
	}

	func upgrade() {
		self.setMultiplierLoading(true)
		self.incrementUseCase.upgrade()
			.done { product in
				guard let product = product else {
					self.setInfo(R.string.localizable.counterMultiplierInfo())
					self.setIsMultiplierLast(true)
					return
				}
				self.dispatchOutput(.buyProduct(product))
			}
			.catch { self.setError($0.asAppError) }
	}

	func reloadMultipler() {
		self.setMultiplier(self.incrementUseCase.multiplier)
	}
}

// MARK: - Helpers for update
private extension CounterStore
{
	func setLoading(_ enabled: Bool) {
		update { $0.isLoading = enabled }
	}

	func setState(with incrementModel: IncrementModel, multiplier: String) {
		update { state in
			let newState = self.makeState(from: incrementModel, multiplier: multiplier, oldState: state)
			state.fill(with: newState)
		}
	}

	func setCounters(_ counters: IncrementModel.Counters) {
		update { state in
			state.total = counters.total
			state.me = counters.me
			state.top = counters.top
		}
	}

	func setError(_ error: AppError?) {
		update { state in
			state.error = error
		}
	}

	func setInfo(_ info: String?) {
		update { state in
			state.info = info
		}
	}

	func setMultiplier(_ value: String) {
		update { state in
			state.multiplier = value
		}
	}

	func setMultiplierLoading(_ enabled: Bool) {
		update { state in
			state.isMultiplierLoading = enabled
		}
	}

	func setIsMultiplierLast(_ value: Bool) {
		update { state in
			state.isMultiplierLoading = false
			state.isMultiplierLast = value
		}
	}
}

private extension CounterStore
{
	func makeState(
		from model: IncrementModel,
		multiplier: String,
		oldState: CounterModule.State? = nil
	) -> CounterModule.State {
		return .init(
			isLoading: false,
			top: model.counters.top,
			total: model.counters.total,
			me: model.counters.me,
			position: model.position,
			numberOfParticipants: model.numberOfParticipants,
			initialDate: model.initialDate,
			error: oldState?.error,
			info: oldState?.info,
			multiplier: multiplier,
			isMultiplierLast: oldState?.isMultiplierLast ?? false,
			isMultiplierLoading: oldState?.isMultiplierLoading ?? false
		)
	}
}
