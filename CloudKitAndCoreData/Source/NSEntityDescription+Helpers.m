//
//  NSEntityDescription+Helpers.m
//  CoolNote
//
//  Created by Asa on 16/5/25.
//  Copyright © 2016年 Static Ga. All rights reserved.
//

#import "NSEntityDescription+Helpers.h"
#import "StoreRecord.h"
#import <Foundation/Foundation.h>

@implementation NSEntityDescription (Helpers)

- (NSArray *)toOneRelationships {
    __block NSMutableArray *resultsArr = [NSMutableArray array];
    [self.relationshipsByName.allValues enumerateObjectsUsingBlock:^(NSRelationshipDescription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRelationshipDescription *relationShip = obj;
        if (NO == relationShip.isToMany) {
            [resultsArr addObject:relationShip];
        }
    }];
    return resultsArr;
}

- (NSDictionary *)toOneRelationshipsByName {
    NSMutableDictionary *relationshipsByNameDictionary = [NSMutableDictionary dictionary];
    [self.relationshipsByName enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSRelationshipDescription * _Nonnull obj, BOOL * _Nonnull stop) {
        if (NO == [obj isToMany]) {
            relationshipsByNameDictionary[key] = obj;
        }
    }];
    return relationshipsByNameDictionary;
}

@end
