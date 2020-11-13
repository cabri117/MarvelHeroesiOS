//
//  HeroesListController.swift
//  Heroes iOS
//
//  Created by TR64UV on 08/11/2020.
//

import UIKit

class HeroesListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var heroesTableView: UITableView!
    @IBOutlet weak var heroesListLoadingContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var heroesNextPageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyStateView: UIView!
    
    private var viewModel: HeroesViewModel!
    var items: [HeroesModel] = [] {
        didSet { reload() }
    }
    weak var coordinator: HeroesFlowCoordinatorDependencies?
    
    final class func create(with viewModel: HeroesViewModel,
                            coordinator: HeroesFlowCoordinatorDependencies) -> HeroesListController {
        /// We create the controller
        let controller = HeroesListController()
        //inject view model to controller
        controller.viewModel = viewModel
        controller.coordinator = coordinator
        return controller
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
        heroesTableView.estimatedRowHeight = HeroesListItemCellTableViewCell.height
        heroesTableView.rowHeight = UITableView.automaticDimension
        heroesTableView.register(UINib(nibName: HeroesListItemCellTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HeroesListItemCellTableViewCell.reuseIdentifier)
        viewModel.load()
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: HeroesViewModel) {
        viewModel.heroesItems.observe(on: self) { [weak self] in self?.items = $0 }
        viewModel.error.observe(on: self) { [weak self]  in self?.showError($0) }
        viewModel.loading.observe(on: self) { [weak self] loadingState in
            self?.updateViewsVisibility()
        }
    }
    
    func reload() {
        heroesTableView.reloadData()
    }
    // MARK: - Table view data source
    
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

private extension HeroesListController {
    func updateViewsVisibility() {
        
        heroesTableView.isHidden = false
        LoadingView.hide()
        heroesListLoadingContainerHeight.constant = 0
        heroesNextPageIndicator.isHidden = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            switch self.viewModel.loading.value {
            case .fullScreen: LoadingView.show()
            case .nextPage:
                self.heroesListLoadingContainerHeight.constant = 40
                self.heroesNextPageIndicator.isHidden = false
            case .none: break
            }
        }
        
    }
    
    private func showError(_ error: String?) {
        guard error != nil else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.emptyStateView.isHidden = false
        }
    }
}
