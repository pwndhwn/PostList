//
//  ViewController.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.register( UINib(nibName: Constants.Cell_ID_PostListTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Cell_ID_PostListTableViewCell )
        viewModel = HomeViewModel(apiManager: APIManager())
        super.viewDidLoad()
        setupBindings()
        guard let viewModel = viewModel as? HomeViewModel else { return }
        viewModel.requestAllPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = Constants.Page_Title_List
    }
    
    func setupBindings() {
        
        guard let viewModel = viewModel as? HomeViewModel else { return }
        
        viewModel
            .postDetails
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: Constants.Cell_ID_PostListTableViewCell, cellType: PostListTableViewCell.self)) { row, model, cell in
                let cellViewModel = PostListCellViewModel(postDetail: model)
                cell.viewModel = cellViewModel
                cell.updateFavoriteStatus(isFavorite: model.isFavorite)
            }.disposed(by: bag)
        
        tableView.rx.modelSelected(PostDetail.self)
            .subscribe(onNext: { post in
                viewModel.updateIsFavoriteStatus(post)
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected.bind {
            [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: false)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }.disposed(by: bag)
    }
}


