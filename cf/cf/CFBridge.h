//
//  CFBridge.h
//  cf
//
//  Created by DX197 on 8/11/15.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>


typedef void (^CFResultBlock)(id, NSError*);
typedef void (^CFErrorBlock)(NSError*);

@interface CFBridge : NSObject

@property (nonatomic, readonly) dispatch_queue_t commandQueue;

- (void)setAPIWithEndpoint:(NSString*)endpoint skipSSL:(BOOL)skip block:(CFErrorBlock)block;
- (void)loginWithUserName:(NSString*)name password:(NSString*)password block:(CFErrorBlock)block;

- (void)getOrgsWithBlock:(CFResultBlock)block;
- (void)targetOrg:(NSString*)org block:(CFErrorBlock)block;

- (void)getSpacesWithBlock:(CFResultBlock)block;
- (void)targetSpace:(NSString*)space block:(CFErrorBlock)block;;

- (void)getAppsWithBlock:(CFResultBlock)block;

+ (CFBridge *)shared;

@end
