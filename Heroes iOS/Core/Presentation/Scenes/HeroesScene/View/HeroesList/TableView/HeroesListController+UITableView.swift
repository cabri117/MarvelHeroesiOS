//
//  HeroesListController+UITableView.swift
//  Heroes iOS
//
//  Created by TR64UV on 14/11/2020.
//

import UIKit
// MARK: Table view Data Source
extension HeroesListController: UITableViewDelegate,
                                UITableViewDataSource,
                                UIScrollViewDelegate {
    func createTableView() {
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
        heroesTableView.estimatedRowHeight = HeroesListItemCellTableViewCell.height
        heroesTableView.rowHeight = UITableView.automaticDimension
        heroesTableView.allowsSelection = true
        heroesTableView.register(UINib(nibName: HeroesListItemCellTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HeroesListItemCellTableViewCell.reuseIdentifier)
        heroesTableView.accessibilityIdentifier = "heroesTableView"
    }
    func reload() {
        heroesTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroesListItemCellTableViewCell.reuseIdentifier, for: indexPath) as? HeroesListItemCellTableViewCell else {
            fatalError("Cannot dequeue reusable cell \(HeroesListItemCellTableViewCell.self) with reuseIdentifier: \(HeroesListItemCellTableViewCell.reuseIdentifier)")
        }
        cell.fill(with: items[indexPath.row],
                  posterImagesRepository: viewModel.posterImagesRepository)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeroesListItemCellTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let heroeSelected = items[indexPath.row]
        self.coordinator?.goToHeroeDetail(with: heroeSelected)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            viewModel.loadNextPage()
        }
    }
}
