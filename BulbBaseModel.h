//
//  BulbBaseModel.h
//  Bulb
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, BulbDeviceType) {
    BulbDeviceTypeNormal,         //Equipamento geral, sem dados de aceleração triaxial
    BulbDeviceTypeWithXYZData,    //Com dados de aceleração de três eixos
};

@interface BulbBaseModel : NSObject

/**
 Dispositivo verificado
 */
@property (nonatomic, strong)CBPeripheral *peripheral;

/**
 Tipo de dispositivo atual
 */
@property (nonatomic, assign)BulbDeviceType deviceType;

/**
 Nome do dispositivo escaneado
 */
@property (nonatomic, copy)NSString *peripheralName;

/**
 Sinal de força
 */
@property (nonatomic, copy)NSString *rssi;

/**
 A relação correspondente entre a potência de transmissão e a transmissão é: a transmissão permite que o usuário insira a faixa de valores de 0-8, que por sua vez indica a potência de transmissão: 4, 0, -4, -8, -12, -16, -20, -30, -40, a unidade é -dBm
 */
@property (nonatomic, copy)NSString *txPower;

/**
 Valor principal
 */
@property (nonatomic, copy)NSString *major;

/**
 Valor secundário
 */
@property (nonatomic, copy)NSString *minor;

/**
 Distância calculada
 */
@property (nonatomic, copy)NSString *distance;

/**
 Informações próximas e distantes，immediate (dentro de 10 cm)，near(dentro de 1m)，far (fora de 1m)，unknown(sem sinal)
 */
@property (nonatomic, copy)NSString *proximity;

/**
 Pode ser conectado, SIM pode ser conectado, NÃO não pode ser conectado
 */
@property (nonatomic, assign)BOOL connectEnble;

/**
 Energia da bateria
 */
@property (nonatomic, copy)NSString *battery;

/**
 Distância de calibração
 */
@property (nonatomic, copy)NSString *measurePower;

- (BulbBaseModel *)initWithAdvertiseData:(NSData *)advertiseData additionalDic:(NSDictionary *)additionalDic;

@end


@interface XYZBulbModel : BulbBaseModel

@property (nonatomic, copy)NSString *xData;

@property (nonatomic, copy)NSString *yData;

@property (nonatomic, copy)NSString *zData;

- (XYZBulbModel *)initWithAdvertiseData:(NSData *)advertiseData additionalDic:(NSDictionary *)additionalDic;

@end
