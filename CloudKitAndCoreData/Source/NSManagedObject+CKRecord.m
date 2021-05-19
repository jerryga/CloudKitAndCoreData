//
//  NSManagedObject+CKRecord.m
//  CoolNote
//
//  Created by Asa on 16/5/25.
//  Copyright © 2016年 Static Ga. All rights reserved.
//

#import "NSManagedObject+CKRecord.h"
#import "NSEntityDescription+Helpers.h"
#import <Foundation/Foundation.h>
#import "StoreRecord.h"
#import "CKRecord+NSManagedObject.h"
#import "NSDate+Utilities.h"
#import <GZIP/GZIP.h>

@implementation NSManagedObject (CKRecord)

- (void)setAttributesValues:(CKRecord *)ckRecord withValuesOfAttributeWithKeys:(NSArray *)keys {
    NSArray *attributes = nil;
    if (keys) {
        attributes = keys;
    }else {
        attributes = [NSArray arrayWithArray:self.entity.attributesByName.allKeys];
    }
    NSDictionary *valuesDictionary = [self dictionaryWithValuesForKeys:attributes];
   [valuesDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
      
       NSAttributeDescription *attributeDescription = [self.entity attributesByName][key];
       if (attributeDescription && [self valueForKey:attributeDescription.name]) {
           switch(attributeDescription.attributeType) {
               case NSStringAttributeType:
               {
                   [ckRecord setObject:(NSString *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];
               }
                   break;
               case NSDateAttributeType:
               {
                   [ckRecord setObject:(NSDate *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
               case NSBinaryDataAttributeType:
               {
                   [ckRecord setObject:(NSData *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
               case NSBooleanAttributeType:
               {
                   [ckRecord setObject:(NSNumber *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
               case NSDecimalAttributeType:
               {
                   [ckRecord setObject:(NSNumber *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
               case NSDoubleAttributeType:
               {
                   [ckRecord setObject:(NSDate *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
               case NSFloatAttributeType:
               {
                   [ckRecord setObject:(NSNumber *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
               case NSInteger16AttributeType:
               {
                   [ckRecord setObject:(NSNumber *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
               case NSInteger32AttributeType:
               {
                   [ckRecord setObject:(NSNumber *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
               case NSInteger64AttributeType:
               {
                   [ckRecord setObject:(NSNumber *)[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
               case NSTransformableAttributeType:
               {
                  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self valueForKey:attributeDescription.name]];
                   [ckRecord setObject:(NSData *)data forKey:attributeDescription.name];
                   
               }
                   break;
               default:
               {
                   [ckRecord setObject:[self valueForKey:attributeDescription.name] forKey:attributeDescription.name];

               }
                   break;
           }
       }else if (attributeDescription && ![self valueForKey:attributeDescription.name]) {
           [ckRecord setObject:nil forKey:attributeDescription.name];
       }
       
   }];
}

- (NSString *)tempAssetFilePath {
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.out",timeLocal]];
}

- (CKRecord *)createOrUpdateCKRecord:(NSArray *)keys assetKey:(NSString *)assetKey withParent:(NSManagedObject *)parentObject{
    
    CKRecord *ckRecord;
    CKRecordID *ckRecordID = [self ckRecordID];
    ckRecord = [[CKRecord alloc] initWithRecordType:[self recordType] recordID:ckRecordID];
    
    if (keys) {
        
        if (assetKey && [keys containsObject:assetKey]) {
            NSMutableArray *tempKeys = [NSMutableArray arrayWithArray:keys];
            [tempKeys removeObject:assetKey];
            keys = [tempKeys copy];
            
            NSAttributeDescription *attributeDescription = [self.entity attributesByName][assetKey];
            id assetValue = [self valueForKey:attributeDescription.name];
            if (assetValue) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:assetValue];
                data = [data gzippedData];
                NSString *temp = [self tempAssetFilePath];
               [data writeToFile:temp atomically:NO];
                
                CKAsset *asset = [[CKAsset alloc] initWithFileURL:[NSURL fileURLWithPath:temp]];
                ckRecord[CKAssetKey] = asset;
            }
        }
        
        __block NSMutableArray *attributeKeys = [NSMutableArray array];
        [self.entity.attributesByName enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSAttributeDescription * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([keys containsObject:key]) {
                [attributeKeys addObject:key];
            }
        }];
        
        [self setAttributesValues:ckRecord withValuesOfAttributeWithKeys:attributeKeys];
        
        if (parentObject) {
            NSLog(@"xxxxx %@",parentObject.recordName);
            CKRecordID *parentRecordID = [[CKRecordID alloc] initWithRecordName:[parentObject recordName] zoneID:[self JC_recordZoneID]];
            CKRecord *parentRecord = [[CKRecord alloc] initWithRecordType:[parentObject recordType] recordID:parentRecordID];
            CKReference *reference = [[CKReference alloc] initWithRecord:parentRecord action:CKReferenceActionDeleteSelf];
            ckRecord[CKReferenceKey] = reference;
        }
        
        return ckRecord;
    }
    
    [self setAttributesValues:ckRecord withValuesOfAttributeWithKeys:nil];
    
    return ckRecord;
}

#pragma mark - helper

- (CKRecordID *)ckRecordID {
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:[self cloudKitRecordID]];
    
    if (obj && [obj isKindOfClass:[CKRecordID class]]) {
        CKRecordID *recordID = obj;
        return recordID;
    }
    return nil;
}

- (void)autoSetRecordID {
    NSString *uuid = [NSUUID UUID].UUIDString;
    self.recordName = [NSString stringWithFormat:@"%@.%@",NSStringFromClass([self class]),uuid];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:self.recordName zoneID:[self JC_recordZoneID]];
    self.recordIDData = [NSKeyedArchiver archivedDataWithRootObject:recordID];
}

- (NSData *)cloudKitRecordID {
    if (!self.recordIDData) {
        [self autoSetRecordID];
    }
    return self.recordIDData;
}

- (NSString *)recordType {
    return NSStringFromClass([self class]);
}

- (NSString *)zoneName {
    return  [NSString stringWithFormat:@"%@_zone",[self recordType]];
}

- (CKRecordZoneID *)JC_recordZoneID {
    return [[CKRecordZoneID alloc] initWithZoneName:[self zoneName] ownerName:CKCurrentUserDefaultName];
}

- (CKRecordZone *)JC_recordZone {
    return [[CKRecordZone alloc] initWithZoneID:[self JC_recordZoneID]];
}

@end
