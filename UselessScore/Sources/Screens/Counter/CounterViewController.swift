//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso
import NVActivityIndicatorView

final class CounterViewController: ViewController, LassoView, IUIMessageDisplayable
{
	let store: CounterModule.ViewStore

	private lazy var topAmountLabel: UILabel = {
		let label = UILabel()
		label.font = .display2
		label.textColor = R.color.text()
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private lazy var totalAmountLabel: UILabel = {
		let label = UILabel()
		label.font = .display1
		label.textColor = R.color.text()
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private lazy var meAmountLabel: UILabel = {
		let label = UILabel()
		label.font = .display2
		label.textColor = R.color.text()
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private lazy var incrementButton: UIButton = {
		let button = UIButton()
		button.setTitle("+", for: .normal)
		button.setTitleColor(R.color.text(), for: .normal)
		button.setTitleColor(R.color.accent(), for: .highlighted)
		button.titleLabel?.font = .display2
		return button
	}()

	private lazy var containerStackView: UIStackView = {
		let topSubtitleLabel = UILabel()
		let topStackView = UIStackView(arrangedSubviews: [self.topAmountLabel, topSubtitleLabel])
		topStackView.axis = .vertical
		topStackView.alignment = .fill
		topStackView.distribution = .fill
		topStackView.spacing = -20
		topSubtitleLabel.textColor = R.color.text()
		topSubtitleLabel.text = R.string.localizable.counterTopSubtitle()
		topSubtitleLabel.font = .defaultBold
		topSubtitleLabel.textAlignment = .right

		let totalSubtitleLabel = UILabel()
		let totalStackView = UIStackView(arrangedSubviews: [self.totalAmountLabel, totalSubtitleLabel])
		totalStackView.axis = .vertical
		totalStackView.alignment = .fill
		totalStackView.distribution = .fill
		totalStackView.spacing = -35
		totalSubtitleLabel.textColor = R.color.text()
		totalSubtitleLabel.text = R.string.localizable.counterAmountSubtitle()
		totalSubtitleLabel.font = .defaultBold
		totalSubtitleLabel.textAlignment = .right

		let meSubtitleLabel = UILabel()
		let meStackView = UIStackView(arrangedSubviews: [self.meAmountLabel, meSubtitleLabel])
		meStackView.axis = .vertical
		meStackView.alignment = .fill
		meStackView.distribution = .fill
		meStackView.spacing = -20
		meSubtitleLabel.textColor = R.color.text()
		meSubtitleLabel.text = R.string.localizable.counterMySubtitle()
		meSubtitleLabel.font = .defaultBold
		meSubtitleLabel.textAlignment = .right

		let incrementView = UIView()
		incrementView.addSubview(self.incrementButton)
		self.incrementButton.pin {
			$0.top.right.bottom.equalToSuperview()
			$0.left.greaterThanOrEqualToSuperview()
		}

		let stackView = UIStackView(arrangedSubviews: [topStackView, totalStackView, meStackView, incrementView])
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fill
		stackView.spacing = 20

		let containerStackView = UIStackView(arrangedSubviews: [stackView])
		containerStackView.axis = .horizontal
		containerStackView.alignment = .center
		containerStackView.distribution = .fill

		return containerStackView
	}()

	private lazy var positionLabel: UILabel = {
		let label = UILabel()
		label.font = .h2
		label.textColor = R.color.text()
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private lazy var numberOfParticipantsLabel: UILabel = {
		let label = UILabel()
		label.font = .paragraph
		label.textColor = R.color.text()
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private lazy var scaleFillView: UIView = {
		let view = UIView()
		view.backgroundColor = R.color.accent()
		return view
	}()

	private lazy var resultView: UIView = {
		let view = UIView()

		let scaleView = UIView()
		scaleView.backgroundColor = R.color.secondaryBackground()

		scaleView.addSubview(self.scaleFillView)
		self.scaleFillView.pin {
			$0.top.left.bottom.equalToSuperview()
		}

		view.addSubviews([self.positionLabel, self.numberOfParticipantsLabel, scaleView])

		self.positionLabel.pin {
			$0.top.left.bottom.equalToSuperview()
		}

		self.numberOfParticipantsLabel.pin {
			$0.top.equalToSuperview().offset(5)
			$0.right.lessThanOrEqualToSuperview()
			$0.left.equalTo(self.positionLabel.snp.right).offset(5)
			$0.bottom.equalTo(scaleView.snp.top).offset(-2)
		}

		scaleView.pin {
			$0.height.equalTo(5)
			$0.left.equalTo(self.positionLabel.snp.right).offset(10)
			$0.right.equalToSuperview()
			$0.bottom.lessThanOrEqualToSuperview()
		}

		view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

		return view
	}()

	private lazy var upgradeButton: UIButton = {
		let button = UIButton()
		button.setTitleColor(R.color.secondaryText(), for: .normal)
		button.setTitleColor(R.color.secondaryText()?.withAlphaComponent(0.5), for: .highlighted)
		button.setTitleColor(R.color.text(), for: .disabled)
		button.titleLabel?.font = .defaultBold
		button.backgroundColor = R.color.secondaryBackground()
		button.layer.cornerRadius = 28
		button.contentEdgeInsets = .init(top: 16, left: 48, bottom: 16, right: 48)
		button.titleEdgeInsets = .init(top: 0, left: -48, bottom: 0, right: -48)
		button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		return button
	}()

	private lazy var bottomView: UIView = {
		let view = UIView()
		view.addSubviews([self.resultView, self.upgradeButton])

		self.resultView.pin {
			$0.top.left.bottom.equalToSuperview()
		}

		self.upgradeButton.pin {
			$0.top.right.bottom.equalToSuperview()
			$0.left.equalTo(self.resultView.snp.right).offset(28)
		}

		return view
	}()

	private lazy var contentView: UIView = {
		let view = UIView()
		view.addSubviews([self.containerStackView, self.bottomView])

		self.containerStackView.pin {
			$0.top.greaterThanOrEqualToSuperview()
			$0.left.right.equalToSuperview().inset(28)
			$0.bottom.greaterThanOrEqualTo(self.bottomView.snp.top)
			$0.centerY.equalToSuperview()
		}

		self.bottomView.pin {
			$0.left.right.equalToSuperview().inset(28)
			$0.bottom.equalToSuperview().inset(28)
		}

		return view
	}()

	private lazy var contentStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [self.contentView])
		stackView.axis = .vertical
		stackView.distribution = .equalSpacing
		stackView.alignment = .fill
		stackView.spacing = 0
		return stackView
	}()

	private lazy var refreshControl: UIRefreshControl = {
		let control = UIRefreshControl()
		let indicator = NVActivityIndicatorView(frame: .zero,
												type: .orbit,
												color: R.color.text(),
												padding: .some(20))
		control.tintColor = R.color.background()
		control.addSubview(indicator)
		indicator.pinToSuperview()
		indicator.startAnimating()
		return control
	}()

	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.alwaysBounceVertical = true
		scrollView.showsVerticalScrollIndicator = false

		scrollView.addSubview(self.refreshControl)
		scrollView.addSubview(self.contentStackView)

		self.contentStackView.pin {
			$0.edges.equalToSuperview()
			$0.width.equalToSuperview()
		}

		return scrollView
	}()

	init(store: CounterModule.ViewStore) {
		self.store = store
		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = R.color.background()
		self.view.addSubview(self.scrollView)

		self.contentView.pin {
			$0.height.equalTo(self.view.safeArea.height)
		}

		self.scrollView.pinToSuperviewSafeArea()

		self.setUpBindings()
		self.store.dispatchAction(.viewDidLoad)
	}
}

private extension CounterViewController
{
	func setUpBindings() {
		self.refreshControl.bind(.valueChanged, to: self.store, action: .didReload)

		self.incrementButton.bind(to: self.store, action: .didTapIncrement)

		self.upgradeButton.bind(to: self.store, action: .didTapUpgrade)

		self.store.observeState(\.error) { [weak self] error in
			guard let error = error else { return }
			self?.showError(error)
		}

		self.store.observeState(\.info) { [weak self] info in
			guard let info = info else { return }
			self?.showInfo(info)
		}

		self.store.observeState(\.top) { [weak self] number in
			self?.topAmountLabel.text = "\(number)"
		}

		self.store.observeState(\.total) { [weak self] number in
			self?.totalAmountLabel.text = "\(number)"
		}

		self.store.observeState(\.me) { [weak self] number in
			self?.meAmountLabel.text = "\(number)"
		}

		self.store.observeState(\.position) { [weak self] number in
			self?.positionLabel.text = "\(number)"
		}

		self.store.observeState(\.isLoading) { [weak self] value in
			value ? self?.refreshControl.beginRefreshing() : self?.refreshControl.endRefreshing()
			self?.incrementButton.isHidden = value
			self?.bottomView.isHidden = value
		}

		self.store.observeState { [weak self] state in
			let text = R.string.localizable.counterNumberOfParticipants(
				state.numberOfParticipants,
				(Date().days(sinceDate: state.initialDate) ?? 0) + 1
			)
			self?.numberOfParticipantsLabel.text = text
		}

		self.store.observeState(\.multiplier) { [weak self] value in
			self?.upgradeButton.setTitle(R.string.localizable.counterMultiplier(value), for: .normal)
		}

		self.store.observeState(\.isMultiplierLoading) { [weak self] value in
			value ? self?.upgradeButton.startLoading() : self?.upgradeButton.stopLoading()
		}

		self.store.observeState(\.isMultiplierLast) { [weak self] value in
			self?.upgradeButton.isEnabled = (value == false)
			self?.upgradeButton.layer.borderWidth = value ? 2 : 0
			self?.upgradeButton.layer.borderColor = value ? R.color.secondaryBackground()?.cgColor : UIColor.clear.cgColor
			self?.upgradeButton.backgroundColor = value ? R.color.background() : R.color.secondaryBackground()
		}

		self.store.observeState { [weak self] state in
			let multiplier = (Double(state.position) / Double(state.numberOfParticipants))
			self?.scaleFillView.repin {
				$0.top.left.bottom.equalToSuperview()
				$0.width.equalToSuperview().multipliedBy(multiplier)
			}
		}
	}
}
