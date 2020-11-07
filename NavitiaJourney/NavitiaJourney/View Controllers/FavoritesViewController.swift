//
//  ViewController.swift
//  NavitiaJourney
//
//  Created by John on 05/11/2020.
//

import UIKit

class FavoritesViewController: UIViewController {

	//MARK: - Outlets

	@IBOutlet weak var stationSearchBarOutlet: UISearchBar!
	@IBOutlet weak var stationTableView: UITableView! {
		didSet {
			stationTableView.delegate = self
			stationTableView.dataSource = self
			let cell = UINib(nibName: StationTableViewCell.nibName, bundle: nil)
			stationTableView.register(cell, forCellReuseIdentifier: StationTableViewCell.reuseIdentifier)
			stationTableView.backgroundColor = UIColor(named: "BackgroundColorSet")
		}
	}

	//MARK: - UIViewController Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "FavoritesVC"
		self.navigationController?.navigationBar.isHidden = true
		self.view.backgroundColor = UIColor(named: "BackgroundColorSet")
	}
}

//MARK: - UITableViewDelegate Methods

extension FavoritesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}

//MARK: - UITableViewDataSource Methods

extension FavoritesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3 // TO DO
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = stationTableView.dequeueReusableCell(withIdentifier: StationTableViewCell.reuseIdentifier) as? StationTableViewCell else {
			return StationTableViewCell()
		}
		// TO DO get currentStation from Store.stations[indexPath.row]
		let currentStation = TrainStation(id: "21", name: "Gare De Lyon", quality: 3)
		let viewModel = StationMapper(station: currentStation).build()
		cell.setup(viewModel: viewModel)

		return cell
	}
}
