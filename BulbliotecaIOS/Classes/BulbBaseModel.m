//
//  BulbBaseModel.m
//  Bulb
//

#import "BulbBaseModel.h"
#import "BulbDataParser.h"
#import "BulbParser.h"
#import "BulbRegularsDefine.h"

@implementation BulbBaseModel

- (BulbBaseModel *)initWithAdvertiseData:(NSData *)advertiseData additionalDic:(NSDictionary *)additionalDic{
    self = [super init];
    if (self) {
        NSAssert1(!(advertiseData.length != 7), @"Invalid advertiseData:%@", advertiseData);
        self.deviceType = BulbDeviceTypeNormal;
        self.rssi = [NSString stringWithFormat:@"%ld",(long)[additionalDic[@"rssi"] integerValue]];
        NSString *temp = [BulbParser hexStringFromData:advertiseData];
        //self.macAddress = [BulbDataParser parseMacAddressData:advertiseData];
        self.battery = [BulbParser getDecimalStringWithHex:temp range:NSMakeRange(0, 2)];
        self.major = [BulbParser getDecimalStringWithHex:temp range:NSMakeRange(2, 4)];
        self.minor = [BulbParser getDecimalStringWithHex:temp range:NSMakeRange(6, 4)];
        self.measurePower = [BulbParser getDecimalStringWithHex:temp range:NSMakeRange(10, 2)];
        self.connectEnble = [BulbParser getbulbConnectable:[temp substringWithRange:NSMakeRange(12, 2)]];
        NSInteger measurePower = (BulbValidStr(self.measurePower) ? [self.measurePower integerValue] : 59);
        self.distance = [BulbParser calcDistByRSSI:[self.rssi intValue] measurePower:measurePower];
        self.proximity = @"Unknown";
        if ([self.distance doubleValue] <= 0.1) {
            self.proximity = @"Immediate";
        }else if ([self.distance doubleValue] > 0.1 && [self.distance doubleValue] <= 1.f){
            self.proximity = @"Near";
        }else if ([self.distance doubleValue] > 1.f){
            self.proximity = @"Far";
        }
        self.peripheralName = additionalDic[@"peripheralName"];
        self.txPower = additionalDic[@"txPower"];
    }
    return self;
}

@end

@implementation XYZBulbModel

- (XYZBulbModel *)initWithAdvertiseData:(NSData *)advertiseData additionalDic:(NSDictionary *)additionalDic{
    self = [super initWithAdvertiseData:[advertiseData subdataWithRange:NSMakeRange(0, 7)] additionalDic:additionalDic];
    if (self) {
        NSAssert1(!(advertiseData.length != 13), @"Invalid advertiseData:%@", advertiseData);
        self.deviceType = BulbDeviceTypeWithXYZData;
        NSString *temp = [BulbParser hexStringFromData:advertiseData];
        self.xData = [temp substringWithRange:NSMakeRange(14, 4)];
        self.yData = [temp substringWithRange:NSMakeRange(18, 4)];
        self.zData = [temp substringWithRange:NSMakeRange(22, 4)];
    }
    return self;
}

@end
