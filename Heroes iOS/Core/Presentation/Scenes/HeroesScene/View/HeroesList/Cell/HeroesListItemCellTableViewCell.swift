//
//  HeroesListItemCellTableViewCell.swift
//  Heroes iOS
//
//  Created by TR64UV on 11/11/2020.
//

import UIKit
typealias HeroesListItemDidSelectAction = ((HeroesModel) -> Void)
class HeroesListItemCellTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var comicUIimage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    static let reuseIdentifier = String(describing: HeroesListItemCellTableViewCell.self)
    static let height = CGFloat(84)
    let imageCache = NSCache<NSString, UIImage>()
    var heroeSelectedAction: HeroesListItemDidSelectAction?
    private var model: HeroesModel?
    
    func fill(with model: HeroesModel) {
        self.model = model
        titleLabel.text = model.name
        updatePosterImage(with: model)
    }
    
    override func prepareForReuse() {
        titleLabel?.text = nil
        self.comicUIimage.image = nil
        model = nil
        super.prepareForReuse()
    }
    
    private func updatePosterImage(with model: HeroesModel) {
        guard let posterImagePath = model.imageUrlPortraitSmall, let imageUrl = URL(string: posterImagePath) else { return }
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        self.comicUIimage.alpha = 0.0
        self.comicUIimage.downloadImage(from: imageUrl, cacheImage: imageCache) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadingIndicator.isHidden = true
                UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut,
                               animations: {
                                self.comicUIimage.alpha = 1.0
                               })
                
            }
            
        }
        
    }
    @IBAction func onHeroeSelected(_ sender: Any) {
        guard let model = model,
              let action = self.heroeSelectedAction else {
            return
        }
        action(model)
    }
}