//
//  HomeVC.swift
//  BLETagDemo
//
//  Created by Nirzar Gandhi on 19/02/25.
//

import UIKit
import CoreBluetooth

class HomeVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    fileprivate let bluetoothManager = BluetoothManager.shared
    fileprivate lazy var discoveredPeripherals: [CBPeripheral] = []
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        self.setControlsProperty()
        
        self.bluetoothManager.delegate = self
        self.bluetoothManager.startScanning()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.bluetoothManager.stopScanning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        self.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    fileprivate func setControlsProperty() {
        
        self.view.backgroundColor = .black
        self.view.isOpaque = false
        
        // TableView
        self.tableView.backgroundColor = .clear
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.tableHeaderView?.backgroundColor = .clear
        self.tableView.tableFooterView?.backgroundColor = .clear
    }
}


// MARK: - Call Back
extension HomeVC {
}


// MARK: - BluetoothManager Delegate
extension HomeVC: BluetoothManagerDelegate {
    
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if RSSI.intValue > -70 {
            
            if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
                print("Manufacturer Data: \(manufacturerData)")
            }
            
            if !self.discoveredPeripherals.contains(peripheral) {
                self.discoveredPeripherals.append(peripheral)
                
                print("Device in range: \(peripheral.name ?? "Unknown") - RSSI: \(RSSI)")
                print("Discovered Peripheral: \(peripheral.identifier.uuidString), Name: \(peripheral.name ?? "")")
            }
        }
        
        self.tableView.reloadData()
    }
    
    func didConnectPeripheral(_ peripheral: CBPeripheral) {
        
        print("Connected to \(peripheral.name ?? "Unknown")")
        
        self.tableView.reloadData()
    }
    
    func didFailToConnectPeripheral(_ peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown")")
    }
    
    func didDisconnectPeripheral(_ peripheral: CBPeripheral, error: Error?) {
        
        print("Disconnected from \(peripheral.name ?? "Unknown")")
        
        self.tableView.reloadData()
    }
    
    func didUpdateValue(_ characteristic: CBCharacteristic, value: Data?) {
        
        if let data = value, let stringValue = String(data: data, encoding: .utf8) {
            print("Received data: \(stringValue)")
        }
    }
}


// MARK: -
// MARK: - UITableView DataSource
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discoveredPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.ClassName) as? HomeCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed(HomeCell.ClassName, owner: self, options: nil)
            cell = nib![0] as? HomeCell
        }
        
        cell?.configureCell(peripheral: self.discoveredPeripherals[indexPath.row])
        
        return cell!
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.discoveredPeripherals[indexPath.row].state != .connected {
            self.bluetoothManager.connect(to: self.discoveredPeripherals[indexPath.row])
        } else {
            self.bluetoothManager.disconnect(from: self.discoveredPeripherals[indexPath.row])
        }
    }
}
