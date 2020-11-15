//
//  SchedulesViewController.swift
//  NavitiaJourney
//
//  Created by John on 11/11/2020.
//

import UIKit

class SchedulesViewController: UIViewController {

	@IBOutlet weak var scheduleTableView: UITableView! {
		didSet {
			scheduleTableView.dataSource = self
			let cell = UINib(nibName: ScheduleTableViewCell.nibName, bundle: nil)
			scheduleTableView.register(cell, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
			scheduleTableView.backgroundColor = UIColor(named: "BackgroundColorSet")
		}
	}
	@IBOutlet weak var stationNameLabel: UILabel!

	var schedulesArray: [Schedule]?
	var actualStation: String = ""

	required init(stationScheduleName: String) {
		actualStation = stationScheduleName
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = false
		self.navigationController?.navigationBar.tintColor = UIColor(named: "NavBarButtonColor")
		self.view.backgroundColor = UIColor(named: "BackgroundColorSet")

		stationNameLabel.text = actualStation
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = false
		scheduleTableView.reloadData()
	}
}

//MARK: - UITableViewDataSource Methods

extension SchedulesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return schedulesArray?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = scheduleTableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier) as? ScheduleTableViewCell else {
			return ScheduleTableViewCell()
		}
		cell.layer.cornerRadius = 20
		let viewModel = ScheduleMapper(schedule: schedulesArray![indexPath.row]).build()
		cell.setup(viewModel: viewModel)

		return cell
	}
}
