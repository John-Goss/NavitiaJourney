//
//  SchedulesViewController.swift
//  NavitiaJourney
//
//  Created by John on 11/11/2020.
//

import UIKit

class SchedulesViewController: UIViewController {

	//MARK: - Outlets

	@IBOutlet weak var scheduleTableView: UITableView! {
		didSet {
			scheduleTableView.dataSource = self
			scheduleTableView.delegate = self
			let cell = UINib(nibName: ScheduleTableViewCell.nibName, bundle: nil)
			scheduleTableView.register(cell, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
			scheduleTableView.backgroundColor = UIColor(named: "BackgroundColorSet")
		}
	}
	@IBOutlet weak var stationNameLabel: UILabel!

	//MARK: - Properties

	var schedulesArray: [Schedule]?
	var actualStation: String = ""
	private let cellSpacingHeight: CGFloat = 5.5

	//MARK: - UIViewController Methods

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
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return schedulesArray?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = scheduleTableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier) as? ScheduleTableViewCell else {
			return ScheduleTableViewCell()
		}
		let viewModel = ScheduleMapper(schedule: schedulesArray![indexPath.section]).build()
		cell.setup(viewModel: viewModel)
		cell.layer.cornerRadius = 20
		cell.clipsToBounds = true

		return cell
	}
}

//MARK: - UITableViewDelegate Methods

extension SchedulesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return cellSpacingHeight
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor.clear
		return headerView
	}
}
