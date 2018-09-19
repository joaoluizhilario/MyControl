//
//  MainPresenter.swift
//  MMLanScanSwiftDemo
//
//  Created by Michalis Mavris on 06/11/2016.
//  Copyright © 2016 Miksoft. All rights reserved.
//

import Foundation

protocol SearchViewModelDelegate {
    func searchFinished()
    func searchFailed()
}

class SearchViewModel: NSObject, MMLANScannerDelegate {
    
    private var connectedDevices : Box<[MMDevice]>! = Box([])
    var reacheableTVs : Box<[SmartTV]>! = Box([])
    var progressValue : Box<Float> = Box(0.0)
    var isScanRunning : BooleanLiteralType = false
    
    var lanScanner : MMLANScanner!
    var delegate : SearchViewModelDelegate?
    
    init(delegate:SearchViewModelDelegate?) {
        super.init()
        self.delegate = delegate!
        self.lanScanner = MMLANScanner(delegate:self)
    }
    
    func startScanning() {
        self.reacheableTVs.value = []
        if (self.isScanRunning) {
            self.stopNetWorkScan()
        } else {
            self.startNetWorkScan()
        }
    }
    
    func startNetWorkScan() {
        if (self.isScanRunning) {
            self.stopNetWorkScan()
            self.connectedDevices.value.removeAll()
        }
        else {
            self.connectedDevices.value.removeAll()
            self.isScanRunning = true
            self.lanScanner.start()
        }
    }
  
    func stopNetWorkScan() {
        self.lanScanner.stop()
        self.isScanRunning = false
    }
    
    func ssidName() -> String {
        return LANProperties.fetchSSIDInfo()
    }
    
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        if(!self.connectedDevices.value.contains(device)) {
            TVBrand.keys().forEach { (brand) in
                ApiTV.factory(brand: brand).tryFetchServerForAddress(address: device.ipAddress) { (found) in
                    if (found) {
                        self.connectedDevices.value.append(device)
                        self.reacheableTVs.value.append(SmartTV(ipAddress: device.ipAddress, brand: brand, macAddress: device.macAddressLabel()))
                    }
                }
            }
        }

        let ipSortDescriptor = NSSortDescriptor(key: "ipAddress", ascending: true)
        self.connectedDevices.value = (self.connectedDevices.value as NSArray).sortedArray(using: [ipSortDescriptor]) as! Array
    }
    
    func lanScanDidFailedToScan() {
        self.isScanRunning = false
        self.delegate?.searchFailed()
    }
    
    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        self.isScanRunning = false
        if (status == MMLanScannerStatusFinished) {   
            self.delegate?.searchFinished()
        }
    }
    
    func lanScanProgressPinged(_ pingedHosts: Float, from overallHosts: Int) {
        self.progressValue.value = pingedHosts / Float(overallHosts)
    }
}
