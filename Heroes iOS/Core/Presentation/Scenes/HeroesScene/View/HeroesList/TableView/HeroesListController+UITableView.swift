//
//  HeroesListController+UITableView.swift
//  Heroes iOS
//
//  Created by TR64UV on 14/11/2020.
//

import UIKit
// MARK: Table view Data Source
extension HeroesListController: UITableViewDelegate, UITableViewDataSource {
    func createTableView() {
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
        heroesTableView.estimatedRowHeight = HeroesListItemCellTableViewCell.height
        heroesTableView.rowHeight = UITableView.automaticDimension
        heroesTableView.register(UINib(nibName: HeroesListItemCellTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HeroesListItemCellTableViewCell.reuseIdentifier)
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
        
        cell.fill(with: items[indexPath.row])
        cell.heroeSelectedAction = { [weak self ]heroeSelected in
            guard let self = self else {
                return
            }
            self.coordinator?.goToHeroeDetail(with: heroeSelected)
        }
        
        if indexPath.row == items.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeroesListItemCellTableViewCell.height
    }
}
