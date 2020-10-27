//
//  BulbParser.h
//  testSDK
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/*
 Código de erro personalizado
 */
typedef NS_ENUM(NSInteger, BulbCustomErrorCode){
    BulbBlueDisable = -10000,                                     //O Bluetooth do celular atual não está disponível
    BulbConnectedFailed = -10001,                                 //Falha ao conectar ao periférico
    BulbPeripheralDisconnected = -10002,                          //O dispositivo externo conectado no momento está desconectado
    BulbCharacteristicError = -10003,                             //O recurso está vazio
    BulbParamsError = -10004,                                     //O parâmetro de entrada está errado
    BulbCommunicationTimeout = -10005,                            //Tempo limite da tarefa
    BulbRequestPeripheralDataError = -10006,                      //Erro ao solicitar dados
    BulbPasswordError = -10007,                                   //Senha de conexão incorreta
};

extern NSString * const CustomErrorDomain;

@class BulbBaseModel;
@interface BulbParser : NSObject

+ (NSError *)getErrorWithCode:(BulbCustomErrorCode)code message:(NSString *)message;
+ (void)operationParametersErrorBlock:(void (^)(NSError *))block;
+ (void)operationCentralBlePowerOffErrorBlock:(void (^)(NSError *))block;
+ (void)operationPasswordErrorBlock:(void (^)(NSError *))block;
+ (void)operationDisconnectErrorBlock:(void (^)(NSError *))block;
+ (void)operationCharacterErrorBlock:(void (^)(NSError *))block;
+ (void)operationRequestDataErrorBlock:(void (^)(NSError *))block;
+ (void)operationConnectDeviceFailedBlock:(void (^)(NSError *))block;
+ (void)operationConnectDeviceSuccessBlock:(void (^)(CBPeripheral *))block peripheral:(CBPeripheral *)peripheral;
+ (void)operationDeviceTypeErrorBlock:(void (^)(NSError *))block;

+ (NSInteger)getDecimalWithHex:(NSString *)content range:(NSRange)range;
+ (NSString *)getDecimalStringWithHex:(NSString *)content range:(NSRange)range;
+ (NSData *)stringToData:(NSString *)dataString;
+ (NSString *)hexStringFromData:(NSData *)sourceData;
+ (BOOL)isPassword:(NSString *)content;
+ (BOOL)realNumbers:(NSString *)content;
+ (BOOL)isUUIDString:(NSString *)uuid;
+ (BOOL)isBulbName:(NSString *)content;
+ (BOOL)asciiString:(NSString *)content;
+ (BOOL)getbulbConnectable:(NSString *)content;
+ (NSString *)calcDistByRSSI:(int)rssi measurePower:(NSInteger)measurePower;
+ (NSString *)getHexStringWithLength:(NSInteger)len origString:(NSString *)oriString;
+ (BulbBaseModel *)getbulbScanModelWithAdvDic:(NSDictionary *)advDic rssi:(NSInteger)rssi;
+ (BOOL)isThreeAxisAccelerationData:(CBCharacteristic *)characteristic;
+ (NSDictionary *)getThreeAxisAccelerationData:(CBCharacteristic *)characteristic;

@end
