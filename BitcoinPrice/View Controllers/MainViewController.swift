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
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var currencySegmentedControl: UISegmentedControl!
    
    @IBOutlet var refreshButtonOutlet: UIBarButtonItem!
    @IBOutlet var timerLabel: UILabel!
    
    
    private var data: Bitcoin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        rateLabel.isHidden = true
        dateLabel.isHidden = true
        timerLabel.isHidden = true
        
        fetchData()
    }
    
    @IBAction func currencySelection() {
        fetchData()
    }
    
    @IBAction func refreshButtonTapped(_: UIBarButtonItem) {
        fetchData()
        refreshButtonOutlet.isEnabled = false
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.enableRefreshButton), userInfo: nil, repeats: false)
        showAlert(title: "Внимание", message: "Курс можно обновлять раз в 60 секунд")
        
        countdownRefreshButton()
    }
    
    @objc func enableRefreshButton() {
        refreshButtonOutlet.isEnabled = true
        timerLabel.isHidden = true
    }
}
    
// MARK: - Private methods
extension MainViewController {
    
    private func fetchData() {
        NetworkManager.shared.fetchData(from: Link.bitcoinPriceApi.rawValue) { [weak self] result in
            switch result {
            case .success(let bitcoin):
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
                self?.rateLabel.isHidden = true
                self?.dateLabel.isHidden = true
                self?.title = bitcoin.chartName
                self?.dateLabel.text = bitcoin.time.updated
                if self?.currencySegmentedControl.selectedSegmentIndex == 0 {
                    self?.rateLabel.text = "\(bitcoin.bpi.USD.rateFloat) $"
                } else {
                    self?.rateLabel.text = "\(bitcoin.bpi.EUR.rateFloat) €"
                }
                self?.activityIndicator.stopAnimating()
                self?.rateLabel.isHidden = false
                self?.dateLabel.isHidden = false
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func countdownRefreshButton() {
        var secondsRemaining = 59
        timerLabel.isHidden = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            
            if secondsRemaining > 0 {
                self?.timerLabel.text = "\(secondsRemaining)"
                secondsRemaining -= 1
            }
        }
    }
}
