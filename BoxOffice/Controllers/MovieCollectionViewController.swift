//
//  MovieCollectionViewController.swift
//  BoxOffice
//
//  Created by Gaon Kim on 11/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController {
    // MARK: - Properties
    private let cellIdentifier: String = "movieCollectionCell"
    private let refreshControl: UIRefreshControl = UIRefreshControl()

    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!

    // MARK: - Methods
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleByOrder()
        addMovieListNotificationObserver()
        requestDataIfMovieListIsEmpty()
        setRefreshControl()
    }
    
    override func viewDidLayoutSubviews() {
        setCollectionViewFlowLayoutItemSize()
    }

    // MARK: IBAction Methods
    @IBAction func tappedOrderSettingButton(_ sender: UIBarButtonItem) {
        addOrderSettingAlert()
    }
    
    // MARK: Override Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: MovieDetailViewController = segue.destination as? MovieDetailViewController,
            let cell: MovieCollectionViewCell = sender as? MovieCollectionViewCell else { return }

        nextViewController.setDefaultData(
            id: cell.getId(),
            movieTitle: cell.titleLabel.text,
            thumbnailImage: cell.thumbnailImageView.image)
    }
}

// MARK: - Private Extension
private extension MovieCollectionViewController {
    // Notification Observer를 추가
    func addMovieListNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveMovieListNotification(_:)),
            name: Requests.DidReceivedMovieListNotification, object: nil)
    }

    // Movie List Notification 을 받았을 때: navigation title 변경, collectionView reload
    @objc func didReceiveMovieListNotification(_: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.setNavigationTitleByOrder()
            self?.collectionView.reloadData()
        }
    }

    // Singleton으로 구현된 Movie List가 비어 있을 때 request
    // 에러 발생 시: Alert Controller present
    // 요청 성공 시: navigation title 변경, collectionView reload
    func requestDataIfMovieListIsEmpty() {
        if OrderType.shared.movies.isEmpty {
            Requests.requestMovieList(order: OrderType.shared.order) { [weak self] (_, error) in
                if error != nil {
                    self?.presentErrorAlert(actionTitle: "닫기", actionHandler: nil)
                } else {
                    self?.setNavigationTitleByOrder()
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    // collectinoView의 Flow Layout 설정
    func setCollectionViewFlowLayoutItemSize() {
        let width: CGFloat = (view.bounds.inset(by: view.safeAreaInsets).width - 31) / 2.0
        let height: CGFloat = width * 1.8
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
    }

    // Refresh Control에 의한 refresh
    @objc func refresh() {
        Requests.requestMovieList(order: OrderType.shared.order) { [weak self] (_, error) in
            if error != nil {
                self?.presentErrorAlert(actionTitle: "닫기", actionHandler: nil)
            } else {
                self?.refreshControl.endRefreshing()
                self?.collectionView.reloadData()
            }
        }
    }

    // Refresh Control 설정
    func setRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refreshMovieList), for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "영화 목록을 업데이트하는 중입니다.")
        collectionView.refreshControl = refreshControl
    }

}

// MARK: - Collection View Data Source
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
