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
			let searchTextField: UITextField? = stationSearchBarOutlet.value(forKey: "searchField") as? UITextField
			searchTextField?.textColor = UIColor.black
			searchTextField?.font = UIFont(name: "Poppins-Regular", size: 17)
			searchTextField?.delegate = self
			let placeHolderLabel = searchTextField!.value(forKey: "placeholderLabel") as? UILabel
			placeHolderLabel?.font = UIFont(name: "Poppins-Regular", size: 17)
			if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
				let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor(named: "SearchBarPlaceHolderColor")]
				searchTextField!.attributedPlaceholder = NSAttributedString(string: "Rechercher une station", attributes: attributeDict as [NSAttributedString.Key : Any])
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

	//MARK: - UIViewController Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "FavoritesVC"
		self.navigationController?.navigationBar.isHidden = true
		self.view.backgroundColor = UIColor(named: "BackgroundColorSet")
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(tap)

		let service = TrainStationService()
		service.getTrainStations { [weak self] result in
			guard let strongSelf = self else { return }
			switch result {
			case let .success(p):
				print(p)
				strongSelf.storageController?.trainStations = p.places
				DispatchQueue.main.async {
					strongSelf.stationTableView.reloadData()
				}
			case let .failure(error):
				print("--> Train Stations Error: \(error)")
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		stationTableView.reloadData()
	}
	
	//MARK: - Privates
	
	@objc private func dismissKeyboard() {
		view.endEditing(true)
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
		stationTableView.reloadData()
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
			currentStation = storageController?.favoritesTrainStations[indexPath.row] ?? TrainStation(id: "default", name: "default", quality: 0)
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
		for station in storageController!.trainStations {
			if (station.name.lowercased().contains(textToSearch.lowercased())) {
				filteredTrainStations.append(station)
			}
		}
		if (textToSearch.isEmpty) {
			filteredTrainStations = storageController!.trainStations
		}
		stationTableView.reloadData()
	}
}

//MARK: - UITextfieldDelegate

extension FavoritesViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
