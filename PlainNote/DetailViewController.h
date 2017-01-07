//
//  DetailViewController.h
//  PlainNote
//
//  Created by zjc on 17/1/1.
//  Copyright © 2017年 wxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UIAlertViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) id detailItem;
//
@property (weak, nonatomic) IBOutlet UITextView *detailDescriptionTextView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property BOOL didEdit; //编辑与否
@property BOOL keyboardVisible; //键盘是否弹出
@property NSDictionary *Notedict; //存放一条数据记录
@property NSMutableArray *noteArray; //存放NoteDict

- (IBAction)cancel:(id)sender;

//键盘的控制：显示与隐藏
-(void)keyboardDidShow:(NSNotification *)notif;
-(void)keyboardDidHide:(NSNotification *)notif;
//文本的修改监控
-(void)textViewDidChange:(UITextView *)detailDescriptionTextView;
-(void)savePlist;

//@property (strong, nonatomic) NSString *name;
//@property (assign, nonatomic) int age;
@end

