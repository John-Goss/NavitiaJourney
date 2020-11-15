//
//  StationMapper.swift
//  NavitiaJourney
//
//  Created by John on 06/11/2020.
//

import UIKit

class StationMapper: NSObject {
	let currentStation: TrainStation
	var isInFavoriteStation: Bool
	
	init(station: TrainStation, isInFavorites: Bool) {
		currentStation = station
		isInFavoriteStation = isInFavorites
	}
	
	func build() -> StationTableViewModel {
		var favoriteButtonImageName: String

		favoriteButtonImageName = isInFavoriteStation ? "favoriteButtonFilled" : "favoriteButtonBlank"

		let viewModel = StationTableViewModel(id: currentStation.id, name: currentStation.displayName, isFavorite: isInFavoriteStation, favoriteButtonImageName: favoriteButtonImageName)
		return viewModel
	}
}
