//
//  MovieCollectionViewController.swift
//  BoxOffice
//
//  Created by Gaon Kim on 11/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController {
    private let cellIdentifier: String = "movieCollectionCell"
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        addMovieListNotificationObserver()
        requestDataIfMovieListIsEmpty()
        setRefreshControl()
    }
    
    override func viewDidLayoutSubviews() {
        setCollectionViewFlowLayoutItemSize()
    }
    
    @IBAction func tappedOrderSettingButton(_ sender: UIBarButtonItem) {
        addOrderSettingAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: MovieDetailViewController = segue.destination as? MovieDetailViewController,
            let cell: MovieCollectionViewCell = sender as? MovieCollectionViewCell else { return }
        
        nextViewController.setDefaultData(id: cell.getId(), movieTitle: cell.titleLabel.text, thumbnailImage: cell.thumbnailImageView.image)
    }
}

// MARK:- Private Extension
private extension MovieCollectionViewController {
    func addMovieListNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieListNotification(_:)), name: Requests.DidReceivedMovieListNotification, object: nil)
    }
    
    @objc func didReceiveMovieListNotification(_: Notification) {
        DispatchQueue.main.async {
            self.setNavigationTitle()
            self.collectionView.reloadData()
        }
    }
    
    func requestDataIfMovieListIsEmpty() {
        if OrderType.shared.movies.isEmpty {
            Requests.requestMovieList(order: OrderType.shared.order) {
                DispatchQueue.main.async {
                    self.setNavigationTitle()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setCollectionViewFlowLayoutItemSize() {
        let width: CGFloat = (view.bounds.inset(by: view.safeAreaInsets).width - 31) / 2.0
        let height: CGFloat = width * 1.8
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    @objc func refresh() {
        Requests.requestMovieList(order: OrderType.shared.order) {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            }
        }
    }
    
    func setRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "영화 목록을 업데이트하는 중입니다.")
        collectionView.refreshControl = refreshControl
    }

}

// MARK:- Collection View Data Source
extension MovieCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OrderType.shared.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        let movie = OrderType.shared.movies[indexPath.item]
        
        cell.setData(movie: movie)
        
        return cell
    }
}
