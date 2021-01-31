//
//  ViewController.swift
//  CloneDataFriends
//
//  Created by gitaeklee on 2021/01/31.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

   
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    private var viewModel: MainViewModelType!
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = MainViewModel.init(language: "RxSwift")
        
        viewModel.outputs.navigationBarTitle
            .observeOn(MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.outputs.gitHubRepositories
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items) { tableView, row, githubRepository in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
                cell.textLabel?.text = "\(githubRepository.fullName)"
                cell.detailTextLabel?.textColor = UIColor.lightGray
                cell.detailTextLabel?.text = "\(githubRepository.description)"
                return cell
            }
            .disposed(by: disposeBag)


        viewModel.outputs.isLoading
            .observeOn(MainScheduler.instance)
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.outputs.isLoading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: $0 ? 50 : 0, right: 0)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let ac = UIAlertController(title: "Error \($0)", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(ac, animated: true)
            })
            .disposed(by: disposeBag)
        

        // Bind ViewModel Inputs
        tableView.rx.reachedBottom.asObservable()
            .bind(to: viewModel.inputs.reachedBottomTrigger)
            .disposed(by: disposeBag)

        viewModel.inputs.fetchTrigger.onNext(())
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach { [weak self] in
            self?.tableView.deselectRow(at: $0, animated: true)
        }
    }


}

extension ViewController: StoryboardInstantiable {}
