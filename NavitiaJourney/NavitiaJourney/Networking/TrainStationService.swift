//
//  TrainStationService.swift
//  NavitiaJourney
//
//  Created by John on 08/11/2020.
//

import Foundation
import Alamofire

class TrainStationService: NSObject {
	private let APIKey: String = "85942154-edae-465d-979c-f3952a940da3"
	private let endpoint: URL = URL(string:"https://api.navitia.io/v1/coverage/fr-idf/places?q=Gare%20de&")!
	
	func getTrainStations(result: @escaping (Swift.Result<Places, Error>) -> Void) {
		let headers = ["Authorization": self.APIKey]
		Alamofire.request(self.endpoint, method: .get, headers: headers).responseJSON { response in
			switch response.result {
			case .success:
				do {
					let decoder = JSONDecoder()
					let jsonString = String(data: response.data!, encoding: .utf8)
					let trainStations = try decoder.decode(Places.self, from: response.data!)
					result(.success(trainStations))
				} catch let err {
					print("ERROR CATCH get trainStations: ", err)
					result(.failure(err))
				}
				break
			case .failure(let error):
				result(.failure(error))
				break
			}
		}
	}
}
