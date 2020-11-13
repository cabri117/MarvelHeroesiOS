//
//  HeroesFlowCoordinator.swift
//
//
//  Created by Daniel Cabrera on 05/11/2020.
//  Copyright © Daniel Cabrera. All rights reserved.
//

import Foundation
import UIKit
protocol HeroesFlowCoordinatorDependencies: Coordinator {
    func goToHeroeDetail(with model: HeroesModel)
}

final class HeroesFlowCoordinator: Coordinator, HeroesFlowCoordinatorDependencies {

    private unowned let navigationController: UINavigationController
    private lazy var viewModel: HeroesViewModel = {
        return DefaultHeroesViewModel()
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        add(child: self)
        let viewController = makeHeroesListController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToHeroeDetail(with model: HeroesModel) {
        let viewController = makeHeroesDetailController(with: model)
        navigationController.pushViewController(viewController, animated: true)
    }
}
// MARK: Private Methods
private extension HeroesFlowCoordinator {
    func makeHeroesListController() -> UIViewController {
       return  HeroesListController.create(with: viewModel, coordinator: self)
    }
    func makeHeroesDetailController(with model: HeroesModel) -> UIViewController {
       return HeroeDetailViewController.create(with: model, coordinator: self)
    }
}
