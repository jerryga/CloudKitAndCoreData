//
//  CloudKitManagedObject.h
//  CoolNote
//
//  Created by Asa on 16/5/26.
//  Copyright © 2016年 Static Ga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import <CoreData/CoreData.h>

@protocol CloudKitManagedObject <NSObject>

@optional
@property (nonatomic, strong) NSData *recordIDData;//CKRecordID -> NSData
@property (nonatomic, strong) NSString *recordName;
- (void)setParent:(NSManagedObject *)parentObject;
- (void)autoSetRecordID;
- (CKRecordID *)ckRecordID;
- (void)setAsset:(id)assetObj;

@end
