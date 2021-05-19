//
//  StoreRecord.h
//  CoolNote
//
//  Created by Asa on 16/5/25.
//  Copyright © 2016年 Static Ga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreRecord : NSObject

extern NSString *const SMLocalStoreEntityNameAttributeName ;
extern NSString *const SMLocalStoreChangeTypeAttributeName ;
extern NSString *const SMLocalStoreRecordIDAttributeName ;
extern NSString *const SMLocalStoreRecordEncodedValuesAttributeName ;
extern NSString *const SMLocalStoreRecordChangedPropertiesAttributeName ;
extern NSString *const SMLocalStoreChangeQueuedAttributeName ;

extern NSString *const SMLocalStoreChangeSetEntityName ;
extern NSString *const SMCloudRecordNilValue;

extern NSString *const SMStoreCloudStoreCustomZoneName ;
extern NSString *const SMStoreCloudStoreSubscriptionName ;

extern NSString *const CKReferenceKey ;
extern NSString *const CKAssetKey;

@end
