//
//  HeroesViewModel.swift
//
//
//  Created by Daniel Cabrera on 05/11/2020.
//  Copyright © Daniel Cabrera. All rights reserved.
//

import Foundation
protocol HeroesViewModelInput {
    func loadNextPage()
    func load()
    func refreshData()
}

protocol HeroesViewModelOutput {
    var heroesItems: Observable<[HeroesModel]> { get }
    var error: Observable<String?> { get }
    var loading: Observable<HeroesViewModelLoading> { get }
    var posterImagesRepository: FetchHeroesImagesRepository? { get }
}

enum HeroesViewModelLoading {
    case fullScreen
    case nextPage
    case refresh
    case none
}

protocol HeroesViewModel: HeroesViewModelInput, HeroesViewModelOutput { }

final class DefaultHeroesViewModel: HeroesViewModel {
    // MARK: OUTPUT
    let heroesItems: Observable<[HeroesModel]> = Observable([])
    let error: Observable<String?> = Observable(nil)
    var loading: Observable<HeroesViewModelLoading> = Observable(.none)
    lazy var posterImagesRepository: FetchHeroesImagesRepository? = { return DefaultFetchHeroesImagesRepository()}()
    // MARK: Dependencies
    private lazy var heroesSkillListUseCase = { return FetchHeroesSkillsListUseCase()}()
}

// MARK: - INPUT. View event methods
extension DefaultHeroesViewModel {
    func loadNextPage() {
        guard self.loading.value == .none else {
            return
        }
        self.loading.value = .nextPage
        fetchData()
    }
    func load() {
        self.loading.value = .fullScreen
        fetchData()
    }
    func refreshData() {
        self.loading.value = .refresh
        heroesSkillListUseCase.resetCurrentOffset()
        fetchData()
    }
}

private extension DefaultHeroesViewModel {
    private func fetchData() {
        heroesSkillListUseCase.execute { [weak self] result in
            switch result {
            case .success(let heroesList):
                if self?.loading.value == .refresh { self?.heroesItems.value = [] }
                self?.loading.value = .none
                self?.heroesItems.value += heroesList
            case .failure:
                self?.error.value = "unknow error"
            }
        }
    }
}
