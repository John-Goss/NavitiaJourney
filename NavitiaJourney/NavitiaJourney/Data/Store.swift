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

class Store {
	var trainStations: [TrainStation] = []
	private var favoritesID: [String]?
	private(set) var favoritesTrainStations: [TrainStation] = []
	
	init() {
		retrieveFavoritesIdFromUserDefaults()
	}
	
	func addToFavorite(trainStationID: String) {
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
		saveFavoritesIdToUserDefaults()
	}
	
	func deleteFromFavorite(trainStationID: String) {
		let arr = self.favoritesTrainStations.filter { $0.id != trainStationID }
		self.favoritesTrainStations = arr
		let userInfo = ["id": trainStationID]
		NotificationCenter.default.post(name: .stationRemovedFromFavorites, object: nil, userInfo: userInfo)
		print("[Store] DeleteFromFavorites --> train station ID'\(trainStationID)' was removed from favorites")
		saveFavoritesIdToUserDefaults()
	}
	
	func isInFavorites(trainStationID: String) -> Bool {
		return (favoritesTrainStations.contains { (element) -> Bool in
			return element.id == trainStationID
		})
	}
	func retrieveFavoritesIdFromUserDefaults() {
		let userDefaults = UserDefaults.standard
		
		favoritesID = userDefaults.object(forKey: "FavoritesIdKey") as? [String] ?? [String]()
		print("[Store] Retrieving \(favoritesID?.count ?? 0) id from UserDefaults")
	}
	
	func saveFavoritesIdToUserDefaults() {
		let userDefaults = UserDefaults.standard
		
		favoritesID = []
		for station in favoritesTrainStations {
			favoritesID?.append(station.id)
		}
		userDefaults.set(favoritesID, forKey: "FavoritesIdKey")
		print("[Store] Saving \(favoritesID!.count) favorites to UserDefaults")
	}

	func setupFavoritesTrainStationsFromIds() {
		if let favoritesID = favoritesID {
			for id in favoritesID {
				for station in trainStations {
					if id == station.id {
						favoritesTrainStations.append(station)
						break
					}
				}
			}
		}
	}
}
