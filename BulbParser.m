//
//  BulbParser.m
//  testSDK
//

#import "BulbParser.h"
#import "BulbRegularsDefine.h"
#import "BulbService.h"
#import "BulbBaseModel.h"

NSString * const CustomErrorDomain = @"com.mbs2.bulbBluetoothSDK";

@implementation BulbParser

#pragma mark - blocks
+ (NSError *)getErrorWithCode:(BulbCustomErrorCode)code message:(NSString *)message{
    NSError *error = [[NSError alloc] initWithDomain:CustomErrorDomain code:code userInfo:@{@"errorInfo":message}];
    return error;
}

+ (void)operationParametersErrorBlock:(void (^)(NSError *))block{
    bulb_main_safe(^{
        if (block) {
            block([self getErrorWithCode:BulbParamsError message:@"input parameter error"]);
        }
    });
}

+ (void)operationCentralBlePowerOffErrorBlock:(void (^)(NSError *))block{
    bulb_main_safe(^{
        if (block) {
            block([self getErrorWithCode:BulbBlueDisable message:@"mobile phone bluetooth is currently unavailable"]);
        }
    });
}

+ (void)operationPasswordErrorBlock:(void (^)(NSError *))block{
    bulb_main_safe(^{
        if (block) {
            block([self getErrorWithCode:BulbPasswordError message:@"password error"]);
        }
    });
}

+ (void)operationDisconnectErrorBlock:(void (^)(NSError *))block{
    bulb_main_safe(^{
        if (block) {
            block([self getErrorWithCode:BulbPeripheralDisconnected
                                 message:@"The current connection device is in disconnect"]);
        }
    });
}

+ (void)operationCharacterErrorBlock:(void (^)(NSError *))block{
    bulb_main_safe(^{
        if (block) {
            block([self getErrorWithCode:BulbCharacteristicError message:@"characteristic error"]);
        }
    });
}

+ (void)operationRequestDataErrorBlock:(void (^)(NSError *))block{
    bulb_main_safe(^{
        if (block) {
            block([self getErrorWithCode:BulbRequestPeripheralDataError message:@"Request bulb data error"]);
        }
    });
}

+ (void)operationConnectDeviceFailedBlock:(void (^)(NSError *))block{
    bulb_main_safe(^{
        if (block) {
            block([self getErrorWithCode:BulbConnectedFailed message:@"Connected Failed"]);
        }
    });
}

+ (void)operationConnectDeviceSuccessBlock:(void (^)(CBPeripheral *))block peripheral:(CBPeripheral *)peripheral{
    bulb_main_safe(^{
        if (block) {
            block(peripheral);
        }
    });
}

+ (void)operationDeviceTypeErrorBlock:(void (^)(NSError *))block{
    bulb_main_safe(^{
        if (block) {
            block([self getErrorWithCode:BulbParamsError message:@"The current device does not support this command"]);
        }
    });
}

#pragma mark - parser

+ (NSInteger)getDecimalWithHex:(NSString *)content range:(NSRange)range{
    if (!BulbValidStr(content)) {
        return 0;
    }
    if (range.location > content.length - 1 || range.length > content.length || (range.location + range.length > content.length)) {
        return 0;
    }
    return strtoul([[content substringWithRange:range] UTF8String],0,16);
}
+ (NSString *)getDecimalStringWithHex:(NSString *)content range:(NSRange)range{
    if (!BulbValidStr(content)) {
        return @"";
    }
    if (range.location > content.length - 1 || range.length > content.length || (range.location + range.length > content.length)) {
        return @"";
    }
    NSInteger decimalValue = strtoul([[content substringWithRange:range] UTF8String],0,16);
    return [NSString stringWithFormat:@"%ld",(long)decimalValue];
}

