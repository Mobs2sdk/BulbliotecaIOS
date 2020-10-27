#pragma mark - Definições de macro de verificação para strings, dicionários, matrizes, etc.
//*************************************Definições de macro de verificação para strings, dicionários, matrizes, etc.******************************************************

#define BulbValidStr(f)         (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define BulbValidDict(f)        (f!=nil && [f isKindOfClass:[NSDictionary class]] && [f count]>0)
#define BulbValidArray(f)       (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define BulbValidData(f)        (f!=nil && [f isKindOfClass:[NSData class]])

//*************************************Definições de macro de verificação para strings, dicionários, matrizes, etc.******************************************************

//===================Objeto de referência fraco=====================================//
#define BulbWS(weakSelf)          __weak __typeof(&*self)weakSelf = self;

#ifndef bulb_main_safe
#define bulb_main_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}
#endif
