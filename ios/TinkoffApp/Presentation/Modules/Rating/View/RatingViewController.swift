//
//  RatingViewController.swift
//  TinkoffApp
//
//  Created by Станислава on 19.03.2024.
//

import Foundation

import UIKit
import Combine
import CoreMotion

enum RatingSection {
    case main
}

class RatingViewController: UIViewController {

    private var output: RatingViewOutput
    
    private lazy var tableView = UITableView(frame: view.bounds, style: .insetGrouped)
    private lazy var dataSource = makeDataSource()
    
    init(output: RatingViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        output.viewIsReady()
        setupView()
    }
    
    private func setupView() {
        setupTitle()
        setupTableView()
    }

    private func setupTitle() {
        navigationItem.title = "Рейтинг водителей"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(closeRating)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func closeRating() {
        output.closeRating()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

        tableView.register(RatingCell.self, forCellReuseIdentifier: "RatingCell")
    }
    
    private func makeDataSource() -> RatingDataSource {
        let dataSource = RatingDataSource(tableView: tableView) { tableView, indexPath, cellModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as? RatingCell else {
                fatalError("Cannot create RatingCell")
            }
            cell.configure(with: cellModel)
            cell.selectionStyle = .none
            return cell
        }
        return dataSource
    }
}

final class RatingDataSource: UITableViewDiffableDataSource<RatingSection, RatingModel> { }

extension RatingViewController: RatingViewInput {
    func applySnapshot(with models: [RatingModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<RatingSection, RatingModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension RatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        headerView.backgroundColor = .clear

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
