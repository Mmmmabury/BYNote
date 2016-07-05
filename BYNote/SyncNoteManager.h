//
//  syncWithEvernote.h
//  BYNote
//
//  Created by cby on 16/6/26.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface SyncNoteManager : NSObject

+ (instancetype)shareManager;

- (void)updateNote:(Note *)bynote;
- (void) createNoteInAppNotebook: (Note *) note;
@end
