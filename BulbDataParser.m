//
//  BulbDataParser.m
//  testSDK
//

#import "BulbDataParser.h"
#import "BulbService.h"
#import "BulbRegularsDefine.h"
#import "BulbParser.h"
#import "BulbTaskIDDefines.h"

NSString *const BulbCommunicationDataNum = @"BulbCommunicationDataNum";

@implementation BulbDataParser

#pragma mark - Public method
+ (NSDictionary *)parseReadDataFromCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return nil;
    }
    NSData *readData = characteristic.value;
    if (!BulbValidData(readData)) {
        return nil;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbUUID]]){
        //Leia o UUID do bulb
        return [self parseUUIDData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbMajor]]){
        //Leia o valor principal do bulb
        return [self parseMajorData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbMinor]]){
        //Leia o valor secundário do bulb
        return [self parseMinorData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbMeasurePower]]){
        //Leia a distância de calibração do bulb
        return [self parseMeasurePowerData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbTransmission]]){
        //Leia a potência de transmissão do bulb
        return [self parseTransmissionData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbChangePassword]]){
        //Reiniciar senha
        return [self parseSetPassword:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbBroadcastInterval]]){
        //Leia o período de transmissão
        return [self parseBroadcastIntervalData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbDeviceID]]){
        //Leia a identificação do dispositivo
        return [self parseDeviceIDData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbDeviceName]]){
        //Leia o nome
        return [self parseDeviceNameData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbMacAddress]]){
        //Leia o endereço MAC
        return [self parseMacAddressData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbConnectMode]]){
        //Leia o status conectável
        return [self parseConnectStatus:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbElapsedTime]]){
        //Leia o tempo de funcionamento e o tipo de chip
        return [self parseBulbElapsedTimeCharactersValue:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbBattery]]){
        //energia da bateria
        return [self parseBatteryData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbSystemID]]){
        //Marca do Sistema
        return [self parseSystemIDData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbModeID]]){
        //Informações do modelo do produto
        return [self parseModeIDData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbProductionDate]]){
        //Leia a data de produção
        return [self parseProductionDateData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbFirmware]]){
        //Informação de firmware
        return [self parseFirmwareData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbHardware]]){
        //informação de hardware
        return [self parseHardwareData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbSoftware]]){
        //Versão do software
        return [self parseSoftwareData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbVendor]]){
        //Informação do fabricante
        return [self parseVendorData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbIEEEInfo]]){
        //Padrão IEEE
        return [self parseIEEEInfoData:readData];
    }
    return nil;
}

+ (NSDictionary *)parseWriteDataFromCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return nil;
    }
    BulbTaskOperationID operationID = BulbTaskDefaultOperation;
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbUUID]]){
        //UUID
        operationID = BulbSetBulbUUIDOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbMajor]]){
        //Majo
        operationID = BulbSetBulbMajorOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbMinor]]){
        //Minor
        operationID = BulbSetBulbMinorOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbMeasurePower]]){
        //Distância de calibração
        operationID = BulbSetBulbMeasurePowerOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbTransmission]]){
        //Transmissão de potência
        operationID = BulbSetBulbTransmissionOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbBroadcastInterval]]){
        //ciclo de transmissão
        operationID = BulbSetBulbBroadcastIntervalOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbDeviceID]]){
        //ID do dispositivo
        operationID = BulbSetBulbDeviceIDOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbDeviceName]]){
        //Nome
        operationID = BulbSetBulbNameOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbConnectMode]]){
        //Estado conectável
        operationID = BulbSetBulbConnectModeOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbSoftReboot]]){
        //Reinicio
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbHeartBeat]]){
        //Batimento
        operationID = BulbHeartBeatOperation;
    }
    return [self dataParserGetDataSuccess:@{} operationID:operationID];
}

