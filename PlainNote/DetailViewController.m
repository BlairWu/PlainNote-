//
//  DetailViewController.m
//  PlainNote
//
//  Created by zjc on 17/1/1.
//  Copyright © 2017年 wxw. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

//获取从Master传来的值
- (void)configureView {
    // Update the user interface for the detail item.
    
    if(self.Notedict != nil){
        self.detailDescriptionTextView.text = [self.Notedict objectForKey:@"Text"];
        
    }
    
//    if (self.detailItem) {
//        self.detailDescriptionTextView.text = [self.detailItem description];
//        [self.detailDescriptionTextView setText:[NSString stringWithFormat:@"接收来自Master的值：%@",_detailItem]];
//    }
//    if (self.Notedict) {
//        self.detailDescriptionTextView.text = [self.Notedict description];
//    }
}

//退出界面
-(void) viewWillDisappear:(BOOL)animated {
    //NSLog (@"Unregsitering for keyboard events");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //if we edited lets save the note in case we're exiting for a text or incoming call
    if(self.didEdit){
        [self savePlist];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    加载点击的cell里存放的值
    [self configureView];
//    [self.detailDescriptionTextView setText:[NSString stringWithFormat:@"接收来自Master的值：%@",_detailItem]];
//    self.detailDescriptionTextView.text = _name;
    
//    textview数据绑定
    self.detailDescriptionTextView.delegate =self;
    self.didEdit = NO;
    self.keyboardVisible = NO;
    self.scrollView.contentSize = self.view.frame.size;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];
}



- (void) save: (id) sender {
    if(self.keyboardVisible){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
        //        这个方法是取消第一响应者状态的。如果对textfield使用的话，那么调用这个方法，textfield的第一响应者状态就会取消，然后键盘就消失了。
        [self.detailDescriptionTextView resignFirstResponder];
        self.keyboardVisible=NO;
        return;
    }
    [self savePlist];
    [self.navigationController popViewControllerAnimated:YES];
}

//打开数据、保存数据
- (void) savePlist{
    // Create a new  dictionary for the new values
    
    NSMutableDictionary* newNote = [[NSMutableDictionary alloc] init];
    [newNote setValue:self.detailDescriptionTextView.text forKey:@"Text"];
    [newNote setObject:[NSDate date] forKey:@"CDate"];
    NSLog(@"newNote:%@",newNote);
    if(self.Notedict != nil){
        [self.noteArray removeObject:self.Notedict];
        self.Notedict = nil;
    }
    [self.noteArray addObject:newNote];
    self.didEdit = NO;
    NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:@"CDate" ascending:NO selector:@selector(compare:)];
    [self.noteArray sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];
}

//- (void) cancel: (id) sender {
//    if(!self.didEdit){
//        //如果没有编辑过，弹出当前视图控制器，返回列表视图
//        [self.navigationController popViewControllerAnimated:YES];
//    } else{
//        //如果编辑过，弹出框，判断是否退出编辑
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsaved Changes!" message:@"Close without saving?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//        [alert show];
//    }
//}


- (IBAction)cancel:(id)sender {
    if(!self.didEdit){
        //如果没有编辑过，弹出当前视图控制器，返回列表视图
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        //如果编辑过，弹出框，判断是否退出编辑
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsaved Changes!" message:@"Close without saving?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

//对弹出框上的按钮进行动作设置
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        NSLog(@"cancel");
    }else{
        //如果确定退出，弹出当前视图控制器
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"ok");
    }
}


//Text View界面编辑监听
- (void)textViewDidChange:(UITextView *)detailDescriptionTextView{
    
    //text field has started edit session show warning on cancel without save
    self.didEdit = YES;
//    NSLog(@"didEdit=YES");
    
}

-(void) keyboardDidShow: (NSNotification *)notif {
    if (self.keyboardVisible) {
        //NSLog(@"Keyboard is already visible. Ignoring notofication.");
        return;
    }
    
    //The keyboard wasn't visible before
    
    // Get the size of the keyboard.
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    //resize the scroll view
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= (keyboardSize.height);
    viewFrame.size.height -= [self.toolbar frame].size.height;
    self.scrollView.frame = viewFrame;
    
    //change the button to a done instead of save
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
    self.keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += keyboardSize.height;
    self.scrollView.frame = viewFrame;
    if (!self.keyboardVisible) {
        //NSLog(@"Keyboard is already hidden. Ignoring notification.");
        return;
    }
    self.keyboardVisible = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
