//
//  ViewController.swift
//  NavitiaJourney
//
//  Created by John on 05/11/2020.
//

import UIKit

class FavoritesViewController: UIViewController {

	//MARK: - Outlets

	@IBOutlet weak var searchBarContainer: UIView! {
		didSet {
			searchBarContainer.layer.cornerRadius = 10
			searchBarContainer.backgroundColor = UIColor.white
		}
	}
	@IBOutlet weak var stationSearchBarOutlet: UISearchBar! {
		didSet {
			stationSearchBarOutlet.delegate = self
			if let searchTextField = stationSearchBarOutlet.value(forKey: "searchField") as? UITextField {
				searchTextField.textColor = UIColor.black
				searchTextField.font = UIFont(name: "Poppins-Regular", size: 17)
				if let placeHolderLabel = searchTextField.value(forKey: "placeholderLabel") as? UILabel {
					placeHolderLabel.font = UIFont(name: "Poppins-Regular", size: 17)
				}
				if searchTextField.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
					let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor(named: "SearchBarPlaceHolderColor")]
					searchTextField.attributedPlaceholder = NSAttributedString(string: "Rechercher une station", attributes: attributeDict as [NSAttributedString.Key : Any])
				}
			}
		}
	}
	@IBOutlet weak var stationTableView: UITableView! {
		didSet {
			stationTableView.delegate = self
			stationTableView.dataSource = self
			let cell = UINib(nibName: StationTableViewCell.nibName, bundle: nil)
			stationTableView.register(cell, forCellReuseIdentifier: StationTableViewCell.reuseIdentifier)
			stationTableView.backgroundColor = UIColor(named: "BackgroundColorSet")
		}
	}
	
	//MARK: - Properties

	var storageController: Store?
	private var filteredTrainStations: [TrainStation] = []
	private let service = TrainStationService()

	//MARK: - UIViewController Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Horaires"
		self.navigationController?.navigationBar.isHidden = true
		self.view.backgroundColor = UIColor(named: "BackgroundColorSet")

		service.getTrainStations { [weak self] result in
			guard let strongSelf = self else { return }
			switch result {
			case let .success(p):
				print(p)
				strongSelf.storageController?.trainStations = p.places
				strongSelf.storageController?.setupFavoritesTrainStationsFromIds()
				DispatchQueue.main.async {
					strongSelf.stationTableView.reloadData()
				}
			case let .failure(error):
				print("--> Train Stations Error: \(error)")
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = true
		stationTableView.reloadData()
	}
}

//MARK: - StationTableViewCelleDelegate Methods

extension FavoritesViewController: StationTableViewCellDelegate {
	func stationTableViewCell(didTapAddToFavorite stationIdToAdd: String) {
		storageController?.addToFavorite(trainStationID: stationIdToAdd)
	}
	
	func stationTableViewCell(didTapRemoveFromFavorite stationIdToRemove: String) {
		storageController?.deleteFromFavorite(trainStationID: stationIdToRemove)
	}
	
	func reloadDatas() {
		stationTableView.reloadData()
	}
}

//MARK: - UITableViewDelegate Methods

extension FavoritesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let searchTextField: UITextField = stationSearchBarOutlet.value(forKey: "searchField") as? UITextField {
			if !(searchTextField.text!.isEmpty) {
				let stationName: String = filteredTrainStations[indexPath.row].displayName
				service.getTrainStationsSchedules(trainStationId: filteredTrainStations[indexPath.row].id, result: { [weak self, stationName] result in
					guard let strongSelf = self else { return }
					switch result {
					case let .success(p):
						DispatchQueue.main.async {
							let vc = SchedulesViewController(stationScheduleName: stationName)
							vc.schedulesArray = p.departures
							strongSelf.navigationController?.pushViewController(vc, animated: true)
						}
					case let .failure(error):
						print("--> Train Stations Schedule Error: \(error)")
					}
				})
			}
			else {
				if let store = storageController {
					let stationName: String = store.favoritesTrainStations[indexPath.row].displayName
					service.getTrainStationsSchedules(trainStationId: store.favoritesTrainStations[indexPath.row].id, result: { [weak self, stationName] result in
						guard let strongSelf = self else { return }
						switch result {
						case let .success(p):
							DispatchQueue.main.async {
								let vc = SchedulesViewController(stationScheduleName: stationName)
								vc.schedulesArray = p.departures
								strongSelf.navigationController?.pushViewController(vc, animated: true)
							}
						case let .failure(error):
							print("--> Train Stations Schedule Error: \(error)")
						}
					})
				}
			}
		}
	}
}

//MARK: - UITableViewDataSource Methods

extension FavoritesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let searchTextField: UITextField = stationSearchBarOutlet.value(forKey: "searchField") as? UITextField {
			if !(searchTextField.text!.isEmpty) {
				return filteredTrainStations.count
			}
		}
		return storageController?.favoritesTrainStations.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = stationTableView.dequeueReusableCell(withIdentifier: StationTableViewCell.reuseIdentifier) as? StationTableViewCell else {
			return StationTableViewCell()
		}
		var currentStation: TrainStation? = nil
		if let searchTextField: UITextField = stationSearchBarOutlet.value(forKey: "searchField") as? UITextField {
			if !(searchTextField.text!.isEmpty) {
				currentStation = filteredTrainStations[indexPath.row]
			}
		}
		if currentStation == nil {
			currentStation = storageController?.favoritesTrainStations[indexPath.row] ?? TrainStation(id: "default", fullName: "default", quality: 0, stopArea: StopArea(displayName: "default"))
		}
		let isFavoriteTrainStation = storageController?.isInFavorites(trainStationID: currentStation!.id)
		let viewModel = StationMapper(station: currentStation!, isInFavorites: isFavoriteTrainStation!).build()
		cell.setup(viewModel: viewModel)
		cell.delegate = self

		return cell
	}
}

//MARK: - UISearchBarDelegate

extension FavoritesViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		let textToSearch: String = stationSearchBarOutlet.text ?? ""
		filteredTrainStations = []
		if let store = storageController {
			for station in store.trainStations {
				if (station.displayName.lowercased().contains(textToSearch.lowercased())) {
					filteredTrainStations.append(station)
				}
			}
			if (textToSearch.isEmpty) {
				filteredTrainStations = store.trainStations
			}
			stationTableView.reloadData()
		}
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}
