//
//  ViewController.swift
//  NavitiaJourney
//
//  Created by John on 05/11/2020.
//

import UIKit

class FavoritesViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "FavoritesVC"
		self.navigationController?.navigationBar.isHidden = true
		self.view.backgroundColor = UIColor(named: "BackgroundColorSet")
	}
}
