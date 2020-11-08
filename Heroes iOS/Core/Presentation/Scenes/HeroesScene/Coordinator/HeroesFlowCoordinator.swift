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
    
}
// MARK: Private Methods
private extension HeroesFlowCoordinator {
    func makeHeroesListController() -> UITableViewController {
       return  HeroesListController.create(with: viewModel, coordinator: self)
    }
}
