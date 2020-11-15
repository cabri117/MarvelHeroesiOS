//
//  HeroesFlowCoordinator.swift
//
//
//  Created by Daniel Cabrera on 05/11/2020.
//  Copyright © Daniel Cabrera. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
protocol HeroesFlowCoordinatorDependencies: Coordinator {
    func goToHeroeDetail(with model: HeroesModel)
    func goToMarvelLink(with url: URL)
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
    
    func goToMarvelLink(with url: URL) {
        let viewController = makeSafariController(with: url)
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
}
// MARK: Private Methods
private extension HeroesFlowCoordinator {
    func makeHeroesListController() -> UIViewController {
       return  HeroesListController.create(with: viewModel, coordinator: self)
    }
    func makeHeroesDetailController(with model: HeroesModel) -> UIViewController {
       return HeroeDetailViewController.create(with: model,
                                               from: viewModel,
                                               coordinator: self)
    }
    func makeSafariController(with url: URL) -> UIViewController {
        let config = SFSafariViewController.Configuration()
        return SFSafariViewController(url: url, configuration: config)
    }
}
