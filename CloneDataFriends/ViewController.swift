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

    static func make(with viewModel:MainViewModel) -> ViewController {
        let view = ViewController.instantiate()
        view.viewModel = viewModel
        return view
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    private var viewModel: MainViewModelType!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.bind()
        // Do any additional setup after loading the view.
    }
    
    func bind()
    {
        
    }


}

extension ViewController: StoryboardInstantiable {}
