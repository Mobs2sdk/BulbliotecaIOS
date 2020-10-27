//
//  BulbDataParser.h
//  testSDK
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *const BulbCommunicationDataNum;

@interface BulbDataParser : NSObject

+ (NSDictionary *)parseReadDataFromCharacteristic:(CBCharacteristic *)characteristic;

+ (NSDictionary *)parseWriteDataFromCharacteristic:(CBCharacteristic *)characteristic;

@end
