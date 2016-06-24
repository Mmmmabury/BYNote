//
//  PasswordViewController.h
//  BYNote
//
//  Created by cby on 16/6/24.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <UIKit/UIKit.h>

/**********宏*************/
typedef enum PasswordControllerStatues{
    
    OpenPasswordLock,
    ClosePasswordLock
}PasswordControllerStatues;
typedef void(^completed)(void);

/***********************/
@interface PasswordViewController : UIViewController
+ (instancetype) pwLockWithCompletedBlock: (completed) block andStatus: (PasswordControllerStatues) status;

@end