+ (NSData *)stringToData:(NSString *)dataString{
    if (!BulbValidStr(dataString)) {
        return nil;
    }
    if (!(dataString.length % 2 == 0)) {
        //Deve ser um número par de caracteres para ser legal
        return nil;
    }
    Byte bytes[255] = {0};
    NSInteger count = 0;
    for (int i =0; i < dataString.length; i+=2) {
        NSString *strByte = [dataString substringWithRange:NSMakeRange(i,2)];
        unsigned long red = strtoul([strByte UTF8String],0,16);
        Byte b =  (Byte) ((0xff & red) );//( Byte) 0xff&byte;
        bytes[i/2+0] = b;
        count ++;
    }
    NSData * data = [NSData dataWithBytes:bytes length:count];
    return data;
}

+ (NSString *)hexStringFromData:(NSData *)sourceData{
    if (!BulbValidData(sourceData)) {
        return nil;
    }
    Byte *bytes = (Byte *)[sourceData bytes];
    //A seguir está a conversão de Byte em hexadecimal.
    NSString *hexStr=@"";
    for(int i=0;i<[sourceData length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (BOOL)realNumbers:(NSString *)content{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(0|[1-9][0-9]*)$"];
    return [pred evaluateWithObject:content];
}

+ (BOOL)isPassword:(NSString *)content{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[a-zA-Z0-9]{8}$"];
    return [pred evaluateWithObject:content];
}

+ (BOOL)isBulbName:(NSString *)content{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[a-zA-Z0-9_]+$"];
    return [pred evaluateWithObject:content];
}

+ (BOOL)asciiString:(NSString *)content {
    NSInteger strlen = content.length;
    NSInteger datalen = [[content dataUsingEncoding:NSUTF8StringEncoding] length];
    if (strlen != datalen) {
        return NO;
    }
    return YES;
}

+ (BOOL)isUUIDString:(NSString *)uuid{
    if (!BulbValidStr(uuid)) {
        return NO;
    }
    NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:uuid
                                                       options:kNilOptions
                                                         range:NSMakeRange(0, uuid.length)];
    return (numberOfMatches > 0);
}

/**
 Determine se a string contém dados hexadecimais
 
 @return SIM: a string contém dados hexadecimais, NÃO: Não
 */
+ (BOOL)isHexString:(NSString *)content{
    if (!BulbValidStr(content) || content.length != 2) {
        return NO;
    }
    NSString *lowSourceString = [content lowercaseString];
    NSArray *hexInfoArray = @[@"a",@"b",@"c",@"d",@"e",@"f"];
    NSString *highString = [lowSourceString substringWithRange:NSMakeRange(0, 1)];
    NSString *lowString = [lowSourceString substringWithRange:NSMakeRange(1, 1)];
    BOOL highHexFlag = NO;
    if ([self realNumbers:highString] || [hexInfoArray containsObject:highString]) {
        highHexFlag = YES;
    }
    if (!highHexFlag) {
        return NO;
    }
    BOOL lowHexFlag = NO;
    if ([self realNumbers:lowString] || [hexInfoArray containsObject:lowString]) {
        lowHexFlag = YES;
    }
    if (highHexFlag && lowHexFlag) {
        return YES;
    }
    return NO;
}

+ (BOOL)isThreeAxisAccelerationData:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbElapsedTime]]) {
        return NO;
    }
    NSData *readData = characteristic.value;
    if (!BulbValidData(readData) || readData.length != 10) {
        return NO;
    }
    NSData *subData = [readData subdataWithRange:NSMakeRange(0, 2)];
    return [subData isEqualToData:[self stringToData:@"eb6c"]];
}

+ (NSDictionary *)getThreeAxisAccelerationData:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return @{};
    }
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:bulbElapsedTime]]) {
        return @{};
    }
    NSData *readData = characteristic.value;
    if (!BulbValidData(readData) || readData.length != 10) {
        return @{};
    }
    NSData *xData = [readData subdataWithRange:NSMakeRange(4, 2)];
    NSData *yData = [readData subdataWithRange:NSMakeRange(6, 2)];
    NSData *zData = [readData subdataWithRange:NSMakeRange(8, 2)];
    return @{
             @"x":[self hexStringFromData:xData],
             @"y":[self hexStringFromData:yData],
             @"z":[self hexStringFromData:zData],
             };
}

