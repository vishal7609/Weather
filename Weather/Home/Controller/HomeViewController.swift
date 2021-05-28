//
//  HomeViewController.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tblLocations: UITableView!
    var homeViewModel: HomeViewModel?
    let searchTableViewController = SearchTableViewController()
    var searchController = UISearchController()

    var weatherResponse = [WeatherData]() {
        didSet {
            self.tblLocations.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.initMasterData()
        self.setNavigationBar()
        homeViewModel = HomeViewModel()
        self.setTableView()
        homeViewModel?.reloadDataCompletion = {
            self.weatherResponse = self.homeViewModel?.weatherData ?? []
        }
        homeViewModel?.reloadAndMoveCompletion = { [weak self] weather in
            self?.moveToDetailController(wetherData: weather)
        }
        homeViewModel?.getAllSavedWetherData()
    }


    func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchTableViewController.delegate = self
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        self.title = "Locations"
    }
    
    func setTableView() {
        self.tblLocations.dataSource = self
        self.tblLocations.delegate = self
        self.tblLocations.register(cellType: LocationTableViewCell.self)
    }
    
    func moveToDetailController(wetherData: WeatherData) {
        let detailVC = DetailViewController.instantiate()
        detailVC.weatherData = wetherData
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: LocationTableViewCell.self, for: indexPath)
        cell.setCell(weather: weatherResponse[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            homeViewModel?.removeObject(cityId: weatherResponse[indexPath.row].id)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeViewModel?.refreshWeatherData(cityId: weatherResponse[indexPath.row].id)
    }
    
}

extension HomeViewController: UISearchResultsUpdating, SearchTableViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if let searchVC = searchController.searchResultsController as? SearchTableViewController {
            searchVC.resetTableView(text: text)
        }
    }

    func didSelectSearchController(city: City) {
        if let data = homeViewModel?.checkWeatherDataStatus(cityId: city.id) {
            self.moveToDetailController(wetherData: data)
        } else {
            homeViewModel?.getWeatherData(cityId: city.id)
        }
        self.searchController.searchBar.text = ""
        self.searchController.dismiss(animated: true, completion: nil)
    }
}
