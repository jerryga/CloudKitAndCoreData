//
//  CKRecord+NSManagedObject.h
//  CoolNote
//
//  Created by Asa on 16/5/25.
//  Copyright © 2016年 Static Ga. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import <CoreData/CoreData.h>
#import "CloudKitManagedObject.h"

@interface CKRecord (NSManagedObject)
- (NSManagedObject *)createOrUpdateManagedObjectFromRecord:(NSManagedObjectContext *)context;
+ (NSManagedObject<CloudKitManagedObject> *)fetchManagedObjectByRecordName:(NSString *)recordName withEntityName:(NSString *)etityName context:(NSManagedObjectContext *)context;

@end
