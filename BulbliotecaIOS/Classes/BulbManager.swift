//
//  BulbManager.swift
//  BulbTest
//
//  Created by ADM Mobs2 on 21/10/20.
//

import Foundation
import CoreBluetooth

public class BulbManager : NSObject{
    
    private var centralManager: CBCentralManager!

    private var discoveredPeripheral: CBPeripheral!
    
    private let bulbCBUUID: CBUUID = CBUUID(string: "FF00")
    private let bulbPrincipalCBUUID = CBUUID(string: "FF02")
    private let bulbSecundarioCBUUID = CBUUID(string: "FF03")
    private let bulbMACBUUID = CBUUID(string: "FF0C")
    private let bulbBateriaCBUUID = CBUUID(string: "FF04")
    private let bulbNomeCBUUID = CBUUID(string: "FF09")
    
    public func startScan(centralManager: CBCentralManager){
        centralManager.scanForPeripherals(withServices: [bulbCBUUID])
    }
    public func stopScan(centralManager: CBCentralManager){
        centralManager.stopScan()
    }
    
    public func cancelPeripheralConnection() {
        centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
    }
    
    public func caracteristicasToRead () -> Array<CBUUID>{
        return [bulbPrincipalCBUUID,bulbSecundarioCBUUID,bulbMACBUUID,bulbBateriaCBUUID,bulbNomeCBUUID]
    }
    
    public func reconhecerBulb() -> Array<CBUUID>{
        return [bulbPrincipalCBUUID]
    }
    
    public func peripheralCharacteristic(characteristic: CBCharacteristic)-> Dictionary<String, String>{
        switch characteristic.uuid {
          case bulbPrincipalCBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
            let caracteristica:[String:String] = ["principal": data["major"] as? String ?? "No Value"]
            
            return (caracteristica)
              
          case bulbSecundarioCBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
            let caracteristica:[String:String] = ["secundario": data["minor"] as? String ?? "No Value"]
            return (caracteristica)
              
          case bulbMACBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
              let caracteristica:[String:String] = ["MAC": data["macAddress"] as? String ?? "No Value"]
            return (caracteristica)
              
          case bulbBateriaCBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
              let caracteristica:[String:String] = ["bateria": data["measurePower"] as? String ?? "No Value"]
            return (caracteristica)
              
          case bulbNomeCBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
              let caracteristica:[String:String] = ["name": data["bulbName"] as? String ?? "No Value"]
            return (caracteristica)
              
          default:
            return[:]
        }
        
    }
}


