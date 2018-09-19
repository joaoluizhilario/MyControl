//
//  MainViewController.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 05/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel!
    
    let refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = .clear
        refresh.tintColor = .lightGray
        refresh.attributedTitle = NSAttributedString(string: "Deslize para atualizar")
        return refresh
    }()
    
    lazy var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isUserInteractionEnabled = true
        collection.isMultipleTouchEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(DeviceTVCell.self, forCellWithReuseIdentifier: String(describing: DeviceTVCell.self))
        collection.contentInset = UIEdgeInsetsMake(8, 8, 8, 8)
        collection.alwaysBounceVertical = true
        refresh.addTarget(self, action: #selector(handleSearch), for: .valueChanged)
        collection.addSubview(refresh)
        return collection
    }()
    
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        view.trackTintColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        self.viewModel = SearchViewModel(delegate:self)
        super.viewDidLoad()
        setupViews()
        setupEvents()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.addSubview(collectionView)
        view.addSubview(progressView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: progressView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|[v0(2)][v1]-8-|", views: progressView, collectionView)
    }
    
    func setupEvents() {
        viewModel.reacheableTVs.bind { (devices) in
            DispatchQueue.main.async {
                self.refresh.removeTarget(self, action: #selector(self.handleSearch), for: .valueChanged)
                self.collectionView.reloadData()
            }
        }
        
        viewModel.progressValue.bind { (progressValue) in
            DispatchQueue.main.async {
                self.progressView.progress = progressValue
                if (self.viewModel.isScanRunning) {
                    let progress: Int = Int(progressValue * 100)
                    self.refresh.attributedTitle = NSAttributedString(string: "\(progress)%")
                }
            }
        }
        
        handleSearch()
    }
    
    @objc func handleSearch() {
        progressView.isHidden = false
        self.viewModel.startScanning()
    }
}

extension SearchViewController: SearchViewModelDelegate {
    
    func searchFinished() {
        progressView.isHidden = true
        
        self.refresh.endRefreshing()
        self.refresh.addTarget(self, action: #selector(self.handleSearch), for: .valueChanged)
        self.refresh.attributedTitle = NSAttributedString(string: "Deslize para atualizar")
        
        if (viewModel.reacheableTVs.value.count == 0) {
            Alert.showNoOneTVFound(on: self)
        }
    }
    
    func searchFailed() {}
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reacheableTVs.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DeviceTVCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DeviceTVCell.self), for: indexPath) as! DeviceTVCell
        let tv = viewModel.reacheableTVs.value[indexPath.item]
        cell.deviceInfo.text = tv.ipAddress
        cell.imageView.image = UIImage(named: String(format: "logo_%@", tv.brand.stringValue))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tv = viewModel.reacheableTVs.value[indexPath.item]
        Settings.shared.tv = tv
        navigationController?.pushViewController(RemoteControlViewController(tv), animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = (UIScreen.main.bounds.width / 2) - (13)
        return CGSize(width: size, height: size)
    }
}
