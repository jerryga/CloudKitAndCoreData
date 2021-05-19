//
//  CKRecord+NSManagedObject.m
//  CoolNote
//
//  Created by Asa on 16/5/25.
//  Copyright © 2016年 Static Ga. All rights reserved.
//

#import "CKRecord+NSManagedObject.h"
#import <CoreData/CoreData.h>
#import <Foundation/NSKeyValueCoding.h>
#import "StoreRecord.h"

@implementation CKRecord (NSManagedObject)

- (NSArray *)allAttributeKeys:(NSDictionary *)attributesByName {
    __block NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    [self.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj;
        if (attributesByName[key]) {
            [resultArr addObject:key];
        }
    }];
    
    return resultArr;
}

- (NSDictionary *)allAttributeValuesAsManagedObjectAttributeValues:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = context.persistentStoreCoordinator.managedObjectModel.entitiesByName[self.recordType];
   return  [self dictionaryWithValuesForKeys:[self allAttributeKeys:entity.attributesByName]];
}

+ (NSManagedObject<CloudKitManagedObject> *)fetchManagedObjectByRecordName:(NSString *)recordName withEntityName:(NSString *)etityName context:(NSManagedObjectContext *)context{
    NSManagedObject<CloudKitManagedObject> *managedObject = nil;;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:etityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",@"recordName",recordName];
    fetchRequest.predicate = predicate;
    NSError *error ;
    NSArray *resultsArr = [context executeFetchRequest:fetchRequest error:&error];
    
    if (resultsArr.count > 0 ) {
        managedObject = [resultsArr firstObject];
    }
    return managedObject;
}

- (NSManagedObject *)createOrUpdateManagedObjectFromRecord:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = context.persistentStoreCoordinator.managedObjectModel.entitiesByName[self.recordType];
    if (entity.name) {
        NSManagedObject<CloudKitManagedObject> *managedObject = [CKRecord fetchManagedObjectByRecordName:self.recordID.recordName withEntityName:entity.name context:context];
        if (managedObject) {
            NSDictionary *attributeValuesDictionary = [self allAttributeValuesAsManagedObjectAttributeValues:context];
            if (attributeValuesDictionary) {
                [managedObject setValuesForKeysWithDictionary:attributeValuesDictionary];
            }
            
        }else {
            managedObject = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:context];
            [managedObject autoSetRecordID];
            NSDictionary *attributeValuesDictionary = [self allAttributeValuesAsManagedObjectAttributeValues:context];
                if (attributeValuesDictionary) {
                    [managedObject setValuesForKeysWithDictionary:attributeValuesDictionary];
            }
        }
        
        id parent = [self valueForKey:CKReferenceKey];
        if (parent && [parent isKindOfClass:[CKReference class]]) {
            CKReference *reference = parent;
            CKRecordID *parentRecordID = reference.recordID;
            NSString *parentEntityName = [parentRecordID.recordName substringToIndex:[parentRecordID.recordName rangeOfString:@"."].location];
            
            NSManagedObject<CloudKitManagedObject> *parentObject = [CKRecord fetchManagedObjectByRecordName:parentRecordID.recordName withEntityName:parentEntityName context:context];
            NSLog(@"xxxxx %@",parentRecordID.recordName);
            if (parentObject) {
                    //Exist
                [managedObject setParent:parentObject];
            }
        }
        
        id assetObj = [self valueForKey:CKAssetKey];
        if (assetObj && [assetObj isKindOfClass:[CKAsset class]]) {
            CKAsset *asset = assetObj;
            NSData *data = [NSData dataWithContentsOfURL:asset.fileURL];
            if (data) {
                [managedObject setAsset:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            }
        }
        
        return managedObject;
    }
    
    return nil;
}

@end
