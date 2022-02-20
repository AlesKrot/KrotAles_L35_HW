//
//  WeatherViewController.swift
//  MVVMCoordinator
//
//  Created by Max Bystryk on 17.02.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

//UIViewController in MVVM it's View component
class WeatherViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = WeatherViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performBinding()
    }
    
    func performBinding() {
        let disposable = button.rx.tap.withLatestFrom(textField.rx.text).subscribe(onNext: { self.viewModel.city.onNext($0!) })
        disposable.disposed(by: bag)
        
        viewModel.isLoadingInProcess.subscribe(onNext: { isLoading in
            self.activityIndicator.isHidden = !isLoading
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }).disposed(by: bag)
        
        Observable.zip(viewModel.city, viewModel.temperature).map { return "It's \($1) degrees in \($0)." }.bind(to: label.rx.text)
            .disposed(by: bag)
    }
}
