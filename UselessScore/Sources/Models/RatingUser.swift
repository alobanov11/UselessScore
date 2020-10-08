//
//  Created by Антон Лобанов on 08.10.2020.
//

import Foundation

struct RatingUser: Equatable, Codable
{
	let id: Int64
	let device: String
	let nickname: String
	let score: Int64

	var scoreValue: String {
		"\(self.score)"
	}
}
