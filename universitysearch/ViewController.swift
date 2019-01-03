//
//  ViewController.swift
//  todoapp
//
//  Created by Benjamin Earley on 12/20/18.
//  Copyright © 2018 Benjamin Earley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

typealias UniversityModels = [UniversityModel]

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let cellIdentifier = "cellIdentifier"
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
        
        searchController.searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { $0.lowercased() }
            .map { UniversityRequest(name: $0) }
            .flatMapLatest { request -> Observable<UniversityModels> in
                return self.apiClient.send(apiRequest: request).asObservable()
            }
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { _, model, cell in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = model.description
                cell.textLabel?.adjustsFontSizeToFitWidth = true
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(UniversityModel.self)
            .map { URL(string: $0.webPages?.first ?? "")! }
            .map { SFSafariViewController(url: $0) }
            .subscribe(onNext: { [weak self] safariViewController in
                self?.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search For University"
        return searchController
    }()
    
    private func configureProperties() {
        navigationItem.searchController = searchController
        navigationItem.title = "University Finder"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
