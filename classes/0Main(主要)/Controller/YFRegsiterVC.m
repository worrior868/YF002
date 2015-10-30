//
//  YFRegsiterVC.m
//  YF002
//
//  Created by Mushroom on 10/1/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFRegsiterVC.h"
#import "TextFieldValidator.h"
#import "SVProgressHUD.h"

#define sreenWidth [UIScreen mainScreen].bounds.size.width
#define sreenHeight [UIScreen mainScreen].bounds.size.height

#define KUserName  @"userName"
#define KUserSex   @"userSex"
#define KUserHeigh  @"userHeigh"
#define KUserWeight  @"userWeight"
#define KUserPassword  @"userPassword"





//userName  character
#define REGEX_USER_NAME @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

//heigh length and character
#define REGEX_USER_HEIGH @"[0-9]{2,3}"
#define REGEX_USER_HEIGH_LIMIT @"^.{2,3}$"

//weight length and character
#define REGEX_USER_WEIGHT @"[0-9]{2,3}"
#define REGEX_USER_WEIGHT_LIMIT @"^.{2,3}$"

//passWord length and character
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"




#define viewCornerRadius 5.0
@interface YFRegsiterVC (){
    IBOutlet TextFieldValidator *userName;
    IBOutlet TextFieldValidator *userHeigh;
    IBOutlet TextFieldValidator *userWeight;
    IBOutlet TextFieldValidator *userPassword;
    IBOutlet TextFieldValidator *userComfirmPassword;
    NSString *userSex;
    
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *sexChoose;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIButton *regsiterBtn;
- (IBAction)registerBtn:(id)sender;
@property (strong,nonatomic) NSMutableDictionary *usersList;



@end

@implementation YFRegsiterVC

- (void)viewDidLoad {
    [super viewDidLoad];

//界面上的UI设置
    //隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    _scrollView.frame = CGRectMake(0, 0, sreenWidth, 600);
    //[_scrollView setContentSize:CGSizeMake(width, 600)];
    [_scrollView setContentSize:CGSizeMake(sreenWidth, 570)];
    _scrollView.center = CGPointMake(sreenWidth/2, _scrollView.frame.size.height/2);
    
    //UI设置
    _view1.layer.cornerRadius =viewCornerRadius;
    _view2.layer.cornerRadius =viewCornerRadius;
    _view3.layer.cornerRadius =viewCornerRadius;
    _view4.layer.cornerRadius =viewCornerRadius;
    _view5.layer.cornerRadius =viewCornerRadius;
    _view6.layer.cornerRadius =viewCornerRadius;
    _regsiterBtn.layer.cornerRadius =viewCornerRadius;
    //性别选中
    _sexChoose.selectedSegmentIndex = 0;
    userSex =@"男";
    [_sexChoose addTarget: self
                    action: @selector(controlPressed:)
                forControlEvents: UIControlEventValueChanged
     ];
    
    
// 0.设置返回按钮的背景图片
    // 0.1隐藏原有的返回按钮
    [self.navigationItem setHidesBackButton:YES];
    // 0.2新建一个按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 5, 32, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"backicon"] forState:UIControlStateNormal];
    // 0.3增加selector的方法
    [btn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    // 0.4设置导航栏的leftButton
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
//验证要求
    [self setupAlerts];
    //read userDefault about users
    _usersList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"usersList"] mutableCopy];
    if (!_usersList) {
        //creat users at spefic
        NSDictionary *user1= [NSDictionary dictionaryWithObjectsAndKeys:@"123456@163.com",KUserName,@"男",KUserSex,@"170",KUserHeigh,@"65",KUserWeight,@"123456",KUserPassword, nil];
        NSDictionary *user2= [NSDictionary dictionaryWithObjectsAndKeys:@"12345@163.com",KUserName,@"男",KUserSex,@"170",KUserHeigh,@"65",KUserWeight,@"123456",KUserPassword, nil];
        NSDictionary *user3= [NSDictionary dictionaryWithObjectsAndKeys:@"无",KUserName,@"无",KUserSex,@"无",KUserHeigh,@"无",KUserWeight,@"无",KUserPassword, nil];
        _usersList = [NSMutableDictionary dictionaryWithObjectsAndKeys:user1,@"123456@163.com" ,user2,@"12345@163.com",user3,@"无",nil];
        NSLog(@"%@",_usersList);
        [[NSUserDefaults standardUserDefaults] setObject:_usersList forKey:@"usersList"];
    }
    
    
}
#pragma mark - 性别的选择
- (void) controlPressed:(id)sender {
    NSInteger selectedSegment = _sexChoose.selectedSegmentIndex;
   
    if (selectedSegment) {
        userSex =@"女";
    }else{
        userSex =@"男";
 }
     NSLog(@"Segment %@ ",userSex);
}

#pragma mark - 登陆输入验证

-(void)setupAlerts{
    
    
    [userName addRegx:REGEX_USER_NAME withMsg:@"请输入有效地电子邮箱"];
    
    [userPassword addRegx:REGEX_PASSWORD withMsg:@"请输入数字和字母组合的密码"];
    [userPassword addRegx:REGEX_PASSWORD_LIMIT withMsg:@"请输入6~10位长度的密码"];
    [userComfirmPassword addConfirmValidationTo:userPassword withMsg:@"请与上次输入的密码保持一致"];
    
    [userHeigh addRegx:REGEX_USER_HEIGH withMsg:@"请输入数字"];
    [userHeigh addRegx:REGEX_USER_HEIGH_LIMIT withMsg:@"请输入2~3位数字"];
    
    [userWeight addRegx:REGEX_USER_WEIGHT withMsg:@"请输入数字"];
    [userWeight addRegx:REGEX_USER_WEIGHT_LIMIT withMsg:@"请输入2~3位数字"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  增加返回按钮的自定义动作
-(void)goBackAction{
     [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerBtn:(id)sender {
    if([userName validate] & [userWeight validate] & [userHeigh validate]& [userComfirmPassword validate]& [userPassword validate]){
        //check weather usersList have same *userName;
        for (NSString *key in _usersList){
            //had same userName in _userList
            if ([key isEqualToString:userName.text]) {
                [SVProgressHUD showSuccessWithStatus:@"该邮箱已经被注册，请更改"];

            }else{
                //hav not same userName in _userList,add user information to userdList
                NSDictionary *user =  [NSDictionary dictionaryWithObjectsAndKeys:userName.text,KUserName,userSex,KUserSex,userHeigh.text,KUserHeigh,userWeight.text,KUserWeight,userPassword.text,KUserPassword, nil];
                [_usersList setObject:user forKey:userName.text];
                [[NSUserDefaults standardUserDefaults] setObject:_usersList forKey:@"usersList"];
               [SVProgressHUD showSuccessWithStatus:@"注册成功，请返回登陆界面"];

            }
        }
        
    }
    
}


@end
