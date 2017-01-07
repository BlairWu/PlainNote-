//
//  MasterViewController.m
//  PlainNote
//
//  Created by zjc on 17/1/1.
//  Copyright © 2017年 wxw. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "WebViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"NotesList.plist"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"NotesList" ofType:@"plist"];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    self.Notes = tmpArray;
//    NSLog(@"self.Notes:%@",self.Notes);
    [self createEditableCopyOfDatabaseIfNeeded];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
    //应用退出到后台运行的通知发出时，执行保存数据到plist文件的操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
//    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    //新增后，返回时刷新导入数据
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues
//选中cell后执行的操作,获取上一视图传递给下一视图，即实现视图控制器之间的切换
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    通过identifier来判断激活的是哪一个点击操作
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        目标视图
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
//        controller.name = @"Garvey";
//        controller.age = 110;
//        如果目标视图响应,获取当前表信息
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        NSLog(@"indexPath:%@",indexPath);
//根据行获取Notes里的对应的一条dict数据
        controller.Notedict = [self.Notes objectAtIndex:indexPath.row];
//        获取整个Notes
        controller.noteArray = self.Notes;
        
//        [controller.detailItem setValue:@"119" forKey:@"Text"];
    }
    

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.objects.count;
    //总共的行数根据Notes的条数
    return self.Notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    
//    主标题的内容
    cell.textLabel.text = [[self.Notes objectAtIndex:indexPath.row]objectForKey:@"Text"];
//    副标题的格式
//    NSDate *object = self.objects[indexPath.row];
//    cell.detailTextLabel.text = [object description];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *dateTmp;
    dateTmp = [[self.Notes objectAtIndex:indexPath.row ]objectForKey:@"CDate"];
    cell.detailTextLabel.text = [dateFormat stringFromDate: dateTmp];  
    
    return cell;
}

//使用Documents目录进行数据持久化的保存
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
//新增
- (void)createEditableCopyOfDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"NotesList.plist"];
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    if (!dbexits) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NotesList.plist"];
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);}
    }
}
//数据写入
-(void) applicationWillTerminate: (NSNotification *)notification {
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"NotesList.plist"];
    [self.Notes writeToFile:path atomically:YES];
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//Edit按钮操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        数据绑定的，必须先删除数据
        [self.Notes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
