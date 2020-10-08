//
//  Created by Антон Лобанов on 08.10.2020.
//

import UIKit

final class RatingUserTableViewCell: UITableViewCell
{
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .h4
		label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		return label
	}()

	private lazy var valueLabel: UILabel = {
		let label = UILabel()
		label.font = .h5
		label.textColor = R.color.accent()
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.configureUI()
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func fill(with user: RatingUser) {
		self.titleLabel.text = (AppConstants.deviceID == user.device)
			? R.string.localizable.commonMe()
			: user.nickname
		self.titleLabel.textColor = (AppConstants.deviceID == user.device)
			? R.color.accent()
			: R.color.text()
		self.valueLabel.text = user.scoreValue
	}
}

private extension RatingUserTableViewCell
{
	func configureUI() {
		self.backgroundColor = .clear
		self.contentView.addSubviews([self.titleLabel, self.valueLabel])
		self.titleLabel.pin {
			$0.left.equalToSuperview().inset(48)
			$0.top.bottom.equalToSuperview().inset(14)
		}
		self.valueLabel.pin {
			$0.top.bottom.equalToSuperview().inset(14)
			$0.right.equalToSuperview().inset(48)
			$0.left.equalTo(self.titleLabel.snp.right)
		}
	}
}
