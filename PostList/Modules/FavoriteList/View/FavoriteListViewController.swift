//
//  FavoriteListViewController.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class FavoriteListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        
        tableView.register( UINib(nibName: "PostListTableViewCell", bundle: nil), forCellReuseIdentifier: "PostListTableViewCell" )
        viewModel = FavouriteListViewModel()
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Favorite List"
        guard let viewModel = viewModel as? FavouriteListViewModel else { return }
        viewModel.requestMyFavoritePosts()
    }
    
    func setupBindings() {
        
        guard let viewModel = viewModel as? FavouriteListViewModel else { return }
        
        viewModel
            .posts
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "PostListTableViewCell", cellType: PostListTableViewCell.self)) { row, model, cell in
                let cellViewModel = PostListCellViewModel(postDetail: model)
                cell.viewModel = cellViewModel
                cell.hideFavoriteIcon()
            }.disposed(by: bag)
        
        tableView.rx.modelSelected(PostDetail.self)
            .subscribe(onNext: { post in })
            .disposed(by: bag)
    }
}


