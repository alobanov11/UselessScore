//
//  Created by Антон Лобанов on 20.09.2020.
//

import Foundation

struct IncrementModel: Equatable, Codable
{
	var counters: Counters
	let position: Int
	let numberOfParticipants: Int
	let initialDate: Date
}

extension IncrementModel
{
	struct Counters: Equatable, Codable
	{
		var top: Int
		var total: Int
		var me: Int
	}
}
