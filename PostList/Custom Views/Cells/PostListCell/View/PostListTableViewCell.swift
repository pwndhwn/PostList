//
//  PostListTableViewCell.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 16/08/24.
//

import UIKit


class PostListTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel : UILabel!
    @IBOutlet weak private var detailLabel: UILabel!
    @IBOutlet weak private var favoriteButton: UIButton!
    
    var viewModel:PostListCellViewModel! {
        didSet {
            titleLabel.text = viewModel.getPostTitle()
            detailLabel.text = viewModel.getPostDescription()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    func updateFavoriteStatus(isFavorite: Bool) {
        let image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favoriteButton.setImage(image, for: .normal)
    }
    
    func hideFavoriteIcon() {
        favoriteButton.isHidden = true
    }
    
}
