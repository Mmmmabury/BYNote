//
//  syncWithEvernote.m
//  BYNote
//
//  Created by cby on 16/6/26.
//  Copyright © 2016年 cby. All rights reserved.
//

#import <ENSDK.h>
#import <EDAM.h>
#import <ENSDKAdvanced.h>
#import "SyncNoteManager.h"

@interface SyncNoteManager ()

@property (strong, nonatomic) NSArray *notebookList;
@property (strong, nonatomic) NSString *notebookGuid;
@end
@implementation SyncNoteManager


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

- (void) createNoteInAppNotebook{
    
    [self notebookListFromEvernote];
}

- (void) startCreateNote{
    
    _notebookGuid = nil;
    for (EDAMNotebook *n in _notebookList) {
        
        if ([n.name isEqualToString:@"BYNote"]) {
            
            _notebookGuid = n.guid;
        }
    }
    if (!_notebookGuid) {
        
        [self createAppNotebook];
    }else{
        
        [self createNote];
    }
}

- (void) notebookListFromEvernote{
    
    __weak typeof(self) weakSelf = self;
    [[ENSession sharedSession] listNotebooksWithCompletion:^(NSArray *notebooks, NSError *listNotebooksError) {
        
        if (listNotebooksError) {
            
            return;
        }
        weakSelf.notebookList = notebooks;
        [weakSelf startCreateNote];
    }];
}

- (void) createNote{
    
    NSString *noteBody = @"hhhhhhhhhhh"
    "<en-todo checked=\"true\"/>";
    NSString *noteContent = noteBody;
    
    NSLog(@"%@", noteContent);
    ENMLWriter * writer = [[ENMLWriter alloc] init];
    [writer startDocument];
    [writer writeRawString:noteBody];
    [writer endDocument];
    
    EDAMNote * note = [[EDAMNote alloc] init];
    note.title = @"Test Note";
    note.content = writer.contents;
    note.notebookGuid = _notebookGuid;
    ENNoteStoreClient * noteStore = [[ENSession sharedSession] primaryNoteStore];
    [noteStore createNote:note
                  success:^(EDAMNote * resultNote) {
                      // Succeeded. "resultNote" is populated with the service data for the new note.
                      NSLog(@"笔记创建成功");
                  }
                  failure:^(NSError * error) {
                      // Call failed. Error will have extra information.
                      NSLog(@"%@", error);
                  }];
}
@end