#pragma mark - Private method
+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(BulbTaskOperationID)operationID{
    if (!returnData) {
        return nil;
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

#pragma mark - data parse
+ (NSDictionary *)parseUUIDData:(NSData *)readData{
    if (!BulbValidData(readData) || readData.length != 16) {
        return nil;
    }
    NSString *content = [BulbParser hexStringFromData:readData];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:5];
    [list addObject:[content substringWithRange:NSMakeRange(0, 8)]];
    [list addObject:[content substringWithRange:NSMakeRange(8, 4)]];
    [list addObject:[content substringWithRange:NSMakeRange(12, 4)]];
    [list addObject:[content substringWithRange:NSMakeRange(16,4)]];
    [list addObject:[content substringWithRange:NSMakeRange(20, 12)]];
    [list insertObject:@"-" atIndex:1];
    [list insertObject:@"-" atIndex:3];
    [list insertObject:@"-" atIndex:5];
    [list insertObject:@"-" atIndex:7];
    NSString *uuid = @"";
    for (NSString *string in list) {
        uuid = [uuid stringByAppendingString:string];
    }
    return [self dataParserGetDataSuccess:@{@"uuid":[uuid uppercaseString]} operationID:BulbReadUUIDOperation];
}

+ (NSDictionary *)parseMajorData:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                     @"major":[BulbParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                     }
                              operationID:BulbReadMajorOperation];
}

+ (NSDictionary *)parseMinorData:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"minor":[BulbParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                            }
                              operationID:BulbReadMinorOperation];
}

+ (NSDictionary *)parseMeasurePowerData:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"measurePower":[BulbParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                            }
                              operationID:BulbReadMeasurePowerOperation];
}

+ (NSDictionary *)parseTransmissionData:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"transmission":[BulbParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                            }
                              operationID:BulbReadTransmissionOperation];
}

+ (NSDictionary *)parseBroadcastIntervalData:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"broadcastInterval":[BulbParser getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
                                            }
                              operationID:BulbReadBroadcastIntervalOperation];
}

+ (NSDictionary *)parseDeviceIDData:(NSData *)readData{
    NSString *deviceID = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!BulbValidStr(deviceID)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"deviceID":deviceID,
                                            }
                              operationID:BulbReadDeviceIDOperation];
}

+ (NSDictionary *)parseDeviceNameData:(NSData *)readData{
    NSString *deviceName = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!BulbValidStr(deviceName)) {
        return nil;
    }
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    if (!BulbValidStr(deviceName)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"bulbName":deviceName,
                                            }
                              operationID:BulbReadDeviceNameOperation];
}

+ (NSDictionary *)parseMacAddressData:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content) || content.length != 12) {
        return nil;
    }
    NSString *macAddress = @"";
    for (NSInteger i = 0; i < 6; i ++) {
        NSString *tempStr = [content substringWithRange:NSMakeRange(i * 2, 2)];
        if (i != 0) {
            tempStr = [@":" stringByAppendingString:tempStr];
        }
        macAddress = [macAddress stringByAppendingString:tempStr];
    }
    return [self dataParserGetDataSuccess:@{
                                            @"macAddress":[macAddress uppercaseString],
                                            }
                              operationID:BulbReadMacAddressOperation];
}

+ (NSDictionary *)parseConnectStatus:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content) || content.length != 2) {
        return nil;
    }
    BOOL connectStatus = [content isEqualToString:@"00"];
    return [self dataParserGetDataSuccess:@{
                                            @"connectStatus":@(connectStatus),
                                            }
                              operationID:BulbReadConnectStatusOperation];
}

