//
//  RinoHomeTestViewController.m
//  Rino
//
//  Created by super on 2023/12/12.
//

#import "RinoHomeTestViewController.h"
#import <RinoDeviceKit/RinoDeviceKit.h>
#import "RinoDemoFamilyListController.h"
#import "RinoDemoDeviceListController.h"
#import "RinoDemoSceneListController.h"
#import <RinoMessageDefaultUISKin/RinoMessageManager.h>
#import <RinoSceneDefaultUISkin/RinoSceneDefaultUISkin.h>
#import <RinoActivatorDefaultUISkin/RinoActivatorDefaultUISkin.h>
#import <RinoUserSettingsDefaultUISkin/RinoUserSettingsDefaultUISkin.h>
#import <RinoHomeDefaultUISkin/RinoHomeDefaultUISkin.h>
@interface RinoHomeTestViewController ()<UITableViewDelegate,UITableViewDataSource,RinoHomeDelegate>

@property (nonatomic , strong) UITableView *myTableView;

@property (nonatomic , strong) NSMutableArray *dataList;

@property (nonatomic , strong) RinoHome *home;
@end

@implementation RinoHomeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.myTableView];
    [self getHomeList];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"cell%zd", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *titleStr = self.dataList[indexPath.row];
    cell.textLabel.text = titleStr;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *titleStr = self.dataList[indexPath.row];
    
    if([titleStr isEqualToString:@"家庭列表"]){//家庭列表
        RinoDemoFamilyListController *familyVC = [[RinoDemoFamilyListController alloc]init];
        [familyVC setClickBlock:^(RinoHomeModel * _Nonnull homeModel) {
            self.home = [RinoHome homeWithHomeId:homeModel.homeId];
            [self getHomeDetail];
        }];
        [self.navigationController pushViewController:familyVC animated:YES];
    }else if ([titleStr isEqualToString:@"设备列表"]){
        RinoDemoDeviceListController *deviceVC = [[RinoDemoDeviceListController alloc]init];
        deviceVC.homeId = self.home.homeModel.homeId;
        [self.navigationController pushViewController:deviceVC animated:YES];
    }else if([titleStr isEqualToString:@"场景列表"]){
        RinoDemoSceneListController *sceneVC = [[RinoDemoSceneListController alloc]init];
        sceneVC.homeId = self.home.homeModel.homeId;
        [self.navigationController pushViewController:sceneVC animated:YES];
    }else if([titleStr isEqualToString:@"消息中心"]){
        [[RinoMessageManager sharedInstance] gotoMessageViewController];
    }else if([titleStr isEqualToString:@"添加设备"]){
        [[RinoActivatorManager sharedInstance] gotoActivatorViewControllerWithHomeId:self.home.homeModel.homeId];
    }else if([titleStr isEqualToString:@"添加一键执行场景"]){
        [[RinoSceneDefaultUISkinManager sharedInstance] gotoAddManualSceneViewControllerWithHomeId:self.home.homeModel.homeId];
    }else if([titleStr isEqualToString:@"添加自动化场景"]){
        [[RinoSceneDefaultUISkinManager sharedInstance] gotoAddAutomaticSceneViewControllerWithHomeId:self.home.homeModel.homeId];
    }else if ([titleStr isEqualToString:@"设置"]){
        [[RinoUserSettingsDefaultUISkinManager sharedInstance] gotoUserSettingViewController];
    }else if ([titleStr isEqualToString:@"家庭管理"]){
        [[RinoHomeDefaultUISkinManager sharedInstance] gotoFamilyManagementViewController];
    }
    
}



/// 获取家庭列表
- (void)getHomeList {
    RinoHomeManager *homeManager = [[RinoHomeManager alloc] init];
    [homeManager getHomeListWithSuccess:^(NSArray<RinoHomeModel *> * _Nonnull homes) {
        if (homes.count > 0) {
            RinoHomeModel *homeModel = homes[0];
            self.home = [RinoHome homeWithHomeId:homeModel.homeId];
            [self getHomeDetail];
        } else {
            [RinoProgressHUD hideHUDView];
        }
    } failure:^(NSError *error) {
        [RinoProgressHUD hideHUDView];
        [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
    }];
}
/// 获取家庭详情
- (void)getHomeDetail {
    [self.home getHomeDataWithSuccess:^(RinoHomeModel * _Nonnull homeModel) {
        [self setTitle:homeModel.name];
        self.home.delegate = self;
        NSMutableArray *titles = [NSMutableArray array];
        for (RinoRoomModel *roomModel in self.home.roomList) {
            [titles addObject:roomModel.name?:@""];
        }
        
    } failure:^(NSError *error) {
        [RinoProgressHUD hideHUDView];
        [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
    }];
}

#pragma mark - RinoHomeDelegate

- (void)home:(RinoHome *)home didAddDevice:(RinoDeviceModel *)deviceModel {
    
}

- (void)home:(RinoHome *)home didRemoveDevice:(NSString *)deviceId {
}

- (void)home:(RinoHome *)home deviceInfoUpdate:(RinoDeviceModel *)deviceModel {
    
}

- (void)home:(RinoHome *)home device:(RinoDeviceModel *)device dataPointUpdate:(NSDictionary *)dps {
    
}

- (void)home:(RinoHome *)home deviceAlert:(RinoDeviceModel *)deviceModel {
   
}

- (void)gotoDeviceDetailsWithDeviceModel:(RinoDeviceModel *)deviceModel {
    
}

-(UITableView *)myTableView{
    if(_myTableView == nil){
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth(), kScreenHeight()) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}
-(NSMutableArray *)dataList{
    if(_dataList == nil){
        _dataList = [NSMutableArray array];
        [_dataList addObject:@"家庭列表"];
        [_dataList addObject:@"家庭管理"];
        [_dataList addObject:@"设备列表"];
        [_dataList addObject:@"场景列表"];
        [_dataList addObject:@"消息中心"];
        [_dataList addObject:@"添加设备"];
        [_dataList addObject:@"添加一键执行场景"];
        [_dataList addObject:@"添加自动化场景"];
        [_dataList addObject:@"设置"];
        
    }
    return _dataList;
}



@end
