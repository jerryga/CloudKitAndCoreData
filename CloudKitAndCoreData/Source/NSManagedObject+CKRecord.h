//
//  NSManagedObject+CKRecord.h
//  CoolNote
//
//  Created by Asa on 16/5/25.
//  Copyright © 2016年 Static Ga. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>
#import "CloudKitManagedObject.h"

@interface NSManagedObject (CKRecord)<CloudKitManagedObject>

- (CKRecordZoneID *)JC_recordZoneID ;
- (CKRecordZone *)JC_recordZone ;
- (CKRecord *)createOrUpdateCKRecord:(NSArray *)keys assetKey:(NSString *)assetKey withParent:(NSManagedObject *)parentObject;
@end
