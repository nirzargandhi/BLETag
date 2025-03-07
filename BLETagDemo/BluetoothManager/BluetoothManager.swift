//
//  BluetoothManager.swift
//  BLETagDemo
//
//  Created by Nirzar Gandhi on 19/02/25.
//

import Foundation
import CoreBluetooth
import UIKit

protocol BluetoothManagerDelegate {
    
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    func didConnectPeripheral(_ peripheral: CBPeripheral)
    func didFailToConnectPeripheral(_ peripheral: CBPeripheral, error: Error?)
    func didDisconnectPeripheral(_ peripheral: CBPeripheral, error: Error?)
    func didUpdateValue(_ characteristic: CBCharacteristic, value: Data?)
}

class BluetoothManager: NSObject {
    
    // MARK: - Properties
    static let shared: BluetoothManager = {
        let instance = BluetoothManager()
        return instance
    }()
    
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    var delegate: BluetoothManagerDelegate?
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main, options: [CBCentralManagerOptionShowPowerAlertKey: false])
    }
}

// MARK: - Call Back
extension BluetoothManager {
    
    func startScanning() {
        
        guard self.centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on")
            return
        }
        
        self.centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func stopScanning() {
        self.centralManager.stopScan()
    }
    
    func connect(to peripheral: CBPeripheral) {
        self.centralManager.connect(peripheral, options: nil)
    }
    
    func disconnect(from peripheral: CBPeripheral) {
        self.centralManager.cancelPeripheralConnection(peripheral)
    }
    
    fileprivate func showAlertMessage(titleStr : String) {
        
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(
            title: titleStr,
            message: "Please take necessary action to enable Bluetooth",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        rootVC.present(alert, animated: true)
    }
}


// MARK: - CBCentralManager Delegate
extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
            
        case .poweredOff:
            self.showAlertMessage(titleStr: "Bluetooth is off")
            
        case .poweredOn:
            self.startScanning()
            
        case .resetting:
            print("resetting")
            
        case .unauthorized:
            self.showAlertMessage(titleStr: "Bluetooth is unauthorized")
            
        case .unsupported:
            self.showAlertMessage(titleStr: "Bluetooth is unsupported")
            
        case .unknown:
            self.showAlertMessage(titleStr: "Unknown state")
            
        @unknown default:
            fatalError()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.delegate?.didDiscoverPeripheral(peripheral, advertisementData: advertisementData, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        self.connectedPeripheral = peripheral
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        self.delegate?.didConnectPeripheral(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.delegate?.didFailToConnectPeripheral(peripheral, error: error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        if self.connectedPeripheral == peripheral {
            self.connectedPeripheral = nil
        }
        
        self.delegate?.didDisconnectPeripheral(peripheral, error: error)
    }
}


// MARK: - CBPeripheral Delegate
extension BluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        peripheral.services?.forEach { peripheral.discoverCharacteristics(nil, for: $0) }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard error == nil else {
            print("Error discovering characteristics: \(error!.localizedDescription)")
            return
        }
        
        service.characteristics?.forEach { peripheral.readValue(for: $0) }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        self.delegate?.didUpdateValue(characteristic, value: characteristic.value)
    }
}
