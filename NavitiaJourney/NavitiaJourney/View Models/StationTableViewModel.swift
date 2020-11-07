//
//  StationTableViewModel.swift
//  NavitiaJourney
//
//  Created by John on 06/11/2020.
//

import Foundation

class StationTableViewModel: NSObject {
	let name: String
	let isFavorite: Bool
	let favoriteButtonImageName: String

	init(name: String, isFavorite: Bool, favoriteButtonImageName: String) {
		self.name = name
		self.isFavorite = isFavorite
		self.favoriteButtonImageName = favoriteButtonImageName
	}
}
