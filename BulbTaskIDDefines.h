
typedef NS_ENUM(NSInteger, BulbTaskOperationID) {
    BulbTaskDefaultOperation,
#pragma mark - read
    BulbReadUUIDOperation,             //Leia UUID
    BulbReadMajorOperation,            //Leia major
    BulbReadMinorOperation,            //Leia minor
    BulbReadMeasurePowerOperation,     //Leia a distância de calibração
    BulbReadTransmissionOperation,     //Ler potência de transmissão
    BulbReadBroadcastIntervalOperation,//Ler período de transmissão
    BulbReadDeviceIDOperation,         //Leia o ID do dispositivo
    BulbReadDeviceNameOperation,       //Leia o nome do dispositivo
    BulbReadMacAddressOperation,       //Leia o endereço mac
    BulbReadConnectStatusOperation,    //Ler o status conectável
    BulbReadElapsedTimeOperation,      //Leia o tempo de execução
    BulbReadHardwareModuleOperation,   //Ler tipo de chip
    BulbStartReadXYZDataOperation,     //Leia dados de aceleração de três eixos
    BulbStopReadXYZDataOperation,      //Pare de ler dados de aceleração de três eixos
    BulbReadBatteryOperation,          //Leia o nível da bateria
    BulbReadSystemIDOperation,         //Leia o logotipo do sistema
    BulbReadModeIDOperation,           //Leia o modelo do produto
    BulbReadProductionDateOperation,   //Leia a data de produção
    BulbReadFirmwareOperation,         //Leia as informações do firmware
    BulbReadHardwareOperation,         //Leia a versão do hardware
    BulbReadSoftwareOperation,         //Leia a versão do software
    BulbReadVendorOperation,           //Leia as informações do fabricante
    BulbReadIEEEInfoOperation,         //Leia os padrões IEEE
    
#pragma mark - set
    BulbHeartBeatOperation,            //Pacote Heartbeat
    BulbSetBulbUUIDOperation,        //Defina o UUID
    BulbSetBulbMajorOperation,       //Defina o major
    BulbSetBulbMinorOperation,       //Defina o minor
    BulbSetBulbMeasurePowerOperation,//Defina o MeasurePower
    BulbSetBulbTransmissionOperation,//Defina a potência de transmissão
    BulbSetBulbPasswordOperation,    //Definir senha
    BulbSetBulbBroadcastIntervalOperation,  //Defina o período de transmissão
    BulbSetBulbDeviceIDOperation,    //Definir id do dispositivo
    BulbSetBulbNameOperation,        //Definir o nome
    BulbSetBulbConnectModeOperation, //Defina o status conectável
    BulbSetBulbPowerOffOperation,    //Desligar
};
