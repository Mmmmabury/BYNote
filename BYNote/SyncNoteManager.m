//  syncWithEvernote.m
//
//  BYNote
//
//  Created by cby on 16/6/26.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <ENSDK.h>
#import <EDAM.h>
#import <ENSDKAdvanced.h>
#import "SyncNoteManager.h"
#import "CoreDataManager.h"

@interface SyncNoteManager ()
{
    Note *_note;
    EDAMNotebook *_notebook;
}
@property (strong, nonatomic) NSArray *notebookList;
@property (strong, nonatomic) NSString *notebookGuid;
@end
@implementation SyncNoteManager

static SyncNoteManager *instance;
+ (instancetype) shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!instance) {
            
            instance = [super allocWithZone:nil];
            [instance notebookListFromEvernote];
        }
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    return [SyncNoteManager shareManager];
}

- (id)copy{
    
    return self;
}

# pragma mark 创建并获取笔记本的 guid
- (void) notebookListFromEvernote{
    
    if(![[ENSession sharedSession] isAuthenticated]){
        
        NSLog(@"没有登录，请登录");
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[ENSession sharedSession] listNotebooksWithCompletion:^(NSArray *notebooks, NSError *listNotebooksError) {
        
        if (listNotebooksError) {
            
            NSLog(@"获取笔记本失败");
            return;
        }
        weakSelf.notebookList = notebooks;
        [weakSelf getNotebookGuid];
    }];
}

- (void)getNotebookGuid{
    
    _notebookGuid = nil;
    for (EDAMNotebook *n in _notebookList) {
        
        if ([n.name isEqualToString:@"BYNote"]) {
            
            _notebookGuid = n.guid;
            _notebook = n;
        }
    }
    if (!_notebookGuid) {
        
        [self createAppNotebook];
    }
    _notebookList = nil;
}

- (void) createAppNotebook{
    
    EDAMNotebook *notebook = [[EDAMNotebook alloc] init];
    notebook.name = @"BYNote";
    __weak typeof(self) weakSelf = self;
    [[ENSession sharedSession].primaryNoteStore createNotebook:notebook success:^(EDAMNotebook *notebook) {
        
        _notebookGuid = notebook.guid;
        [weakSelf createNote];
        NSLog(@"成功创建笔记本%@", notebook);
    } failure:^(NSError *error) {
        
        NSLog(@"创建应用笔记本失败%@", error);
    }];
}

# pragma mark 创建更新笔记
- (void) createNoteInAppNotebook: (Note *) note{
    
    if(![[ENSession sharedSession] isAuthenticated]){
        
        NSLog(@"没有登录，请登录");
        return;
    }
    if (!_notebookGuid) {
        
        [self notebookListFromEvernote];
    }
    _note = note;
    [self createNote];
}

- (void) createNote{
    
    NSString *noteBody = [self parseContent];
    
    if (!noteBody) {
        
        NSLog(@"无内容，笔记创建失败");
        return;
    }
    NSDate *createDate = _note.create_date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    ENMLWriter * writer = [[ENMLWriter alloc] init];
    [writer startDocument];
    [writer writeRawString:noteBody];
    [writer endDocument];
    
    EDAMNote * note = [[EDAMNote alloc] init];
    note.title = [formatter stringFromDate:createDate];
    note.content = writer.contents;
    note.notebookGuid = _notebookGuid;
    ENNoteStoreClient * noteStore = [[ENSession sharedSession] primaryNoteStore];
    [noteStore createNote:note
                  success:^(EDAMNote * resultNote) {
                      // Succeeded. "resultNote" is populated with the service data for the new note.
                      _note.guid = resultNote.guid;
                      _note.changed = @NO;
                      [[CoreDataManager shareCoreDataManager] saveContext];
                      NSLog(@"笔记创建成功");
                  }
                  failure:^(NSError * error) {
                      // Call failed. Error will have extra information.
                      NSLog(@"创建笔记失败%@", error);
                  }];
}

- (void)getEDAMNote: (Note *)bynote{
    

}

- (void)updateNote:(Note *)bynote{
    
    if(![[ENSession sharedSession] isAuthenticated]){
        
        NSLog(@"没有登录，请登录");
        return;
    }
    _note = bynote;
    ENNoteStoreClient * noteStore = [[ENSession sharedSession] primaryNoteStore];
    [noteStore getNoteWithGuid:_note.guid withContent:YES withResourcesData:NO withResourcesRecognition:NO withResourcesAlternateData:NO success:^(EDAMNote *note) {
        
        NSString *content = [self parseContent];
        ENMLWriter * writer = [[ENMLWriter alloc] init];
        [writer startDocument];
        [writer writeRawString:content];
        [writer endDocument];
        note.content = writer.contents;
        ENNoteStoreClient * noteStore = [[ENSession sharedSession] primaryNoteStore];
        [noteStore updateNote:note success:^(EDAMNote *note) {
            
            NSLog(@"更新笔记成功");
            _note.changed = @NO;
            [[CoreDataManager shareCoreDataManager] saveContext];
        } failure:^(NSError *error) {
            
            NSLog(@"更新笔记出错%@", error);
        }];
    } failure:^(NSError *error) {
       
        NSLog(@"获取笔记出错%@", error);
    }];

}

// 将传入的内容转换为 ENML
- (NSString *) parseContent{
    
    NSString *content = _note.content;
    NSArray *status = _note.status;
    NSMutableArray *mutableStatus = [[NSMutableArray alloc] init];
    for (int i = 0; i < status.count; i++) {
        
        NSNumber *n = status[i];
        if ([n boolValue]) {
            
            NSString *s = [NSString stringWithFormat:@"<en-todo checked=\"%@\"/>", @"true"];
            [mutableStatus addObject:s];
        }else{
            
            NSString *s = [NSString stringWithFormat:@"<en-todo checked=\"%@\"/>", @"false"];
            [mutableStatus addObject:s];
        }
    }
    NSMutableString *parsedContent = [content mutableCopy];
    for (int i = 0; i < mutableStatus.count; i ++) {
        
        NSRange range = [parsedContent rangeOfString:@"\U0000fffc"];
        [parsedContent replaceCharactersInRange:range withString:mutableStatus[i]];
    }
    NSRange spaceRange = NSMakeRange(0, 0);
    while (!NSEqualRanges(spaceRange, NSMakeRange(NSNotFound, 0))) {
        
        spaceRange = [parsedContent rangeOfString:@"\n"];
        if (spaceRange.location != NSNotFound) {
            
            [parsedContent replaceCharactersInRange:spaceRange withString:@"<p></p>"];
        }
    }
    NSLog(@"笔记内容为：%@", parsedContent);
    return parsedContent;
}


@end
