//
//  HeroesViewModel.swift
//
//
//  Created by Daniel Cabrera on 05/11/2020.
//  Copyright © Daniel Cabrera. All rights reserved.
//

import Foundation
protocol HeroesViewModelInput {
    func didLoadNextPage()
    func load()
}

protocol HeroesViewModelOutput {
    var heroesItems: Observable<[HeroesModel]> { get }
    var error: Observable<String?> { get }
    var loading: Observable<HeroesViewModelLoading> { get }
}

enum HeroesViewModelLoading {
    case fullScreen
    case nextPage
    case none
}

protocol HeroesViewModel: HeroesViewModelInput, HeroesViewModelOutput { }

final class DefaultHeroesViewModel: HeroesViewModel {
    // MARK: OUTPUT
    let heroesItems: Observable<[HeroesModel]> = Observable([])
    let error: Observable<String?> = Observable(nil)
    var loading: Observable<HeroesViewModelLoading> = Observable(.none)
    
    // MARK: Dependencies
    private lazy var heroesSkillListUseCase = { return FetchHeroesSkillsListUseCase()}()
    
    

}

// MARK: - INPUT. View event methods
extension DefaultHeroesViewModel {
    
    func didLoadNextPage() {
        self.loading.value = .nextPage
        fetchData()
    }
    
    func load() {
        self.loading.value = .fullScreen
        fetchData()
    }
    
}

private extension DefaultHeroesViewModel {
    private func fetchData() {
        heroesSkillListUseCase.execute { result in
            self.loading.value = .none
            switch result {
            case .success(let heroesList):
                self.heroesItems.value += heroesList
            case .failure:
                self.error.value = "unknow error"
            }
        }
    }
    
}
