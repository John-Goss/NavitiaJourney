//
//  ScheduleTableViewCell.swift
//  NavitiaJourney
//
//  Created by John on 11/11/2020.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
	class var reuseIdentifier: String {
		return "ScheduleTableViewCellIdentifier"
	}
	class var nibName: String {
		return "ScheduleTableViewCell"
	}

	@IBOutlet weak var commercialModeImage: UIImageView!
	@IBOutlet weak var ligneNumberContainer: UIView!
	@IBOutlet weak var ligneNumber: UILabel!
	@IBOutlet weak var departureTimeLabel: UILabel!
	@IBOutlet weak var destinationLabel: UILabel!
	
	override class func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func setup(viewModel: ScheduleTableViewModel) {
		departureTimeLabel.text = viewModel.departureTime
		destinationLabel.text = viewModel.direction
		commercialModeImage.image = UIImage(named: viewModel.commercialModeImageName)
		ligneNumber.text = viewModel.ligneNumber
		ligneNumberContainer.backgroundColor = UIColor(hex: viewModel.ligneBackgroundHexColor)
		ligneNumberContainer.layer.cornerRadius = 12
	}
}
