//
//  RinoDemoRegisterController.m
//  Rino
//
//  Created by super on 2023/12/13.
//

#import "RinoDemoRegisterController.h"
#import "RinoDemoCountryListController.h"
#import <RinoBaseKit/RinoBaseKit.h>
@interface RinoDemoRegisterController ()
@property (nonatomic , strong) UIButton *countryBtn;

@property (nonatomic , strong) UITextField *accountTextField;

@property (nonatomic , strong) UITextField *codeTextField;

@property (nonatomic , strong) UIButton *getCodeBtn;

@property (nonatomic , strong) UITextField *pwdTextField;

@property (nonatomic , strong) UIButton *registerBtn;

@property (nonatomic , copy) NSString *countryCode;

@property (nonatomic , copy) NSString *account;

@property (nonatomic , copy) NSString *pwd;

@property (nonatomic , copy) NSString *verifyCode;
@end

@implementation RinoDemoRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.countryCode = @"86";
    [self setChildView];
    
}

-(void)setChildView{
    [self.view addSubview:self.countryBtn];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.getCodeBtn];
    [self.view addSubview:self.pwdTextField];
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


#pragma mark - 发送验证码
- (void)getCodeButtonClick{
    [self.view endEditing:YES];
    self.account = [NSString stringWithFormat:@"%@",self.accountTextField.text];
    if(self.account.length == 0){
        [RinoToast  showMessage:@"请输入账号"];
        return;
    }
    [[RinoUser sharedInstance] sendVerifyCodeWithType:RinoVerifyCodeTypeRegister
                                             userName:self.account
                                          countryCode:self.countryCode
                                              success:^(NSDictionary *data) {
        
        [RinoToast showMessage:@"发送成功"];
        
    } failure:^(NSError *error) {
        [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
    }];
}

#pragma mark - 验证验证码
-(void)checkCode{
    [self.view endEditing:YES];
    self.pwd = [NSString stringWithFormat:@"%@",self.pwdTextField.text];
    self.verifyCode = [NSString stringWithFormat:@"%@",self.codeTextField.text];
    
    if(self.verifyCode.length == 0){
        [RinoToast  showMessage:@"请输入验证码"];
        return;
    }
    if(self.pwd.length == 0){
        [RinoToast  showMessage:@"请输入密码"];
        return;
    }
    [[RinoUser sharedInstance] checkVerifyCodeWithUserName:self.account
                                                      code:self.verifyCode
                                                   success:^{
        
        [self registerButtonClicked];
    } failure:^(NSError *error) {
        [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
    }];
}

#pragma mark - 注册
-(void)registerButtonClicked{
    if ([self.account checkPhone]) {
        [self registerByPhone];
    } else {
        [self registerByEmail];
    }
    
    
}
/// 邮箱注册
- (void)registerByEmail {
    [[RinoUser sharedInstance] registerByEmail:self.countryCode
                                         email:self.account
                                      password:self.pwd
                                          code:self.verifyCode
                                       success:^{
        [RinoToast showMessage:@"注册成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
    }];
}

/// 手机号注册
- (void)registerByPhone {
    [[RinoUser sharedInstance] registerByPhone:self.countryCode
                                         phone:self.account
                                      password:self.pwd
                                          code:self.verifyCode
                                       success:^{
        [RinoToast showMessage:@"注册成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
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

-(UITextField *)codeTextField{
    if(_codeTextField == nil){
        _codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.accountTextField.frame) + 18, 150, 50)];
        _codeTextField.layer.masksToBounds = YES;
        _codeTextField.layer.cornerRadius = 10;
        _codeTextField.layer.borderColor = [UIColor blackColor].CGColor;
        _codeTextField.layer.borderWidth = 1;
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.textColor = [UIColor blackColor];
        _codeTextField.font = [UIFont systemFontOfSize:16];
    }
    return _codeTextField;
}


-(UIButton *)getCodeBtn{
    if(_getCodeBtn == nil){
        _getCodeBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _getCodeBtn.layer.masksToBounds = YES;
        _getCodeBtn.layer.cornerRadius = 10;
        _getCodeBtn.backgroundColor = [UIColor blackColor];
        CGFloat viewX = CGRectGetMaxX(self.codeTextField.frame) + 12;
        CGFloat viewW = (kScreenWidth() - 50 ) - viewX;
        _getCodeBtn.frame = CGRectMake(viewX,CGRectGetMaxY(self.accountTextField.frame) + 18, viewW, 50);
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_getCodeBtn addTarget:self action:@selector(getCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}
-(UITextField *)pwdTextField{
    if(_pwdTextField == nil){
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.codeTextField.frame) + 18, self.view.frame.size.width - 80, 50)];
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




-(UIButton *)registerBtn{
    if(_registerBtn == nil){
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 10;
        _registerBtn.backgroundColor = [UIColor blackColor];
        _registerBtn.frame = CGRectMake(40,CGRectGetMaxY(self.pwdTextField.frame) + 18, self.view.frame.size.width - 80, 50);
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_registerBtn addTarget:self action:@selector(checkCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

@end
