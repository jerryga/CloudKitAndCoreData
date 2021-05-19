//
//  StoreRecord.m
//  CoolNote
//
//  Created by Asa on 16/5/25.
//  Copyright © 2016年 Static Ga. All rights reserved.
//

#import "StoreRecord.h"

@implementation StoreRecord

NSString *const SMLocalStoreEntityNameAttributeName = @"sm_LocalStore_EntityName";
NSString *const SMLocalStoreChangeTypeAttributeName=@"sm_LocalStore_ChangeType";
NSString *const SMLocalStoreRecordIDAttributeName=@"sm_LocalStore_RecordID";
NSString *const SMLocalStoreRecordEncodedValuesAttributeName = @"sm_LocalStore_EncodedValues";
NSString *const SMLocalStoreRecordChangedPropertiesAttributeName = @"sm_LocalStore_ChangedProperties";
NSString *const SMLocalStoreChangeQueuedAttributeName = @"sm_LocalStore_Queued";

NSString *const SMLocalStoreChangeSetEntityName = @"SM_LocalStore_ChangeSetEntity";
NSString *const SMCloudRecordNilValue = @"@!SM_CloudStore_Record_Nil_Value";
NSString *const SMStoreCloudStoreCustomZoneName = @"SMStoreCloudStore_CustomZone";
NSString *const SMStoreCloudStoreSubscriptionName = @"SM_CloudStore_Subscription";

NSString *const CKReferenceKey = @"parent";
NSString *const CKAssetKey = @"assetData";

@end
