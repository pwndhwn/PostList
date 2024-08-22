//
//  ViewController.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import UIKit
import RxSwift
import RealmSwift

class HomeViewController: BaseViewController {
    
    private var isUsingRxSwift = true
    @IBOutlet private weak var tableView: UITableView!
    
    private var list:[PostDetail]?
    
    override func viewDidLoad()
    {
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.register( UINib(nibName: Constants.Cell_ID_PostListTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Cell_ID_PostListTableViewCell )
        viewModel = HomeViewModel(apiManager: APIManager())
        if isUsingRxSwift {
            setupBindings()
        } else {
            tableView.dataSource = self
            tableView.delegate = self
        }
        super.viewDidLoad()
        guard let viewModel = viewModel as? HomeViewModel else { return }
        viewModel.delegate = !isUsingRxSwift ? self : nil
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

extension HomeViewController: HomeViewModelDelegate {
    
    func updateList(list: [PostDetail]) {
        self.list = list
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell_ID_PostListTableViewCell) as! PostListTableViewCell
        if let item = list?[indexPath.row] {
            let cellViewModel = PostListCellViewModel(postDetail: item)
            cell.viewModel = cellViewModel
            cell.updateFavoriteStatus(isFavorite: item.isFavorite)
        }
        return cell;
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? HomeViewModel else { return }
        if let item = list?[indexPath.row] {
            viewModel.updateIsFavoriteStatus(item)
            tableView.reloadRows(at: [indexPath], with: .none)
            
        }        
    }
}
