//
//  Store.swift
//  NavitiaJourney
//
//  Created by John on 07/11/2020.
//

import Foundation

extension Notification.Name {
	static let stationAddedToFavorites = Notification.Name("stationAddedToFavorites")
	static let stationRemovedFromFavorites = Notification.Name("stationRemovedFromFavorites")
}

struct Store {
	private(set) var favoritesTrainStations: [TrainStation] = []
	var trainStations: [TrainStation] = []

	mutating func resetStore() {
		self.trainStations = []
	}
	
	mutating func resetFavorites() {
		self.favoritesTrainStations = []
	}

	mutating func addToFavorite(trainStationID: String) {
		var newTrainStationToAdd: TrainStation? = nil
		if (favoritesTrainStations.contains { (element) -> Bool in
			return element.id == trainStationID
		}) {
			print("[Store] AddToFavorites --> train station ID: \(trainStationID) is already in favorites")
			return
		}
		if !(trainStations.contains { (element) -> Bool in
			if element.id == trainStationID {
				newTrainStationToAdd = element
				return true
			} else {
				return false
			}
		}) {
			print("[Store] AddToFavorites --> train station ID: \(trainStationID) dosen't exist in store")
			return
		}
		guard let _ = newTrainStationToAdd else { return }
		let list = favoritesTrainStations + [newTrainStationToAdd!]
		self.favoritesTrainStations = list
		let userInfo = ["id": newTrainStationToAdd!.id]
		NotificationCenter.default.post(name: .stationAddedToFavorites, object: nil, userInfo: userInfo)
		print("[Store] AddToFavorites --> train station '\(newTrainStationToAdd!.id)' added to favorites")
	}

	mutating func deleteFromFavorite(trainStationID: String) {
		let arr = self.favoritesTrainStations.filter { $0.id != trainStationID }
		self.favoritesTrainStations = arr
		let userInfo = ["id": trainStationID]
		NotificationCenter.default.post(name: .stationRemovedFromFavorites, object: nil, userInfo: userInfo)
		print("[Store] DeleteFromFavorites --> train station ID'\(trainStationID)' was removed from favorites")
	}
	
	func isInFavorites(trainStationID: String) -> Bool {
		return (favoritesTrainStations.contains { (element) -> Bool in
			return element.id == trainStationID
		})
	}
}
