//
//  WeatherViewModel.swift
//  MVVMCoordinator
//
//  Created by Max Bystryk on 17.02.2022.
//

import Foundation
import RxSwift
import RxRelay

class WeatherViewModel {
    let dataLoader = WeatherDataLoader()
    
    let temperature = PublishSubject<Double>()
    let city = PublishSubject<String>()
    let isLoadingInProcess = BehaviorSubject<Bool>(value: false)
    
    let bag = DisposeBag()
    
    init() {
        performBinding()
    }
    
    func performBinding() {
        city.subscribe(onNext: { self.loadWeather(for: $0) } ).disposed(by: bag)
    }
    
    func loadWeather(for city: String) {
        isLoadingInProcess.onNext(true)
        dataLoader.loadWeatherData(forCity: city) { data, error in
            self.isLoadingInProcess.onNext(false)
            guard let temperature = data?.mainWeatherData?.temperature else { return }
            self.temperature.onNext(temperature)
        }
        
        print("Doing some other work")
    }
}
