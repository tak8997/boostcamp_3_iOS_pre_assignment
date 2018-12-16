//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by Gaon Kim on 13/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    // MARK: - Properties
    private var id: String?
    private var movieTitle: String?
    private var thumbnailImage: UIImage?
    private var movieDetail: MovieDetail?
    private var commentList: CommentList?
    private let titleCellIdentifier: String = "sectionTitleCell"

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: Enums
    enum Section: String {
        case summary = "summaryCell"
        case synopsis = "synopsisCell"
        case people = "peopleCell"
        case comments = "commentsCell"

        static var allValues: [Section] = [.summary, .synopsis, .people, .comments]
    }

    // MARK: - Methods
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movieTitle
        requestData()
    }

    // MARK: Custom Methods
    func setDefaultData(id: String?, movieTitle: String?, thumbnailImage: UIImage?) {
        self.id = id
        self.movieTitle = movieTitle
        self.thumbnailImage = thumbnailImage
    }
}

// MARK: - Private Extension
private extension MovieDetailViewController {
    // Movie Detail(requestMovieDetail)과 Comment List(requestComments)를 요청
    // 에러 발생 시: Alert Controller present
    // Alert Controller가 두 개 생성되는 것을 방지하기 위해 flag 이용
    func requestData() {
        var flag: Bool = true
        guard let id = id else { return }
        // Movie Detail 요청
        // 성공 시: movieDetail 설정, tableView reload, large image 요청
        Requests.requestMovieDetail(id: id) { [weak self] (movieDetail, error) in
            if error != nil {
                if flag {
                    flag.toggle()
                    // error 발생 시 이전 화면으로 돌아가는 action이 추가된 alert controller 실행
                    self?.presentErrorAlert(actionTitle: "돌아가기", actionHandler: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
            if let movieDetail = movieDetail {
                self?.movieDetail = movieDetail
                self?.tableView.reloadData()
                self?.loadLargeImage(imageUrl: movieDetail.image)
            }
        }

        // Comments List 요청
        // 성공 시: commentList 설정, tableView reload
        Requests.requestComments(id: id) { [weak self] (commentList, error) in
            if error != nil {
                if flag {
                    flag.toggle()
                    self?.presentErrorAlert(actionTitle: "돌아가기", actionHandler: {
                        // error 발생 시 이전 화면으로 돌아가는 action이 추가된 alert controller 실행
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
            if let commentList = commentList {
                self?.commentList = commentList
                self?.tableView.reloadData()
            }
        }
    }

    // FullScreenPosterViewController에서 이미지를 빨리 로드할 수 있게 미리 request
    func loadLargeImage(imageUrl: String) {
        Requests.requestImage(imageUrl: imageUrl) { [weak self] image in
            self?.thumbnailImage = image
        }
    }

    // SectionTitleTableViewCell
    func getTitleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, section: Section, title: String) -> UITableViewCell {
        guard let cell: SectionTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: titleCellIdentifier, for: indexPath) as? SectionTitleTableViewCell else { return UITableViewCell() }

        cell.sectionTitleLabel.text = title

        return cell
    }

    // SummaryTableViewCell
    func getSummaryCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, section: Section) -> UITableViewCell {
        guard let cell: SummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? SummaryTableViewCell else { return UITableViewCell() }

        cell.setData(movieDetail: movieDetail, thumbnailImage: thumbnailImage)
        cell.selectionStyle = .none
        cell.delegate = self

        return cell
    }

    // SynopsisTableViewCell
    func getSynopsisCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, section: Section) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: UITableViewCell = getTitleCell(tableView, cellForRowAt: indexPath, section: section, title: "줄거리")
            return cell
        } else {
            guard let cell: SynopsisTableViewCell  = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? SynopsisTableViewCell else { return UITableViewCell() }

            cell.setData(movieDetail: movieDetail)

            return cell
        }
    }

    // PeopleTableViewCell
    func getPeopleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, section: Section) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: UITableViewCell = getTitleCell(tableView, cellForRowAt: indexPath, section: section, title: "감독 / 출연")
            return cell
        } else {
            guard let cell: PeopleTableViewCell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? PeopleTableViewCell else { return UITableViewCell() }

            cell.setData(movieDetail: movieDetail)

            return cell
        }
    }

    // CommentTableViewCell
    func getCommentCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, section: Section) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell: SectionTitleTableViewCell = getTitleCell(tableView, cellForRowAt: indexPath, section: section, title: "한줄평") as? SectionTitleTableViewCell else { return UITableViewCell() }
            cell.setButtonImageEnable()
            return cell
        } else {
            guard let cell: CommentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }

            guard let comment: Comment = commentList?.comments[indexPath.row - 1] else { return UITableViewCell() }

            cell.setData(comment: comment)

            return cell
        }
    }
}

// MARK: - Table View Data Source
extension MovieDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allValues.count
    }

    // synopsis, people, comments 는 title cell 갯수를 포함 (+1)
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
        let cell: UITableViewCell

        // 해당 Section에 맞는 cell 반환
        switch section {
        case .summary:
            cell = getSummaryCell(tableView, cellForRowAt: indexPath, section: section)
        case .synopsis:
            cell = getSynopsisCell(tableView, cellForRowAt: indexPath, section: section)
        case .people:
            cell = getPeopleCell(tableView, cellForRowAt: indexPath, section: section)
        case .comments:
            cell = getCommentCell(tableView, cellForRowAt: indexPath, section: section)
        }

        return cell
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

// MARK: - Custom Tap Gesture Delegate
// SummaryTableViewCell의 thumbnailImageView를 탭하면 실행
// FullScreenPosterViewController를 present
// large image 로드가 완료되었을 때는 large image가 보여지고, 미완료되었을 경우 thumbnail image가 보여짐
extension MovieDetailViewController: CustomTapGestureDelegate {
    func presentNextViewController() {
        let viewController: FullScreenPosterViewController = FullScreenPosterViewController()
        viewController.image = thumbnailImage
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true, completion: nil)
    }
}
