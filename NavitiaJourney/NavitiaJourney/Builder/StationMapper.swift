//
//  StationMapper.swift
//  NavitiaJourney
//
//  Created by John on 06/11/2020.
//

import UIKit

class StationMapper: NSObject {
	let currentStation: TrainStation
	
	init(station: TrainStation) {
		currentStation = station
	}
	
	func build() -> StationTableViewModel {
		var favoriteButtonImageName: String
		var isInFavoriteStation: Bool // TO IMPLEMENT

		isInFavoriteStation = false // TO REMOVE
		favoriteButtonImageName = isInFavoriteStation ? "favoriteButtonFilled" : "favoriteButtonBlank"

		let viewModel = StationTableViewModel(name: currentStation.name, isFavorite: isInFavoriteStation, favoriteButtonImageName: favoriteButtonImageName)
		return viewModel
	}
}
