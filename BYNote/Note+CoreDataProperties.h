//
//  Note+CoreDataProperties.h
//  BYNote
//
//  Created by cby on 16/7/4.
//  Copyright © 2016年 cby. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *changed;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *create_date;
@property (nullable, nonatomic, retain) id status;
@property (nullable, nonatomic, retain) NSDate *update_date;
@property (nullable, nonatomic, retain) NSString *guid;

@end

NS_ASSUME_NONNULL_END
