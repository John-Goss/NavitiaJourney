//
//  StationTableView.swift
//  NavitiaJourney
//
//  Created by John on 06/11/2020.
//

import UIKit

protocol StationTableViewCellDelegate: AnyObject {
	func stationTableViewCell(didTapAddToFavorite stationIdToAdd: String)
	func stationTableViewCell(didTapRemoveFromFavorite stationIdToRemove: String)
	func reloadDatas()
}

class StationTableViewCell: UITableViewCell {
	class var reuseIdentifier: String {
		return "StationTableViewCellIdentifier"
	}
	class var nibName: String {
		return "StationTableViewCell"
	}

	//MARK: - Outlets

	@IBOutlet weak var favoriteButtonOutlet: UIButton!
	@IBOutlet weak var trainStationOutlet: UILabel!

	//MARK: - Properties

	var stationID: String = ""
	var isFavorite: Bool = false
	weak var delegate: StationTableViewCellDelegate?

	//MARK: - UITableViewCell Methods

	override func awakeFromNib() {
		super.awakeFromNib()
		NotificationCenter.default.addObserver(self, selector: #selector(addedToFavorites), name: .stationAddedToFavorites, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(removedFromFavorites), name: .stationRemovedFromFavorites, object: nil)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		stationID = ""
		trainStationOutlet.text = ""
	}
	
	func setup(viewModel: StationTableViewModel) {
		stationID = viewModel.id
		isFavorite = viewModel.isFavorite
		trainStationOutlet.text = viewModel.name
		favoriteButtonOutlet.imageView?.image = UIImage(named: viewModel.favoriteButtonImageName)
	}

	//MARK: - Private Methods

	@objc private func removedFromFavorites(_ notification:Notification) {
		guard let delegate = delegate else { return }
		if let id = notification.userInfo?["id"] as? String {
			if id == stationID {
				isFavorite = false
				favoriteButtonOutlet.imageView?.image = UIImage(named: "favoriteButtonBlank")
				DispatchQueue.main.async {
					delegate.reloadDatas()
				}
			}
		}
	}

	@objc private func addedToFavorites(_ notification:Notification) {
		guard let delegate = delegate else { return }
		if let id = notification.userInfo?["id"] as? String {
			if id == stationID {
				isFavorite = true
				favoriteButtonOutlet.imageView?.image = UIImage(named: "favoriteButtonFilled")
				DispatchQueue.main.async {
					delegate.reloadDatas()
				}
			}
		}
	}

	//MARK: - Actions

	@IBAction func favoriteStateChangeButton(_ sender: UIButton) {
		if !stationID.isEmpty {
			guard let delegate = delegate else { return }
			if isFavorite {
				delegate.stationTableViewCell(didTapRemoveFromFavorite: self.stationID)
			} else {
				delegate.stationTableViewCell(didTapAddToFavorite: self.stationID)
			}
		}
	}
}
