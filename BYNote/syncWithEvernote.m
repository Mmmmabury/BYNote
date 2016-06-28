//
//  syncWithEvernote.m
//  BYNote
//
//  Created by cby on 16/6/26.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "syncWithEvernote.h"

@implementation syncWithEvernote
- (IBAction)hh:(UIButton *)sender {
    
    NSString *noteBody = @"An item that I haven't completed yet."
    "<en-todo checked=\"true\"/>";
    //    NSString *noteBody = @"";
    NSString *noteContent = [NSString stringWithFormat:@
                             //                             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                             //                             "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
                             //                             "<en-note/>"
                             "%@"
                             //                             "</en-note>"
                             ,noteBody];
    
    NSLog(@"%@", noteContent);
    ENMLWriter * writer = [[ENMLWriter alloc] init];
    [writer startDocument];
    [writer writeRawString:noteBody];
    //    [writer writeTodoWithCheckedState:NO];
    [writer endDocument];
    
    EDAMNote * note = [[EDAMNote alloc] init];
    note.title = @"Test Note";
    note.content = writer.contents;
    
    // 创建笔记
    //    ENNoteStoreClient * noteStore = [[ENSession sharedSession] primaryNoteStore];
    //    [noteStore createNote:note
    //                  success:^(EDAMNote * resultNote) {
    //                      // Succeeded. "resultNote" is populated with the service data for the new note.
    //                      NSLog(@"success");
    //                  }
    //                  failure:^(NSError * error) {
    //                      // Call failed. Error will have extra information.
    //                      NSLog(@"%@", error);
    //                  }];
    
    
    __weak typeof(self) weakSelf = self;
    [[ENSession sharedSession] listNotebooksWithCompletion:^(NSArray *notebooks, NSError *listNotebooksError) {
        
        NSLog(@"%@", notebooks);
        weakSelf.notebooks = notebooks;
        [weakSelf hh];
    }];
    
    // 查询
    //    ENNoteSearch *search = [[ENNoteSearch alloc] initWithSearchString:@"first"];
    //
    //    [[ENSession sharedSession] findNotesWithSearch:search inNotebook:nil orScope:ENSessionSearchScopeAll sortOrder:ENSessionSortOrderRecentlyCreated maxResults:0 completion:^(NSArray *findNotesResults, NSError *findNotesError) {
    //
    //        NSLog(@"%@", findNotesResults);
    //        weakSelf.notebooks = findNotesResults;
    //        [weakSelf hh];
    //    }];
    
    
    // 创建笔记本
    //    [[ENSession sharedSession].primaryNoteStore createNotebook:notebookToCreate success:^(EDAMNotebook *notebook) {
    //        NSLog(@"Successfully created personal notebook %@", notebook);
    //        [weakSelf reloadNotebooks];
    //    } failure:^(NSError *error) {
    //        NSLog(@"Failed to create the notebook with error %@", error);
    //    }];
    
}

- (IBAction)button3:(UIButton *)sender {
    
    NSString *noteBody = @"An item that I haven't completed yet."
    "<en-todo checked=\"true\"/>";
    //    NSString *noteBody = @"";
    NSString *noteContent = [NSString stringWithFormat:@
                             //                             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                             //                             "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
                             //                             "<en-note/>"
                             "%@"
                             //                             "</en-note>"
                             ,noteBody];
    
    NSLog(@"%@", noteContent);
    ENMLWriter * writer = [[ENMLWriter alloc] init];
    [writer startDocument];
    [writer writeRawString:noteBody];
    //    [writer writeTodoWithCheckedState:NO];
    [writer endDocument];
    
    EDAMNote * note = [[EDAMNote alloc] init];
    note.title = @"Test Note";
    note.content = writer.contents;
    note.notebookGuid = _notebookGuid;
    ENNoteStoreClient * noteStore = [[ENSession sharedSession] primaryNoteStore];
    [noteStore createNote:note
                  success:^(EDAMNote * resultNote) {
                      // Succeeded. "resultNote" is populated with the service data for the new note.
                      NSLog(@"success");
                  }
                  failure:^(NSError * error) {
                      // Call failed. Error will have extra information.
                      NSLog(@"%@", error);
                  }];
}

- (void) hh{
    
    for (ENNotebook *n in _notebooks) {
        
        NSLog(@"%@", n.name);
        NSLog(@"guid:%@", n.guid);
        if ([n.name isEqualToString:@"11"]) {
            
            _notebookGuid = n.guid;
        }
    }
    
}
@end
