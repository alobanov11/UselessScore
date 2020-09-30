//
//  Created by Антон Лобанов on 21.09.2020.
//

import Foundation

extension Date
{
	func years(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
	}

	func months(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
	}

	func days(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
	}

	func hours(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
	}

	func minutes(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
	}

	func seconds(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
	}
}
