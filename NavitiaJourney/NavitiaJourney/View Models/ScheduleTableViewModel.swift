//
//  ScheduleTableViewModel.swift
//  NavitiaJourney
//
//  Created by John on 11/11/2020.
//

import Foundation

class ScheduleTableViewModel: NSObject {
	let commercialMode: String
	let ligneNumber: String
	let ligneBackgroundHexColor: String
	let departureTime: String
	let direction: String
	let commercialModeImageName: String
	
	init(departureTime: String, direction: String, ligneNumber: String, ligneHexColor: String, commercialMode: String, commercialModeImageName: String) {
		self.commercialMode = commercialMode
		self.ligneNumber = ligneNumber
		self.ligneBackgroundHexColor = ligneHexColor
		self.departureTime = departureTime
		self.direction = direction
		self.commercialModeImageName = commercialModeImageName
	}
}
