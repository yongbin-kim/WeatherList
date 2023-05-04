//
//  ViewController.swift
//  WeatherList
//
//  Created by ybKim on 2023/04/28.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ViewModel()
    
    lazy var Indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        indicator.center = self.view.center
        indicator.color = .black
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.stopAnimating()
        
        return indicator
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(weatherHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableView.register(UINib.init(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.view.addSubview(Indicator)
        self.getWeatherData()
    }
    
    func getWeatherData() {
        Indicator.startAnimating()
        
        DispatchQueue.global().async {
            self.viewModel.geoList.forEach { item in
                self.viewModel.getGeoData(item) { [weak self] success,fail in
                    DispatchQueue.main.async {
                        guard let `self` = self, let geo = success?.first else {
                            self?.Indicator.stopAnimating()
                            
                            let alert: UIAlertController = .init(title: "지역 위치정보를 받아오는데 실패하였습니다", message: "다시 실행해주세요", preferredStyle: .alert)
                            alert.addAction(.init(title: "확인", style: .default, handler: { _ in
                                exit(0)
                            }))
                            self?.present(alert, animated: true, completion: nil)
                            
                            return
                        }
                        
                        self.viewModel.getData(geo) { [weak self] success,fail in
                            guard let `self` = self, var weather = success else {
                                self?.Indicator.stopAnimating()
                                
                                let alert: UIAlertController = .init(title: "날씨 정보를 받아오는데 실패하였습니다", message: "다시 실행해주세요", preferredStyle: .alert)
                                alert.addAction(.init(title: "확인", style: .default, handler: { _ in
                                    exit(0)
                                }))
                                self?.present(alert, animated: true, completion: nil)
                                
                                return
                            }
                            
                            weather.list?.removeLast(2)
                            
                            var dic: [String: [WeatherList]] = [:]
                            dic[geo.name!] = weather.list
                            
                            self.viewModel.sections.append(contentsOf: dic.map { key, value -> WeatherSection in
                                    .init(location: key, weather: value)
                            })
                            
                            if self.viewModel.sections.count > 2 {
                                self.viewModel.sections.sort { $0.location > $1.location }
                                
                                self.Indicator.stopAnimating()
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.sections.count > 0 {
            return viewModel.sections.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.sections.count == 0 {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.sections.count > 0 {
            return viewModel.sections[section].weather!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! weatherHeader
        view.title.text = viewModel.sections[section].location
        view.title.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else {
            return UITableViewCell()
        }
        
        guard let weather = viewModel.sections[indexPath.section].weather?[indexPath.row] else { return cell }
        
        let celsiusMax = Int(weather.temp?.max?.toCelsius ?? 0)
        let celsiusMin = Int(weather.temp?.min?.toCelsius ?? 0)
        let weatherDate = Date(timeIntervalSince1970: Double(weather.dt ?? 0))
        let strWeatherDate = ""
        
        cell.weatherImg.image = UIImage(named: weather.weatherInfo?.first?.icon?.toStrWeatherImage ?? "Clear")
        cell.dateLabel.text = strWeatherDate.stringToDate(date: weatherDate)
        cell.weatherTitle.text = weather.weatherInfo?.first?.main
        cell.weatherMax.text = "max: \(celsiusMax)℃"
        cell.weatherMin.text = "min: \(celsiusMin)℃"
        
        cell.selectionStyle = .none
        
        return cell
    }
}

class weatherHeader: UITableViewHeaderFooterView {
    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(equalToConstant: 40),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
