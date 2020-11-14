//
//  HeroeDetailViewController.swift
//  Heroes iOS
//
//  Created by TR64UV on 12/11/2020.
//

import UIKit

class HeroeDetailViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var heroeComicUIImageView: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var heroeDescriptionLbl: UILabel!
    @IBOutlet private weak var descriptionTitleLbl: UILabel!
    @IBOutlet private weak var moreDetailStackView: UIStackView!
    // MARK: Private Variables
    private var heroesModel: HeroesModel!
    private weak var coordinator: HeroesFlowCoordinatorDependencies?
    private let imageCache = NSCache<NSString, UIImage>()
    // MARK: Create Method
    final class func create(with model: HeroesModel,
                            coordinator: HeroesFlowCoordinatorDependencies) -> HeroeDetailViewController {
        // We create the controller
        let controller = HeroeDetailViewController()
        //inject model to controller
        controller.heroesModel = model
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
        title = heroesModel.name
        showHeroeDescription()
        showHeroeImage()
        createHeroesStackView()
    }
}
// MARK: Private Methods
private extension HeroeDetailViewController {
    func showHeroeDescription() {
        guard !heroesModel.description.isEmpty else {
            return
        }
        descriptionTitleLbl.isHidden = false
        heroeDescriptionLbl.text = heroesModel.description
    }
    
    func showHeroeImage() {
        heroeComicUIImageView.alpha = 0.0
        activityIndicatorView.isHidden = false
        guard let posterImagePath = heroesModel.imageUrl, let imageUrl = URL(string: posterImagePath) else { return }
        self.heroeComicUIImageView.downloadImage(from: imageUrl,
                                                 cacheImage: imageCache) { [weak self] in
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut,
                           animations: {
                            self?.heroeComicUIImageView.alpha = 1.0
                            self?.activityIndicatorView.isHidden = true
                           })
        }
    }
    
    func createHeroesStackView() {
        moreDetailStackView.distribution = .fillEqually
        moreDetailStackView.spacing = 16
        heroesModel.moreDetailElements.forEach({createButton($0.name, $0.tagId) })
    }
    
    func createButton(_ title: String, _ idTag: Int) {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.backgroundColor = .red
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.tag = idTag
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        moreDetailStackView.addArrangedSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        guard let detailModel = heroesModel.moreDetailElements.first(where: {$0.tagId == sender.tag}),
              let url = URL(string: detailModel.url) else {
            return
        }
        coordinator?.goToMarvelLink(with: url)
    }
}
