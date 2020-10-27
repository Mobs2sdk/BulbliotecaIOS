//
//  BulbManager.swift
//  BulbTest
//
//  Created by ADM Mobs2 on 21/10/20.
//

import Foundation
import CoreBluetooth

class BulbManager : NSObject{
    
    private var centralManager: CBCentralManager!

    private var bulbPeripheral: CBPeripheral!
    
    let bulbCBUUID: CBUUID = CBUUID(string: "FF00")
    let bulbPrincipalCBUUID = CBUUID(string: "FF02")
    let bulbSecundarioCBUUID = CBUUID(string: "FF03")
    let bulbMACBUUID = CBUUID(string: "FF0C")
    let bulbBateriaCBUUID = CBUUID(string: "FF04")
    let bulbNomeCBUUID = CBUUID(string: "FF09")
    
    func startScan(centralManager: CBCentralManager){
        centralManager.scanForPeripherals(withServices: [bulbCBUUID])
    }
    func stopScan(centralManager: CBCentralManager){
        centralManager.stopScan()
    }
    
    func peripheralCharacteristic(characteristic: CBCharacteristic){
        switch characteristic.uuid {
          case bulbPrincipalCBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
              let caracteristica = data["major"]
              print(caracteristica ?? "No Principal")
          case bulbSecundarioCBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
              let caracteristica = data["minor"]
              print(caracteristica ?? "No Secundario")
          case bulbMACBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
              let caracteristica = data["macAddress"]
              print(caracteristica ?? "No MAC")
          case bulbBateriaCBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
              let caracteristica = data["measurePower"]
              print(caracteristica ?? "No Bateria")
          case bulbNomeCBUUID:
              let returnData = BulbDataParser.parseReadData(from: characteristic)["returnData"]
              let data:NSDictionary = returnData as! NSDictionary
              let caracteristica = data["bulbName"]
              print(caracteristica ?? "No Nome")
          default:
            return
        }
    }
}


