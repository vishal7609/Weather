//
//  SearchTableViewController.swift
//  Weather
//
//  Created by Kumar,Vishal on 28/05/21.
//

import UIKit

protocol  SearchTableViewControllerDelegate: class {
    func didSelectSearchController(city: City)
}

class SearchTableViewController: UITableViewController {
    
    var cities = [City]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    weak var delegate: SearchTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func resetTableView(text: String) {
        self.cities = CityRepository.getAllCities(searchText: text) ?? [City]()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        let cityName = cities[indexPath.row].name.capitalized
        let countryName = CountryCode.shared.countryDic[cities[indexPath.row].country]
        let name = "\(cityName), \(String(describing: countryName ?? ""))"
        cell.textLabel?.text = name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            delegate?.didSelectSearchController(city: cities[indexPath.row])
        }
    }

}
