//
//  MovieTableViewController.swift
//  BoxOffice
//
//  Created by Gaon Kim on 11/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class MovieTableViewController: UIViewController {
    // MARK: - Properties
    private let cellIdentifier: String = "movieTableCell"
    private let refreshControl: UIRefreshControl = UIRefreshControl()

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Methods
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addMovieListNotificationObserver()
        requestDataIfMovieListIsEmpty()
        setRefreshControl()
    }

    // MARK: IBAction Methods
    @IBAction func tappedOrderSettingButton(_ sender: UIBarButtonItem) {
        addOrderSettingAlert()
    }

    // MARK: Override Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: MovieDetailViewController = segue.destination as? MovieDetailViewController,
            let cell: MovieTableViewCell = sender as? MovieTableViewCell else { return }

        nextViewController.setDefaultData(
            id: cell.getId(),
            movieTitle: cell.titleLabel.text,
            thumbnailImage: cell.thumbnailImageView.image)
    }
}

// MARK: - Private Extension
private extension MovieTableViewController {
    func addMovieListNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveMovieListNotification(_:)),
            name: Requests.DidReceivedMovieListNotification,
            object: nil)
    }

    @objc func didReceiveMovieListNotification(_: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.setNavigationTitleByOrder()
            self?.tableView.reloadData()
        }
    }

    func requestDataIfMovieListIsEmpty() {
        if OrderType.shared.movies.isEmpty {
            Requests.requestMovieList(order: OrderType.shared.order) { [weak self] (_, error) in
                if error != nil {
                    self?.presentErrorAlert(actionTitle: "닫기", actionHandler: nil)
                } else {
                    self?.setNavigationTitleByOrder()
                    self?.tableView.reloadData()
                }
            }
        }
    }

    @objc func refresh() {
        Requests.requestMovieList(order: OrderType.shared.order) { [weak self] (_, error) in
            if error != nil {
                self?.presentErrorAlert(actionTitle: "닫기", actionHandler: nil)
            } else {
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }

    func setRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "영화 목록을 업데이트하는 중입니다.")
        tableView.refreshControl = refreshControl
    }
}

// MARK: - Table View Data Source
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

// MARK: - Table View Delegate
extension MovieTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
