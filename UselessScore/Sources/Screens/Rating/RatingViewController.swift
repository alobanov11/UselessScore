//
//  Created by Антон Лобанов on 20.09.2020.
//

import UIKit
import Lasso
import NVActivityIndicatorView

final class RatingViewController: ViewController, LassoView, IUIMessageDisplayable
{
	let store: RatingModule.ViewStore

	private lazy var backButton: UIButton = {
		let button = UIButton()
		button.setImage(R.image.icons.back(), for: .normal)
		button.tintColor = R.color.text()
		return button
	}()

	private lazy var headerView: UIView = {
		let label = UILabel()
		label.font = .h3
		label.text = R.string.localizable.ratingTopForAllTime()
		label.textColor = R.color.text()
		label.textAlignment = .center
		return label
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

	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = .clear
		tableView.contentInset = .init(top: 72, left: 0, bottom: 0, right: 0)
		tableView.alwaysBounceVertical = true
		tableView.showsVerticalScrollIndicator = false
		tableView.separatorColor = .clear
		tableView.delegate = self
		tableView.dataSource = self
		tableView.allowsSelection = false
		tableView.addSubview(self.refreshControl)
		tableView.register(RatingUserTableViewCell.self, forCellReuseIdentifier: "cellID")
		return tableView
	}()

	init(store: RatingModule.ViewStore) {
		self.store = store
		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = R.color.background()

		self.view.addSubviews([self.tableView, self.backButton])

		self.backButton.pin {
			$0.width.height.equalTo(44)
			$0.top.equalTo(self.view.safeArea.top).inset(22)
			$0.left.equalTo(self.view.safeArea.left).inset(11)
		}

		self.tableView.pin {
			$0.top.equalTo(self.view.safeArea.top)
			$0.left.right.bottom.equalToSuperview()
		}

		self.setUpBindings()
		self.store.dispatchAction(.viewDidLoad)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.store.dispatchAction(.didReload)
	}
}

extension RatingViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.state.users.count
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return self.headerView
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 96
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			self.state.users.indices.contains(indexPath.row),
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "cellID",
				for: indexPath
			) as? RatingUserTableViewCell
		else {
			return UITableViewCell()
		}
		cell.fill(with: self.state.users[indexPath.row])
		return cell
	}
}

extension RatingViewController: UITableViewDelegate
{
}

private extension RatingViewController
{
	func setUpBindings() {
		self.backButton.bind(to: self.store, action: .didTapBack)

		self.refreshControl.bind(.valueChanged, to: self.store, action: .didReload)

		self.store.observeState(\.isLoading) { [weak self] value in
			value ? self?.refreshControl.beginRefreshing() : self?.refreshControl.endRefreshing()
		}

		self.store.observeState(\.users) { [weak self] _ in
			self?.tableView.reloadData()
		}
	}
}
