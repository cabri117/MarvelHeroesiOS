//
//  HeroeDetailViewController.swift
//  Heroes iOS
//
//  Created by TR64UV on 12/11/2020.
//

import UIKit

class HeroeDetailViewController: UIViewController {
    @IBOutlet weak var heroeComicView: UIImageView!
    private var heroesModel: HeroesModel!
    private weak var coordinator: HeroesFlowCoordinatorDependencies?
    let imageCache = NSCache<NSString, UIImage>()
    
    final class func create(with model: HeroesModel,
                            coordinator: HeroesFlowCoordinatorDependencies) -> HeroeDetailViewController {
        /// We create the controller
        let controller = HeroeDetailViewController()
        //inject view model to controller
        controller.heroesModel = model
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
        guard let posterImagePath = heroesModel.imageUrlPortraitMedium, let imageUrl = URL(string: posterImagePath) else { return }
        self.heroeComicView.downloadImage(from: imageUrl,
                                     cacheImage: imageCache) {
            
        }
    }
}
