//
//  ViewController.swift
//  BulbliotecaIOS
//
//  Created by Mobs2sdk on 10/26/2020.
//  Copyright (c) 2020 Mobs2sdk. All rights reserved.
//

import UIKit
import CoreBluetooth

import BulbliotecaIOS

class ViewController: UIViewController {
    
    private var centralManager: CBCentralManager!
    private var discoveredPeripheral: CBPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: CBCentralManagerDelegate {
 
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
             ("central.state desconhecido")
        case .resetting:
            print("central.state reiniciando")
        case .unsupported:
            print("central.state não suportado")
        case .unauthorized:
            print("central.state não autorizado")
        case .poweredOff:
            print("central.state Desligado")
        case .poweredOn:
            print("central.state Ligado")
            BulbManager().startScan(centralManager: centralManager)

        @unknown default:
            print("@unknown default")

        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if discoveredPeripheral != peripheral {
            discoveredPeripheral = peripheral
            
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        BulbManager().stopScan(centralManager: centralManager)
        peripheral.delegate = self
        peripheral.discoverServices(BulbManager().reconhecerBulb())
    }
    
    
}

extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            peripheral.discoverCharacteristics(BulbManager().caracteristicasToRead(), for: service)
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
      guard let characteristics = service.characteristics else { return }

      for characteristic in characteristics {
        if characteristic.properties.contains(.read) {
            peripheral.readValue(for: characteristic)
        }
        
      }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let bulb = BulbManager().peripheralCharacteristic(characteristic: characteristic)
        print(bulb)
        BulbManager().cancelPeripheralConnection()
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        BulbManager().startScan(centralManager: centralManager)
    }
}


