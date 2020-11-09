//
//  StationTableViewModel.swift
//  NavitiaJourney
//
//  Created by John on 06/11/2020.
//

import Foundation

class StationTableViewModel: NSObject {
	let id: String
	let name: String
	let isFavorite: Bool
	let favoriteButtonImageName: String

	init(id: String, name: String, isFavorite: Bool, favoriteButtonImageName: String) {
		self.id = id
		self.name = name
		self.isFavorite = isFavorite
		self.favoriteButtonImageName = favoriteButtonImageName
	}
}
