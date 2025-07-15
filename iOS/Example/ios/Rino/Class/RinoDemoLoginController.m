//
//  RinoLoginViewController.m
//  Rino
//
//  Created by super on 2023/12/12.
//

#import "RinoDemoLoginController.h"
#import <RinoBaseKit/RinoBaseKit.h>
#import "RinoDemoRegisterController.h"
#import "RinoDemoCountryListController.h"
#import <Masonry/Masonry.h>
@interface RinoDemoLoginController ()

@property (nonatomic , strong) UIButton *countryBtn;

@property (nonatomic , strong) UITextField *accountTextField;

@property (nonatomic , strong) UITextField *pwdTextField;

@property (nonatomic , strong) UIButton *loginBtn;

@property (nonatomic , strong) UIButton *registerBtn;

@property (nonatomic , copy) NSString *countryCode;

@property (nonatomic , copy) NSString *account;

@property (nonatomic , copy) NSString *pwd;

@end

@implementation RinoDemoLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.countryCode = @"86";
    [self setChildView];
    
}

-(void)setChildView{
    [self.view addSubview:self.countryBtn];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.pwdTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
}

-(void)countryButtonClicked{
    RinoDemoCountryListController *countryVC = [[RinoDemoCountryListController alloc]init];
    [countryVC setClickBlock:^(RinoCountryModel * _Nonnull countryModel) {
        self.countryCode = countryModel.countryCode;
        NSString *countryStr = [NSString stringWithFormat:@"国家：%@ + %@",countryModel.countryName,self.countryCode];
        [self.countryBtn setTitle:countryStr forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:countryVC animated:YES];
    
}
#pragma mark - 登录
- (void)loginButton{
    self.account = [NSString stringWithFormat:@"%@",self.accountTextField.text];
    self.pwd = [NSString stringWithFormat:@"%@",self.pwdTextField.text];
    if(self.account.length == 0 || self.pwd.length == 0){
        [RinoToast  showMessage:@"请输入账号密码"];
        return;
    }
    [self.view endEditing:YES];
    if ([self.account checkPhone]) {
        [self loginByPhone];
    } else {
        [self loginByEmail];
    }
    
}

-(void)registerButtonClicked{
    
    RinoDemoRegisterController *registerVC = [[RinoDemoRegisterController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginByEmail {
    [[RinoUser sharedInstance] loginByPhone:self.countryCode
                                      phone:self.account
                                   password:self.pwd
                                    success:^{
        id appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate && [appDelegate respondsToSelector:@selector(initRootView)]) {
            [appDelegate initRootView];
        }
    } failure:^(NSError *error) {
        [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
    }];
}
/// 手机号登录
- (void)loginByPhone {
    [[RinoUser sharedInstance] loginByEmail:self.countryCode
                                      email:self.account
                                   password:self.pwd
                                    success:^{
        id appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate && [appDelegate respondsToSelector:@selector(initRootView)]) {
            [appDelegate initRootView];
        }
    } failure:^(NSError *error) {
        [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
        
    }];
}



-(UIButton *)countryBtn{
    if(_countryBtn == nil){
        _countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countryBtn.layer.masksToBounds = YES;
        _countryBtn.layer.cornerRadius = 10;
        _countryBtn.backgroundColor = [UIColor blackColor];
        _countryBtn.frame = CGRectMake(40, 150, self.view.frame.size.width - 80, 50);
        NSString *countryStr = [NSString stringWithFormat:@"国家：中国 + %@",self.countryCode];
        [_countryBtn setTitle:countryStr forState:UIControlStateNormal];
        [_countryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countryBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_countryBtn addTarget:self action:@selector(countryButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _countryBtn;
}

-(UITextField *)accountTextField{
    if(_accountTextField == nil){
        _accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.countryBtn.frame) + 18, self.view.frame.size.width - 80, 50)];
        _accountTextField.layer.masksToBounds = YES;
        _accountTextField.layer.cornerRadius = 10;
        _accountTextField.layer.borderColor = [UIColor blackColor].CGColor;
        _accountTextField.layer.borderWidth = 1;
        _accountTextField.placeholder = @"请输入账号";
        _accountTextField.textColor = [UIColor blackColor];
        _accountTextField.font = [UIFont systemFontOfSize:16];
    }
    return _accountTextField;
}

-(UITextField *)pwdTextField{
    if(_pwdTextField == nil){
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.accountTextField.frame) + 18, self.view.frame.size.width - 80, 50)];
        _pwdTextField.layer.masksToBounds = YES;
        _pwdTextField.layer.cornerRadius = 10;
        _pwdTextField.layer.borderColor = [UIColor blackColor].CGColor;
        _pwdTextField.layer.borderWidth = 1;
        _pwdTextField.placeholder = @"请输入密码";
        _pwdTextField.textColor = [UIColor blackColor];
        _pwdTextField.font = [UIFont systemFontOfSize:16];
    }
    return _pwdTextField;
}

-(UIButton *)loginBtn{
    if(_loginBtn == nil){
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 10;
        _loginBtn.backgroundColor = [UIColor blackColor];
        _loginBtn.frame = CGRectMake(40,CGRectGetMaxY(self.pwdTextField.frame) + 18, self.view.frame.size.width - 80, 50);
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginBtn addTarget:self action:@selector(loginButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}


-(UIButton *)registerBtn{
    if(_registerBtn == nil){
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 10;
        _registerBtn.backgroundColor = [UIColor blackColor];
        _registerBtn.frame = CGRectMake(40,CGRectGetMaxY(self.loginBtn.frame) + 18, self.view.frame.size.width - 80, 50);
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_registerBtn addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
@end
