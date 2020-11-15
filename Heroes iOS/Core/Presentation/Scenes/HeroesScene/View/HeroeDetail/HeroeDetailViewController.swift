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
    @IBOutlet private weak var howManyStoriesLbl: UILabel!
    @IBOutlet weak var howManySeriesLbl: UILabel!
    @IBOutlet weak var howManyComicsLbl: UILabel!
    // MARK: Private Variables
    private var heroesModel: HeroesModel!
    private var viewModel: HeroesViewModel!
    private weak var coordinator: HeroesFlowCoordinatorDependencies?
    // MARK: Create Method
    final class func create(with model: HeroesModel,
                            from viewModel: HeroesViewModel,
                            coordinator: HeroesFlowCoordinatorDependencies) -> HeroeDetailViewController {
        // We create the controller
        let controller = HeroeDetailViewController()
        //inject model to controller
        controller.heroesModel = model
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
        title = heroesModel.name
        showHeroeDescription()
        showHeroeImage()
        createHeroesStackView()
        guard let howManyStories = heroesModel.howManyStories else {
            return
        }
        howManyStoriesLbl.text = "\(howManyStories) Stories"
        guard let howManySeries = heroesModel.howManySeries else {
            return
        }
        howManySeriesLbl.text = "\(howManySeries) Series"
        guard let howManyComics = heroesModel.howManyComics else {
            return
        }
        howManyComicsLbl.text = "\(howManyComics) Comics"
        view.accessibilityIdentifier = "HeroeDetailViewController"
    }
}
// MARK: Private Methods
private extension HeroeDetailViewController {
    func showHeroeDescription() {
        guard !heroesModel.description.isEmpty else {
            heroeDescriptionLbl.text = "We don't have a description for this heroe :(. But we have more details in the buttons above :D"
            return
        }
        descriptionTitleLbl.isHidden = false
        heroeDescriptionLbl.text = heroesModel.description
    }
    
    func showHeroeImage() {
        heroeComicUIImageView.alpha = 0.0
        activityIndicatorView.isHidden = false
        guard let posterImagePath = heroesModel.imageUrl,
              let imageUrl = URL(string: posterImagePath) else { return }
        _ = viewModel.posterImagesRepository?.loadImage(imageUrl) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.heroeComicUIImageView.image = UIImage(data: data)
                    self?.animateThumbnail()
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.heroeComicUIImageView.image = UIImage(named: "empty_state")
                    self?.animateThumbnail()
                }
            }
            
        }
    }
    
    func animateThumbnail() {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.heroeComicUIImageView.alpha = 1.0
                        self?.activityIndicatorView.isHidden = true
                       })
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
        button.accessibilityIdentifier = title
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
