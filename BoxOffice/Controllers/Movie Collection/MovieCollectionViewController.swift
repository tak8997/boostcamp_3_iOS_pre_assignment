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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        addMovieListNotificationObserver()
        requestDataIfMovieListIsEmpty()
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
        
        nextViewController.id = cell.id
        nextViewController.movieTitle = cell.titleLabel.text
        nextViewController.thumbnailImage = cell.thumbnailImageView.image
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
