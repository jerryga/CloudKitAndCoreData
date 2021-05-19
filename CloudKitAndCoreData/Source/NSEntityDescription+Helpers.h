//
//  NSEntityDescription+Helpers.h
//  CoolNote
//
//  Created by Asa on 16/5/25.
//  Copyright © 2016年 Static Ga. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>


@interface NSEntityDescription (Helpers)
- (NSArray *)toOneRelationships;
- (NSDictionary *)toOneRelationshipsByName;

@end
