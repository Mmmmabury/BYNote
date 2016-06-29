//
//  BYTextView.h
//  BYNote
//
//  Created by cby on 16/6/29.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <YYText/YYText.h>
#import "Note.h"

@interface BYTextView : YYTextView

@property (strong, nonatomic) NSMutableArray *todoButtonList;
@property (strong, nonatomic) Note* note;

- (instancetype) initWithNote: (Note *) note
                     andFrame: (CGRect) frame;

- (NSAttributedString *)addToDoButton:(NSInteger) index
                    andAttributedText: (NSAttributedString *) attext
                          andSelected: (BOOL) selected;
- (void) saveContent;
@end
