//
//  ViewController.swift
//  techchallenge_jingluo
//
//  Created by JINGLUO on 26/1/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: WeatherViewModel?
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: setup UI
    
    fileprivate func setupUI() {
        setupTableView()
        setupCollectionView()
    }
    
    fileprivate func setupTableView() {
        dailyTableView.estimatedRowHeight = 80
        dailyTableView.rowHeight = UITableViewAutomaticDimension
        dailyTableView.register(DailyTableViewCell.nib(), forCellReuseIdentifier: DailyTableViewCell.reuseId())
        
        // MARK: set up tableview cell selected action
        dailyTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let dailyData = self.viewModel?.dailyDataWithIndex(indexPath)
                DispatchQueue.main.async {
                    self.updateThemeColor(dailyData?.icon, updateSummaryViewInfo: WeatherDisplayModel(city: nil, summary: dailyData?.summary, temperature: dailyData?.temperatureHigh))
                    
                    // Hide hourly collectionView
                    self.hideHourlyCollectionView(true, true)
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func setupCollectionView() {
        if let layout = hourlyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: hourlyCollectionView.frame.size.width/5, height: hourlyCollectionView.frame.size.height)
            layout.minimumLineSpacing = 1.0
        }

        hourlyCollectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyCollectionViewCell.reuseId())
    }

    // MARK: setup ViewModel
    
    fileprivate func configViewModel() {
        viewModel = WeatherViewModel(ApiClient())
        setupBinds()
    }
    
    fileprivate func setupBinds() {
        
        viewModel?.cityName.asObservable()
            .bind(to: self.cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: bind Top info view and background theme color by currently weather data
        viewModel?.weather.asObservable()
            .filter{$0 != nil}
            .subscribe(onNext: { w in
                DispatchQueue.main.async {
                    self.updateThemeColor(w?.currently?.icon, updateSummaryViewInfo: WeatherDisplayModel(city: nil, summary: w?.currently?.summary, temperature: w?.currently?.temperature))
                }
            }, onError: { error in
                print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        // MARK: bind daily data with dailyTableview
        viewModel?.dailyData.asObservable()
            .bind(to: dailyTableView.rx.items(cellIdentifier: DailyTableViewCell.reuseId(), cellType: DailyTableViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)

        // MARK: bind hourly data with hourlyCollectionView
        viewModel?.hourlyData?
            .bind(to: hourlyCollectionView.rx.items(cellIdentifier: HourlyCollectionViewCell.reuseId(), cellType: HourlyCollectionViewCell.self)) { (row, element, cell) in
                cell.layoutIfNeeded()
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: Actions
    
    @IBAction func tapGestureAction(_ sender: Any) {
        let weather = viewModel?.weather.value
        updateThemeColor(weather?.currently?.icon, updateSummaryViewInfo: WeatherDisplayModel(city: nil, summary: weather?.currently?.summary, temperature: weather?.currently?.temperature))
        
        // show hourly collectionView
        hideHourlyCollectionView(false, true)
    }
    
    // MARK: update UI
    
    fileprivate func updateThemeColor(_ icon: String?, updateSummaryViewInfo displayModel: WeatherDisplayModel?) {
        if let icon = icon, let colors = ThemeColor.fromDescription(icon)?.convertToColor() {
            self.gradientView.insertThemeColorLayer(colors)
        }
        
        self.updateSummaryView(displayModel)
    }
    
    fileprivate func updateSummaryView(_ weather: WeatherDisplayModel?) {
        self.summaryLabel.text = weather?.summary ?? ""
        self.temperatureLabel.text = "\(String.fromInt(Int((weather?.temperature ?? 0))))℉"
    }
    
    fileprivate func hideHourlyCollectionView(_ isHidden: Bool, _ animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.collectionViewHeightConstraint.constant = isHidden ? 0: 120
            self.view.layoutIfNeeded()
        }
    }

}


