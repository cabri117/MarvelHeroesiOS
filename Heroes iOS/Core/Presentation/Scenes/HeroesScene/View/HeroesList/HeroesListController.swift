//
//  HeroesListController.swift
//  Heroes iOS
//
//  Created by TR64UV on 08/11/2020.
//

import UIKit

class HeroesListController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var heroesTableView: UITableView!
    @IBOutlet private weak var heroesListLoadingContainerHeight: NSLayoutConstraint!
    @IBOutlet private weak var heroesNextPageIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var emptyStateView: UIView!
    let refreshControl = UIRefreshControl()
    // MARK: Public Variables
    var viewModel: HeroesViewModel!
    var items: [HeroesModel] = []
    weak var coordinator: HeroesFlowCoordinatorDependencies?
    // MARK: Create Method
    final class func create(with viewModel: HeroesViewModel,
                            coordinator: HeroesFlowCoordinatorDependencies) -> HeroesListController {
        // We create the controller
        let controller = HeroesListController()
        // inject view model to controller
        controller.viewModel = viewModel
        controller.coordinator = coordinator
        return controller
    }
    // MARK: Life Cycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Marvel Heroes!"
        heroesTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        createTableView()
        viewModel.load()
        bind(to: viewModel)
        view.accessibilityIdentifier = "HeroesListController"
    }
}

private extension HeroesListController {
    func bind(to viewModel: HeroesViewModel) {
        viewModel.heroesItems.observe(on: self) { [weak self] in
            self?.items = $0
            self?.reload()
        }
        viewModel.error.observe(on: self) { [weak self]  in self?.showError($0) }
        viewModel.loading.observe(on: self) { [weak self] _ in self?.updateViewsVisibility()}
    }
    func updateViewsVisibility() {
        heroesTableView.isHidden = false
        LoadingView.hide()
        heroesListLoadingContainerHeight.constant = 0
        heroesNextPageIndicator.isHidden = true
        emptyStateView.isHidden = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            switch self.viewModel.loading.value {
            case .fullScreen: LoadingView.show()
            case .nextPage:
                self.heroesListLoadingContainerHeight.constant = 40
                self.heroesNextPageIndicator.isHidden = false
            case .none:
                self.refreshControl.endRefreshing()
            case .refresh: break
            }
        }
        
    }
    func showError(_ error: String?) {
        self.emptyStateView.alpha = 0.0
        guard error != nil else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.3,
                           delay: 0.2,
                           options: .curveEaseInOut,
                           animations: {
                            guard let self = self else {
                                return
                            }
                            self.heroesTableView.isHidden = false
                            self.emptyStateView.isHidden = false
                            self.emptyStateView.alpha = 1.0
                            LoadingView.hide()
                            self.heroesListLoadingContainerHeight.constant = 0
                            self.heroesNextPageIndicator.isHidden = true
                           })
            
        }
    }
    @objc private func refreshWeatherData(_ sender: Any) {
        viewModel.refreshData()
    }
    
    @IBAction private func restartButton(_ sender: Any) {
        viewModel.refreshData()
    }
}
