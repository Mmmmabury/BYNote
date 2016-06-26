//
//  Note+CoreDataProperties.h
//  BYNote
//
//  Created by cby on 16/6/26.
//  Copyright © 2016年 cby. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *create_data;
@property (nullable, nonatomic, retain) NSDate *update_data;
@property (nullable, nonatomic, retain) NSNumber *changed;

@end

NS_ASSUME_NONNULL_END