+ (BOOL)getbulbConnectable:(NSString *)content{
    if (!BulbValidStr(content)) {
        return NO;
    }
    NSString *conn = [self getBinaryByhex:content];
    if (!BulbValidStr(conn)) {
        return NO;
    }
    return [[conn substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"];
}

+ (NSString *)calcDistByRSSI:(int)rssi measurePower:(NSInteger)measurePower{
    int iRssi = abs(rssi);
    float power = (iRssi - measurePower) / (10 * 2.0);
    return [NSString stringWithFormat:@"%.2fm",pow(10, power)];
}

+ (NSString *)getHexStringWithLength:(NSInteger)len origString:(NSString *)oriString{
    if (!BulbValidStr(oriString)) {
        return @"";
    }
    if (len <= oriString.length) {
        return oriString;
    }
    NSString *string = oriString;
    for (NSInteger i = 0; i < len - oriString.length; i ++) {
        string = [@"0" stringByAppendingString:string];
    }
    return string;
}

+ (BulbBaseModel *)getbulbScanModelWithAdvDic:(NSDictionary *)advertisementData rssi:(NSInteger)rssi{
    if (!BulbValidDict(advertisementData) || rssi == 127) {
        return nil;
    }
    NSDictionary *advDic = advertisementData[CBAdvertisementDataServiceDataKey];
    //Uso geral e dados de transmissão com aceleração de três eixos não podem coexistir
    NSData *normalData = advDic[[CBUUID UUIDWithString:normalScanService]];
    NSDictionary *additionalDic = @{
                                    @"peripheralName":[self safeString:advertisementData[CBAdvertisementDataLocalNameKey]],
                                    @"txPower":[NSString stringWithFormat:@"%ld",(long)[advertisementData[CBAdvertisementDataTxPowerLevelKey] integerValue]],
                                    @"rssi":@(rssi),
                                    };
    if (BulbValidData(normalData) && normalData.length == 7) {
        //Equipamento Geral
        return [[BulbBaseModel alloc] initWithAdvertiseData:normalData additionalDic:additionalDic];
    }
    NSData *xyzData = advDic[[CBUUID UUIDWithString:xyzDataScanService]];
    if (BulbValidData(xyzData) && xyzData.length == 13) {
        //Com equipamento de três eixos
        return [[XYZBulbModel alloc] initWithAdvertiseData:xyzData additionalDic:additionalDic];
    }
    return nil;
}

#pragma mark - Private method
/**
 Converta um byte de dados hexadecimais em binários de 8 dígitos
 
 @param hex Os dados hexadecimais a serem convertidos
 @return Dados binários de 8 bits após a conversão
 */
+ (NSString *)getBinaryByhex:(NSString *)hex{
    if (!BulbValidStr(hex) || hex.length != 2 || ![self isHexString:hex]) {
        return @"";
    }
    NSDictionary *hexDic = @{
                             @"0":@"0000",@"1":@"0001",@"2":@"0010",
                             @"3":@"0011",@"4":@"0100",@"5":@"0101",
                             @"6":@"0110",@"7":@"0111",@"8":@"1000",
                             @"9":@"1001",@"A":@"1010",@"a":@"1010",
                             @"B":@"1011",@"b":@"1011",@"C":@"1100",
                             @"c":@"1100",@"D":@"1101",@"d":@"1101",
                             @"E":@"1110",@"e":@"1110",@"F":@"1111",
                             @"f":@"1111",
                             };
    NSString *binaryString = @"";
    for (int i=0; i<[hex length]; i++) {
        NSRange rage;
        rage.length = 1;
        rage.location = i;
        NSString *key = [hex substringWithRange:rage];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,
                        [NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    return binaryString;
}

+ (NSString *)safeString:(NSString *)string{
    if (!BulbValidStr(string)) {
        return @"";
    }
    return string;
}


@end