+ (NSDictionary *)parseBulbElapsedTimeCharactersValue:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content) || content.length < 4) {
        return nil;
    }
    NSString *header = [content substringToIndex:2];
    if (![header isEqualToString:@"eb"]) {
        return nil;
    }
    NSInteger len = strtoul([[content substringWithRange:NSMakeRange(6, 2)] UTF8String],0,16);
    if (content.length != (8 + 2 * len)) {
        return nil;
    }
    NSString *function = [content substringWithRange:NSMakeRange(2, 2)];
    NSDictionary *returnData = nil;
    BulbTaskOperationID operationID = BulbTaskDefaultOperation;
    if ([function isEqualToString:@"59"]) {
        //Horas de operação
        returnData = @{
                       @"elapsedTime":[BulbParser getDecimalStringWithHex:content range:NSMakeRange(8, 2 * len)],
                       };
        operationID = BulbReadElapsedTimeOperation;
    }else if ([function isEqualToString:@"5b"]){
        NSData *subData = [readData subdataWithRange:NSMakeRange(4, len)];
        NSString *hardwareModul = [[NSString alloc] initWithData:subData encoding:NSUTF8StringEncoding];
        if (!BulbValidStr(hardwareModul)) {
            return nil;
        }
        returnData = @{
                       @"hardwareModul":hardwareModul,
                       };
        operationID = BulbReadHardwareModuleOperation;
    }else if ([function isEqualToString:@"6c"]){
        NSString *string = [content substringWithRange:NSMakeRange(8, 2)];
        if ([string isEqualToString:@"00"]) {
            returnData = @{};
            operationID = BulbStartReadXYZDataOperation;
        }else if ([string isEqualToString:@"01"]){
            returnData = @{};
            operationID = BulbStopReadXYZDataOperation;
        }
    }else if ([function isEqualToString:@"6d"]) {
        NSString *string = [content substringFromIndex:(content.length - 2)];
        operationID = BulbSetBulbPowerOffOperation;
        returnData = @{@"powerOffSuccess" : @([string isEqualToString:@"aa"])};
    }
    return [self dataParserGetDataSuccess:returnData operationID:operationID];
}

+ (NSDictionary *)parseBatteryData:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content) || content.length != 2) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"battery":[BulbParser getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
                                            }
                              operationID:BulbReadBatteryOperation];
}

+ (NSDictionary *)parseSystemIDData:(NSData *)readData{
    NSString *systemID = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(systemID)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                     @"systemID":systemID,
                                     }
                              operationID:BulbReadSystemIDOperation];
}

+ (NSDictionary *)parseVendorData:(NSData *)readData{
    NSString *vendorData = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!BulbValidStr(vendorData)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"vendor":vendorData,
                                            }
                              operationID:BulbReadVendorOperation];
}

+ (NSDictionary *)parseModeIDData:(NSData *)readData{
    NSString *modeID = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!BulbValidStr(modeID)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"modeID":modeID,
                                            }
                              operationID:BulbReadModeIDOperation];
}

+ (NSDictionary *)parseProductionDateData:(NSData *)readData{
    NSString *productionDate = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!BulbValidStr(productionDate)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"productionDate":productionDate,
                                            }
                              operationID:BulbReadProductionDateOperation];
}

+ (NSDictionary *)parseFirmwareData:(NSData *)readData{
    NSString *firmware = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!BulbValidStr(firmware)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"firmware":firmware,
                                            }
                              operationID:BulbReadFirmwareOperation];
}

+ (NSDictionary *)parseHardwareData:(NSData *)readData{
    NSString *hardware = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!BulbValidStr(hardware)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"hardware":hardware,
                                            }
                              operationID:BulbReadHardwareOperation];
}

+ (NSDictionary *)parseSoftwareData:(NSData *)readData{
    NSString *software = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    if (!BulbValidStr(software)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"software":software,
                                            }
                              operationID:BulbReadSoftwareOperation];
}

+ (NSDictionary *)parseIEEEInfoData:(NSData *)readData{
    NSString *ieeeInfo = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(ieeeInfo)) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"IEEE":ieeeInfo,
                                            }
                              operationID:BulbReadIEEEInfoOperation];
}

+ (NSDictionary *)parseSetPassword:(NSData *)readData{
    NSString *content = [BulbParser hexStringFromData:readData];
    if (!BulbValidStr(content) || content.length != 2) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{
                                            @"result":content,
                                            }
                              operationID:BulbSetBulbPasswordOperation];
}

@end
