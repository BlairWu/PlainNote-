//
//  MasterViewController.h
//  PlainNote
//
//  Created by zjc on 17/1/1.
//  Copyright © 2017年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray* Notes;

- (NSString *)applicationDocumentsDirectory;
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void) applicationWillTerminate: (NSNotification *)notification;




@end

