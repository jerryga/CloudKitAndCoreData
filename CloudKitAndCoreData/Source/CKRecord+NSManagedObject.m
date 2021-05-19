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
#import <GZIP/GZIP.h>
#import <MagicalRecord/MagicalRecord.h>
#import "Folder+CoreDataClass.h"
#import "PostNote+CoreDataClass.h"

@implementation CKRecord (NSManagedObject)

- (NSArray *)allAttributeKeys:(NSDictionary *)attributesByName {
    __block NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    [self.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [self removeCD_Prefix:obj];
        
        if (attributesByName[key]) {
            [resultArr addObject:key];
        }
    }];
    
    return resultArr;
}

- (NSDictionary *)allAttributeValuesAsManagedObjectAttributeValues:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = context.persistentStoreCoordinator.managedObjectModel.entitiesByName[[self removeCD_Prefix:self.recordType]];
    NSArray *recordKeys = [self allAttributeKeys:entity.attributesByName];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [recordKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
       id recordValue =  [self valueForKey:[self addCD_Prefix:key]];
            if ([key isEqualToString:@"attributeString"]) {
                if ([recordValue isKindOfClass:[NSData class]])
                    recordValue = [NSKeyedUnarchiver unarchiveObjectWithData:recordValue];
            }
        if (recordValue) {
            [tempDic setObject:recordValue forKey:key];
        }
    }];
    return [tempDic copy];
    return  [self dictionaryWithValuesForKeys:[self allAttributeKeys:entity.attributesByName]];
}

+ (NSManagedObject<CloudKitManagedObject> *)fetchManagedObjectByRecordName:(NSString *)recordName withEntityName:(NSString *)etityName context:(NSManagedObjectContext *)context{
    NSManagedObject<CloudKitManagedObject> *managedObject = nil;;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:etityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueIdentifier == %@",recordName];
    fetchRequest.predicate = predicate;
    NSError *error ;
    NSArray *resultsArr = [context executeFetchRequest:fetchRequest error:&error];
    
    if (resultsArr.count > 0 ) {
        managedObject = [resultsArr firstObject];
    }
    return managedObject;
}

- (NSString *)removeCD_Prefix:(NSString *)originalString {
    NSString *prefixToRemove = @"CD_";
    NSString *resultString = [originalString copy];
    if ([originalString hasPrefix:prefixToRemove]) {
        resultString = [originalString substringFromIndex:[prefixToRemove length]];
    }
    return resultString;
}

- (NSString *)addCD_Prefix:(NSString *)originalString {
    NSString *prefixToAdd = @"CD_";
    NSString *resultString = nil;
    if (![originalString hasPrefix:prefixToAdd]) {
        resultString = [prefixToAdd stringByAppendingString:originalString];
    }
    return resultString;
}

- (NSManagedObject *)createOrUpdateManagedObjectFromRecord:(NSManagedObjectContext *)context {
    
   
    NSEntityDescription *entity = context.persistentStoreCoordinator.managedObjectModel.entitiesByName[[self removeCD_Prefix:self.recordType]];
    if (entity.name) {
        NSManagedObject<CloudKitManagedObject> *managedObject = [CKRecord fetchManagedObjectByRecordName:[self valueForKey:@"CD_uniqueIdentifier"] withEntityName:entity.name context:context];
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
        
        id parentUID = [self valueForKey:@"CD_folder"];
        NSManagedObject<CloudKitManagedObject> *parentObject = nil;
        if (parentUID) {
            NSEntityDescription *parentEntity = context.persistentStoreCoordinator.managedObjectModel.entitiesByName[@"Folder"];
            PostNote *note = (PostNote *)managedObject;
            NSLog(@"xxx %@",note.folder);
            NSLog(@"ffff %@",note.folder.uniqueIdentifier);
            if (note.folder) {
                parentObject = [CKRecord fetchManagedObjectByRecordName:note.folder.uniqueIdentifier withEntityName:parentEntity.name context:context];
            }else {
                parentObject = [CKRecord fetchManagedObjectByRecordName:parentUID withEntityName:parentEntity.name context:context];
            }
//            if (parentObject) {
//                [managedObject setParent:parentObject];
//            }
        }
        
        [managedObject setParent:parentObject];

        id assetObj = [self valueForKey:CKAssetKey];
        if (assetObj && [assetObj isKindOfClass:[CKAsset class]]) {
            CKAsset *asset = assetObj;
            NSData *data = [NSData dataWithContentsOfURL:asset.fileURL];
            if (data) {
                data = [data gunzippedData];
                [managedObject setAsset:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            }
        }
        
        return managedObject;
    }
    
    return nil;
}

@end
