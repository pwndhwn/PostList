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
        self.tabBarController?.title = "Post List"
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Basic_Cell_Identifier)
        viewModel = HomeViewModel(apiManager: APIManager())
        super.viewDidLoad()
        setupBindings()
        guard let viewModel = viewModel as? HomeViewModel else { return }
        viewModel.requestAllPosts()
    }
    
    func setupBindings() {
        
        guard let viewModel = viewModel as? HomeViewModel else { return }
        
        viewModel
            .postDetails
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: Constants.Basic_Cell_Identifier, cellType: UITableViewCell.self)) { row, model, cell in
                cell.textLabel?.text = model.title
                cell.accessoryType = model.isFavorite ? .checkmark : .none
            }.disposed(by: bag)
        
        tableView.rx.modelSelected(PostDetail.self)
            .subscribe(onNext: { post in
                let realm = try! Realm()
                let results = realm.objects(PostDetail.self).filter("id = \(post.id ?? 0)")
                if let post = results.first {
                    try! realm.write {
                        post.isFavorite = !post.isFavorite
                    }
                }
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected.bind {
            [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: false)
            if let cell = self.tableView.cellForRow(at: indexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .checkmark
                }
            }
        }.disposed(by: bag)
    }
}


