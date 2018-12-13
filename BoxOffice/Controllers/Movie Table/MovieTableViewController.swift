//
//  MovieTableViewController.swift
//  BoxOffice
//
//  Created by Gaon Kim on 11/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class MovieTableViewController: UIViewController {
    private let cellIdentifier: String = "movieTableCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMovieListNotificationObserver()
        requestDataIfMovieListIsEmpty()
    }
    
    @IBAction func tappedOrderSettingButton(_ sender: UIBarButtonItem) {
        addOrderSettingAlert()
    }
}

// MARK:- Private Extension
private extension MovieTableViewController {
    func addMovieListNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieListNotification(_:)), name: Requests.DidReceivedMovieListNotification, object: nil)
    }
    
    @objc func didReceiveMovieListNotification(_: Notification) {
        DispatchQueue.main.async {
            self.setNavigationTitle()
            self.tableView.reloadData()
        }
    }
    
    func requestDataIfMovieListIsEmpty() {
        if OrderType.shared.movies.isEmpty {
            Requests.requestMovieList(order: OrderType.shared.order) {
                DispatchQueue.main.async {
                    self.setNavigationTitle()
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK:- Table View Data Source
extension MovieTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderType.shared.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let movie: Movie = OrderType.shared.movies[indexPath.row]
        
        cell.setData(movie: movie)
        
        return cell
    }
}

// MARK:- Table View Delegate
extension MovieTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
