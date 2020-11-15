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
	var fullName: String
	var quality: Int
	var stopArea: StopArea
	var displayName: String {
		return stopArea.displayName
	}

	enum CodingKeys: String, CodingKey {
		case id
		case fullName = "name"
		case quality
		case stopArea = "stop_area"
	}
}

struct StopArea: Codable {
	var displayName: String

	enum CodingKeys: String, CodingKey {
		case displayName = "name"
	}
}
