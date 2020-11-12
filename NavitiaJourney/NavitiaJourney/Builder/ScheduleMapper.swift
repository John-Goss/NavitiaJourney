//
//  ScheduleMapper.swift
//  NavitiaJourney
//
//  Created by John on 11/11/2020.
//

import Foundation

class ScheduleMapper: NSObject {
	let currentSchedule: Schedule
	
	init(schedule: Schedule) {
		currentSchedule = schedule
	}

	func getFormattedStringTime() -> String {
		let scheduleDate = currentSchedule.stopDate.date
		let split = scheduleDate.split(separator: "T")
		guard let hours = split.last else { return "Inconnue" }
		var time = hours.prefix(4)
		let index = time.index(time.endIndex, offsetBy: -2)
		time.insert(":", at: index)
		return String(time)
	}
	
	func getCommercialModeImageName() -> String {
		let commercialMode = currentSchedule.informations.commercial_mode
		switch commercialMode {
		case "Métro":
			return "metro"
		case "Bus":
			return "bus"
		case "Tramway", "Train", "RER":
			return "tram"
		default:
			return ""
		}
	}
	
	func build() -> ScheduleTableViewModel {
		let informations = currentSchedule.informations
		let date = getFormattedStringTime()
		let commercialModeImage = getCommercialModeImageName()

		let viewModel = ScheduleTableViewModel(departureTime: date, direction: informations.direction, ligneNumber: informations.ligneNumber, ligneHexColor: informations.color, commercialMode: informations.commercial_mode, commercialModeImageName: commercialModeImage)
		return viewModel
	}
}
