//
//  DBManager.h
//  modularizationDemo
//
//  Created by 李林 on 1/6/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface DBManager : NSObject

+ (DBManager *)sharedManager;

- (NSArray *)getAllPersons;
- (void)addPerson:(Person *)p;
- (void)deletaPerson:(Person *)p;

@end
