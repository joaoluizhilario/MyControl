//
//  MainViewController.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 05/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var myContext = 0
    var presenter: MainPresenter!
    
    let centerLabel: UILabel = {
        let label = UILabel()
        label.text = "Carregando..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()
    
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        view.trackTintColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tentar novamente", for: .normal)
        button.setTitleColor(view.tintColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)
        return button
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViews()
        self.presenter = MainPresenter(delegate:self)
        
        self.addObserversForKVO()
        handleComplete()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(centerLabel)
        view.addSubview(indicator)
        view.addSubview(progressView)
        view.addSubview(completeButton)
        
        view.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: centerLabel)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: progressView)
        view.addConstraintsWithFormat(format: "V:|[v0(2)]", views: progressView)
        
        view.addConstraintsWithFormat(format: "V:[v0]-30-|", views: completeButton)
        completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        centerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.75).isActive = true
        
        indicator.topAnchor.constraint(equalTo: centerLabel.bottomAnchor, constant: 10).isActive = true
        indicator.centerXAnchor.constraint(equalTo: centerLabel.centerXAnchor).isActive = true
    }
    
    //MARK: - KVO Observers
    func addObserversForKVO ()->Void {
        self.presenter.addObserver(self, forKeyPath: "connectedDevices", options: .new, context:&myContext)
        self.presenter.addObserver(self, forKeyPath: "progressValue", options: .new, context:&myContext)
        self.presenter.addObserver(self, forKeyPath: "isScanRunning", options: .new, context:&myContext)
    }
    
    func removeObserversForKVO() -> Void {
        self.presenter.removeObserver(self, forKeyPath: "connectedDevices")
        self.presenter.removeObserver(self, forKeyPath: "progressValue")
        self.presenter.removeObserver(self, forKeyPath: "isScanRunning")
    }
    
    @objc func handleComplete() {
        if (ApiTV.shared.isFound) {
            navigationController?.pushViewController(RemoteControlViewController(), animated: true)
        } else {
            completeButton.isHidden = true
            progressView.isHidden = false
            indicator.startAnimating()
            self.presenter.scanButtonClicked()
        }
    }
    
    //MARK: - Alert Controller
    func showAlert(title:String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in}
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - KVO
    //This is the KVO function that handles changes on MainPresenter
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (context == &myContext) {
            switch keyPath! {
            case "connectedDevices":
                self.centerLabel.text = "Dispositivos encontrados na rede: \(self.presenter.connectedDevices.count)"
                if (!ApiTV.shared.isFound) {
                    if (self.presenter.connectedDevices.count > 0) {
                        let device: MMDevice = self.presenter.connectedDevices[self.presenter.connectedDevices.count-1]
                        ApiTV.shared.tryFetchServerForAddress(address: device.ipAddress)
                    }
                }
            case "progressValue":
                self.progressView.progress = self.presenter.progressValue
            default:
                print("Not valid key for observing")
            }
        }
    }
    
    //MARK: - Deinit
    deinit {
        self.removeObserversForKVO()
    }
}

extension SearchViewController: MainPresenterDelegate {
    //MARK: - Presenter Delegates
    //The delegates methods from Presenters.These methods help the MainPresenter to notify the MainVC for any kind of changes
    func mainPresenterIPSearchFinished() {
        indicator.stopAnimating()
        progressView.isHidden = true
        completeButton.isHidden = false
        if (ApiTV.shared.isFound) {
            completeButton.setTitle("Continuar", for: .normal)
            ApiTV.shared.tvSystemInfo { (system: TVSystem?, error: String?) in
                DispatchQueue.main.async {
                    self.centerLabel.text = "\(system!.name!) foi encontrada \u{1F60E}"
                }
            }
        } else {
            completeButton.setTitle("Tentar novamente", for: .normal)
            centerLabel.text = "Sua TV não foi encontrada \u{1F615}"
        }
    }
    func mainPresenterIPSearchFailed() {}
    func mainPresenterIPSearchCancelled() {}
}
