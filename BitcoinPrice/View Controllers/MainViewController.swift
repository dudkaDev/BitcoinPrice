//
//  MainViewController.swift
//  BitcoinPrice
//
//  Created by Андрей Абакумов on 05.11.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var currencySegmentedControl: UISegmentedControl!
    
    enum Alert {
        case success
        case failed
        
        var title: String {
            switch self {
            case .success:
                return "Success"
            case .failed:
                return "Failed"
            }
        }
        var message: String {
            switch self {
            case .success:
                return "You can see the results in the Debug area"
            case.failed:
                return "You can see error in the Debug area"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        rateLabel.isHidden = true
        timeLabel.isHidden = true
        
        fetchData()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        
    }
}
    
// MARK: - Networking
extension MainViewController {
    func fetchData() {
        guard let url = URL(string: Link.bitcoinPriceApi.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let bitcoin = try decoder.decode(Bitcoin.self, from: data)
                print(bitcoin)
                
            } catch let error {
                print(error.localizedDescription)
                
            }
            
        }.resume()
    }
}

