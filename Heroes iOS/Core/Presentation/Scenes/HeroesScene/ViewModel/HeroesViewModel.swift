//
//  HeroesViewModel.swift
//
//
//  Created by Daniel Cabrera on 05/11/2020.
//  Copyright © Daniel Cabrera. All rights reserved.
//

import Foundation
protocol HeroesViewModelInput {}

protocol HeroesViewModelOutput {}

protocol HeroesViewModel: HeroesViewModelInput, HeroesViewModelOutput { }

final class DefaultHeroesViewModel: HeroesViewModel {
}

// MARK: - INPUT. View event methods
extension HeroesViewModel {
}
