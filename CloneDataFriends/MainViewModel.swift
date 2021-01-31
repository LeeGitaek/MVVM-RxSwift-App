//
//  MainViewModel.swift
//  CloneDataFriends
//
//  Created by gitaeklee on 2021/01/31.
//

import UIKit
import RxCocoa
import RxSwift
import Action
import APIKit

protocol MainViewModelInputs {
    var fetchTrigger:PublishSubject<Void> { get }
    var reachedBottomTrigger:PublishSubject<Void> { get }
}

protocol MainViewModelOutputs {
    var navigationBarTitle:Observable<String> { get }
    var gitHubRepositories:Observable<[GitHubModel]> { get }
    var isLoading:Observable<Bool> { get }
    var error:Observable<NSError> { get }
}

protocol MainViewModelType {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

final class MainViewModel: MainViewModelType,MainViewModelInputs,MainViewModelOutputs {
    var inputs:MainViewModelInputs { return self }
    var outputs: MainViewModelOutputs { return self }
    
    
    // MARK: - Inputs
    let fetchTrigger = PublishSubject<Void>()
    let reachedBottomTrigger = PublishSubject<Void>()
    private let page = BehaviorRelay<Int>(value: 1)
    
    // MARK: - Outputs
    let navigationBarTitle: Observable<String>
    let gitHubRepositories: Observable<[GitHubModel]>
    let isLoading: Observable<Bool>
    let error: Observable<NSError>
    
    private let searchAction:Action<Int,[GitHubModel]>
    private let disposeBag = DisposeBag()
    
    init(language:String){
        self.navigationBarTitle = Observable.just("\(language) Repo")
        self.searchAction = Action { page in
            return Session.shared.rx.response(GitHubApi.SearchRequest(language: language, page: page))
        }
        let response = BehaviorRelay<[GitHubModel]>(value: [])
        self.gitHubRepositories = response.asObservable()
        
        self.isLoading = searchAction.executing.startWith(false)
        self.error = searchAction.errors.map { _ in
            NSError(domain:"network error",code:0,userInfo:nil)
        }
        
        
        
        searchAction.elements
            .withLatestFrom(response) { ($0, $1) }
            .map { $0.1 + $0.0 }
            .bind(to: response)
            .disposed(by: disposeBag)

        searchAction.elements
            .withLatestFrom(page)
            .map { $0 + 1 }
            .bind(to: page)
            .disposed(by: disposeBag)

        fetchTrigger
            .withLatestFrom(page)
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)

        reachedBottomTrigger
            .withLatestFrom(isLoading)
            .filter { !$0 }
            .withLatestFrom(page)
            .filter { $0 < 5 }
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)
        
        
    }
    
}
