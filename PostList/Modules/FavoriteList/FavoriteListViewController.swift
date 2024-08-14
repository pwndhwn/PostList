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
        self.title = "Favorite List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Basic_Cell_Identifier)
        viewModel = FavouriteListViewModel()
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let viewModel = viewModel as? FavouriteListViewModel else { return }
        viewModel.requestMyFavoritePosts()
    }
    
    func setupBindings() {
        
        guard let viewModel = viewModel as? FavouriteListViewModel else { return }
        
        viewModel
            .posts
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: Constants.Basic_Cell_Identifier, cellType: UITableViewCell.self)) { row, model, cell in
                cell.textLabel?.text = model.title
                cell.detailTextLabel?.text = model.body
            }.disposed(by: bag)
        
        tableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { post in
                print(post.title)
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected.bind {
            [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: false)
            if let cell = self.tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
        }.disposed(by: bag)
    }
}


