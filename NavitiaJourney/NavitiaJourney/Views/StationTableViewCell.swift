//
//  StationTableView.swift
//  NavitiaJourney
//
//  Created by John on 06/11/2020.
//

import UIKit

class StationTableViewCell: UITableViewCell {
	class var reuseIdentifier: String {
		return "StationTableViewCellIdentifier"
	}
	class var nibName: String {
		return "StationTableViewCell"
	}

	@IBOutlet weak var favoriteButtonOutlet: UIButton!
	@IBOutlet weak var trainStationOutlet: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	func setup(viewModel: StationTableViewModel) {
		trainStationOutlet.text = viewModel.name
		favoriteButtonOutlet.imageView?.image = UIImage(named: viewModel.favoriteButtonImageName)
	}
}
