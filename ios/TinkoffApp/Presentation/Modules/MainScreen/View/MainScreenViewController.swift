//
//  MainScreenViewController.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import UIKit
import Combine
import CoreMotion

enum TripsSection {
    case drivers
    case passengers
}

class MainScreenViewController: UIViewController {

    private var output: MainScreenViewOutput
    
    private lazy var tableView = UITableView(frame: view.bounds, style: .insetGrouped)
    private lazy var dataSource = makeDataSource()
    
    let speedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    init(output: MainScreenViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
    }
    
    private func setupView() {
        setupTitle()
        setupTableView()
    }

    private func setupTitle() {
        navigationItem.title = "Недавние поездки"
        navigationController?.navigationBar.prefersLargeTitles = true
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

        tableView.register(TripCell.self, forCellReuseIdentifier: "TripCell")
        
        var snapshot = NSDiffableDataSourceSnapshot<TripsSection, TripModel>()
        snapshot.appendSections([.drivers, .passengers])
        snapshot.appendItems([
            TripModel(date: Date.now, city: "Москва", rating: 7.7, isDriver: true),
            TripModel(date: Date.now, city: "Москва", rating: 9.9, isDriver: true),
            TripModel(date: Date.now, city: "Москва", rating: 1.2, isDriver: true),
            TripModel(date: Date.now, city: "Москва", rating: 5.1, isDriver: true)
        ], toSection: .drivers)
        snapshot.appendItems([
            TripModel(date: Date.now, city: "Москва", rating: 7.7, isDriver: false),
            TripModel(date: Date.now, city: "Москва", rating: 9.9, isDriver: false),
        ], toSection: .passengers)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        UILabel.appearance(whenContainedInInstancesOf: [
                    UITableViewHeaderFooterView.self
        ]).textColor = .black
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, cellModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as? TripCell else {
                fatalError("Cannot create TripCell")
            }
            cell.configure(with: cellModel)
            return cell
        }
        return dataSource
    }
}

final class DataSource: UITableViewDiffableDataSource<TripsSection, TripModel> { }

extension MainScreenViewController: MainScreenViewInput {
    
}


extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
            print("Selected item: \(selectedItem)")
            output.tripDidSelect(model: selectedItem)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        headerView.backgroundColor = .clear

        let label = UILabel(frame: CGRect(x: 15, y: 10, width: tableView.bounds.width - 30, height: 20))
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.textColor = .gray
        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Водитель"
        case 1:
            return "Пассажир"
        default:
            return nil
        }
    }
}
