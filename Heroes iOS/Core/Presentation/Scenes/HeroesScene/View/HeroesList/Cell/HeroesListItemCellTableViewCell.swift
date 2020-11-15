//
//  HeroesListItemCellTableViewCell.swift
//  Heroes iOS
//
//  Created by TR64UV on 11/11/2020.
//

import UIKit
typealias HeroesListItemDidSelectAction = ((HeroesModel) -> Void)
class HeroesListItemCellTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet private weak var comicUIimage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    // MARK: Static constants
    static let reuseIdentifier = String(describing: HeroesListItemCellTableViewCell.self)
    static let height = CGFloat(84)
    // MARK: Private Variables
    private var model: HeroesModel?
    private var posterImagesRepository: FetchHeroesImagesRepository?
    private var currentImageToken: UUID?
    
    /// We fill the cell
    /// - Parameter model: We use the heroes model to fill the cell
    func fill(with model: HeroesModel,
              posterImagesRepository: FetchHeroesImagesRepository?) {
        self.posterImagesRepository = posterImagesRepository
        self.model = model
        titleLabel.text = model.name
        updatePosterImage()
        accessibilityIdentifier = model.name
    }
    /// If we reuse the cell we perfom a clean up of the vairables
    override func prepareForReuse() {
        titleLabel.text = nil
        model = nil
        comicUIimage.image = nil
        comicUIimage.alpha = 0.0
        if let currentImageToken = currentImageToken  {
            posterImagesRepository?.cancelLoad(currentImageToken)
        }
        super.prepareForReuse()
    }
    
}

extension HeroesListItemCellTableViewCell {
    /// We download the image or maybe is already cached
    /// - Parameter model: We use the heroes model to retrieve the heroe image
    private func updatePosterImage() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        guard let posterImagePath = model?.imageUrl,
              let imageUrl = URL(string: posterImagePath) else { return }
        currentImageToken = posterImagesRepository?.loadImage(imageUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {  [weak self] in
                    guard let self = self else { return }
                    self.comicUIimage.image = UIImage(data: data)
                    self.animateThumbnail()
                    
                }
            case .failure:
                DispatchQueue.main.async {  [weak self] in
                    guard let self = self else { return }
                    self.comicUIimage.image = UIImage(named: "empty_state")
                    self.animateThumbnail()
                }
                if let currentImageToken = self.currentImageToken  {
                    self.posterImagesRepository?.cancelLoad(currentImageToken)
                }
            }
        }
    }
    
    func animateThumbnail() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.2,
                       options: .curveEaseInOut,
                       animations: {
                        self.loadingIndicator.isHidden = true
                        self.comicUIimage.alpha = 1.0
                       })
        
    }
}
