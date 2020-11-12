//
//  Departures.swift
//  NavitiaJourney
//
//  Created by John on 10/11/2020.
//

struct Departures: Codable {
	var departures: [Schedule]
}

struct Schedule: Codable {
	var informations: DisplayInfos
	var stopDate: DepartureInfos
	
	enum CodingKeys: String, CodingKey {
		case informations = "display_informations"
		case stopDate = "stop_date_time"
	}
}

struct DisplayInfos: Codable {
	var ligneNumber: String
	var color: String
	var commercial_mode: String
	var direction: String

	enum CodingKeys: String, CodingKey {
		case ligneNumber = "code"
		case color
		case commercial_mode
		case direction
	}
}

struct DepartureInfos: Codable {
	var date: String

	enum CodingKeys: String, CodingKey {
		case date = "departure_date_time"
	}
}
