//
//  CFBridge.m
//  cf
//
//  Created by DX197 on 8/11/15.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import "CFBridge.h"
#import "Cfios.h"

static dispatch_once_t onceToken = 0;
static CFBridge* sharedInstance = nil;

@implementation CFBridge

+ (CFBridge *)shared {
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CFBridge alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _commandQueue = dispatch_queue_create("cf.ios.commands", DISPATCH_QUEUE_SERIAL);
        id homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        GoCfiosInit(homePath);
    }
    return self;
}

- (void)setAPIWithEndpoint:(NSString*)endpoint skipSSL:(BOOL)skip block:(CFErrorBlock)block {
    dispatch_async(self.commandQueue, ^{
        NSError *error = nil;
        GoCfiosSetAPI(@"api.hill.cf-app.com", YES, &error);
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

- (void)loginWithUserName:(NSString*)name password:(NSString*)password block:(CFErrorBlock)block {
    dispatch_async(self.commandQueue, ^{
        NSError *error = nil;
        GoCfiosLogin(name, password, &error);
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

- (void)getOrgsWithBlock:(CFResultBlock)block {
    dispatch_async(self.commandQueue, ^{
        NSData *data = nil;
        NSError *error = nil;

        GoCfiosOrgs(&data, &error);

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil, error);
            });
            return;
        }

        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                      error:&error];


        dispatch_async(dispatch_get_main_queue(), ^{
            block(result, error);
        });
    });
}

- (void)targetOrg:(NSString*)org block:(CFErrorBlock)block {
    dispatch_async(self.commandQueue, ^{
        NSError *error = nil;
        GoCfiosTargetOrg(org, &error);
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

- (void)getSpacesWithBlock:(CFResultBlock)block {
    dispatch_async(self.commandQueue, ^{
        NSData *data = nil;
        NSError *error = nil;

        GoCfiosSpaces(&data, &error);

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil, error);
            });
            return;
        }

        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                      error:&error];


        dispatch_async(dispatch_get_main_queue(), ^{
            block(result, error);
        });
    });
}

- (void)targetSpace:(NSString*)space block:(CFErrorBlock)block {
    dispatch_async(self.commandQueue, ^{
        NSError *error = nil;
        GoCfiosTargetSpace(space, &error);
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

- (void)getAppsWithBlock:(CFResultBlock)block {
    dispatch_async(self.commandQueue, ^{
        NSData *data = nil;
        NSError *error = nil;
        GoCfiosApps(&data, &error);

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil, error);
            });
            return;
        }

        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                      error:&error];


        dispatch_async(dispatch_get_main_queue(), ^{
            block(result, error);
        });
    });

}

@end
