//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by Gaon Kim on 13/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var id: String?
    var movieTitle: String?
    var thumbnailImage: UIImage?
    var largeImage: UIImage?
    var movieDetail: MovieDetail?
    var commentList: CommentList?

    @IBOutlet weak var tableView: UITableView!
    
    enum Section: String {
        case summary = "summaryCell"
        case synopsis = "synopsisCell"
        case people = "peopleCell"
        case comments = "commentsCell"
        
        static var allValues: [Section] = [.summary, .synopsis, .people, .comments]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movieTitle
        requestData()
    }
}

// MARK:- Private Extension
private extension MovieDetailViewController {
    func requestData() {
        guard let id = id else { return }
        Requests.requestMovieDetail(id: id) { movieDetail in
            self.movieDetail = movieDetail
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        Requests.requestComments(id: id) { commentList in
            self.commentList = commentList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadLargeImage(imageUrl: String) {
        Requests.requestImage(imageUrl: imageUrl) { image in
            self.largeImage = image
        }
    }
}

// MARK:- Table View Data Source
extension MovieDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section: Section = Section.allValues[section]
        switch section {
        case .summary:
            return 1
        case .synopsis, .people:
            return 2
        case .comments:
            if let count = commentList?.comments.count {
                return count + 1
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section: Section = Section.allValues[indexPath.section]
        
        switch section {
        case .summary:
            guard let cell: SummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? SummaryTableViewCell else { return UITableViewCell() }
            cell.setData(movieDetail: movieDetail, thumbnailImage: thumbnailImage)
            return cell
        case .synopsis:
            if indexPath.row == 0 {
                guard let cell: SectionTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sectionTitleCell", for: indexPath) as? SectionTitleTableViewCell else { return UITableViewCell() }
                cell.sectionTitleLabel.text = "줄거리"
                return cell
            } else {
                guard let cell: SynopsisTableViewCell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? SynopsisTableViewCell else { return UITableViewCell() }
                cell.setData(movieDetail: movieDetail)
                return cell
            }
        case .people:
            if indexPath.row == 0 {
                guard let cell: SectionTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sectionTitleCell", for: indexPath) as? SectionTitleTableViewCell else { return UITableViewCell() }
                cell.sectionTitleLabel.text = "감독 / 출연"
                return cell
            } else {
                guard let cell: PeopleTableViewCell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? PeopleTableViewCell else { return UITableViewCell() }
                cell.setData(movieDetail: movieDetail)
                return cell
            }
        case .comments:
            if indexPath.row == 0 {
                guard let cell: SectionTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sectionTitleCell", for: indexPath) as? SectionTitleTableViewCell else { return UITableViewCell() }
                cell.sectionTitleLabel.text = "한줄평"
                cell.buttonImageView.image = #imageLiteral(resourceName: "btn_compose.png")
                return cell
            } else {
                guard let cell: CommentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }
                
                guard let comment: Comment = commentList?.comments[indexPath.row - 1] else { return UITableViewCell() }
                cell.setData(comment: comment)
                return cell
            }
        }
    }
}

// MARK: - Table View Delegate
extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0 ? .leastNormalMagnitude : 8)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
