//
//  IErrorDisplayable.swift
//  UselessScore
//
//  Created by Антон Лобанов on 23.09.2020.
//

import UIKit
import NotificationBannerSwift

protocol IUIMessageDisplayable: AnyObject
{
	func showInfo(_ info: String)
	func showError(_ error: AppError)
}

extension IUIMessageDisplayable where Self: UIViewController
{
	func showInfo(_ info: String) {
		DispatchQueue.main.async {
			let banner = NotificationBanner(title: info, colors: InfoBannerColors())
			banner.show(queuePosition: .front, bannerPosition: .top, queue: .default, on: self)
			banner.applyStyling(titleFont: .defaultBold, titleColor: R.color.secondaryText())
		}
	}

	func showError(_ error: AppError) {
		DispatchQueue.main.async {
			let banner = NotificationBanner(title: error.localizedDescription, colors: DangerBannerColors())
			banner.show(queuePosition: .front, bannerPosition: .top, queue: .default, on: self)
			banner.applyStyling(titleFont: .defaultBold, titleColor: R.color.text())
		}
	}
}

private final class InfoBannerColors: BannerColorsProtocol
{
	func color(for style: BannerStyle) -> UIColor {
		return R.color.secondaryBackground() ?? .link
	}
}

private final class DangerBannerColors: BannerColorsProtocol
{
	func color(for style: BannerStyle) -> UIColor {
		return R.color.accent() ?? UIColor.red
	}
}
