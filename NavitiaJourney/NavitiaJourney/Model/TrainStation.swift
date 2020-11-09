//
//  Station.swift
//  NavitiaJourney
//
//  Created by John on 06/11/2020.
//

struct Places: Codable {
	var places: [TrainStation]
}

struct TrainStation: Codable {
	var id: String
	var name: String
	var quality: Int
}
