
/*
 Definições relacionadas às características do serviço
 */

#pragma mark - Serviço de verificação e filtragem
//Serviço de digitalização geral sem dados de aceleração de três eixos
static NSString *const normalScanService = @"FF00";
//Serviço de varredura com dados de aceleração de três eixos
static NSString *const xyzDataScanService = @"FF01";

#pragma mark - serviço de dados

#pragma mark - Serviço de dados gerais, FF00
static NSString *const normalConfigService = @"FF00";

/******************Recursos incluídos no serviço FF00****************/
static NSString *const bulbUUID = @"FF01";
static NSString *const bulbMajor = @"FF02";
static NSString *const bulbMinor = @"FF03";
static NSString *const bulbMeasurePower = @"FF04";
static NSString *const bulbTransmission = @"FF05";
static NSString *const bulbChangePassword = @"FF06";
static NSString *const bulbBroadcastInterval = @"FF07";
static NSString *const bulbDeviceID = @"FF08";
static NSString *const bulbDeviceName = @"FF09";
static NSString *const bulbMacAddress = @"FF0C";
static NSString *const bulbConnectMode = @"FF0E";
static NSString *const bulbSoftReboot = @"FF0F";
static NSString *const bulbHeartBeat = @"FF10";
static NSString *const bulbElapsedTime = @"FFE0";

#pragma mark - Serviço de bateria, 180F
static NSString *const batteryService = @"180F";

/*******************Recursos incluídos no serviço 180F*****************/
static NSString *const bulbBattery = @"2A19";

#pragma mark - Informações do sistema, 180A
static NSString *const systemService = @"180A";

/*****************Recursos incluídos no serviço 180A**************/
static NSString *const bulbVendor = @"2A29";
static NSString *const bulbModeID = @"2A24";
static NSString *const bulbProductionDate = @"2A25";
static NSString *const bulbFirmware = @"2A26";
static NSString *const bulbHardware = @"2A27";
static NSString *const bulbSoftware = @"2A28";
static NSString *const bulbSystemID = @"2A23";
static NSString *const bulbIEEEInfo = @"2A2A";

#pragma mark - dfu,00001530-1212-EFDE-1523-785FEABCD123
static NSString *const dfuService = @"00001530-1212-EFDE-1523-785FEABCD123";

/*******************Recursos incluídos no serviço dfu*****************/
static NSString *const bulbDFU = @"00001531-1212-EFDE-1523-785FEABCD123";

