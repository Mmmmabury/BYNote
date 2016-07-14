//
//  syncWithEvernote.h
//  BYNote
//
//  Created by cby on 16/6/26.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

typedef void(^syncBlock)(void);
typedef void(^syncErrorBlock)(NSInteger errorCode);
/*
code 100 未登录
*/

@interface SyncNoteManager : NSObject

+ (instancetype)shareManager;

- (void)updateNote:(Note *)bynote
withCompletedHandle:(syncBlock)completedHandle
    andErrorHandle:(syncErrorBlock)errorHandle;

- (void) createNoteInAppNotebook: (Note *) note
             withCompletedHandle:(syncBlock)completedHandle
                  andErrorHandle:(syncErrorBlock)errorHandle;
@end
