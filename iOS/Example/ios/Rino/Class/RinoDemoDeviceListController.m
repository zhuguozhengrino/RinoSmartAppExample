//
//  RinoDemoDeviceListController.m
//  Rino
//
//  Created by super on 2023/12/13.
//

#import "RinoDemoDeviceListController.h"
#import <RinoBizCore/RinoBizCore.h>
#import "RinoDeviceIpcViewController.h"
@interface RinoDemoDeviceListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *myTableView;

@property (nonatomic , strong) NSMutableArray *dataList;

@property (nonatomic , strong) RinoHome *home;

@end

@implementation RinoDemoDeviceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.home = [RinoHome homeWithHomeId:self.homeId];
    [self setTitle:@"设备列表"];
    [self.view addSubview:self.myTableView];
    [self getHomeDeviceList];
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
    id model = self.dataList[indexPath.row];
    if ([model isKindOfClass:[RinoDeviceModel class]]) {
        RinoDeviceModel *deviceModel = model;
        cell.textLabel.text = deviceModel.name?:@"";
    } else if ([model isKindOfClass:[RinoGroupModel class]]) {
        RinoGroupModel *groupModel = model;
        cell.textLabel.text = [NSString stringWithFormat:@"%@（群组）",groupModel.name?:@""];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    id model = self.dataList[indexPath.row];
    id<RinoDeviceHomeProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoDeviceHomeProtocol)];
    if ([model isKindOfClass:[RinoDeviceModel class]]) {//跳转设备面板
        RinoDevice *device = [RinoDevice deviceWithDeviceId:@""];
        RinoDeviceModel *deviceModel = model;
        id<RinoDeviceHomeProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoDeviceHomeProtocol)];
        if (impl && [impl respondsToSelector:@selector(gotoDeviceViewControllerWithDeviceModel:completion:)]) {
            [impl gotoDeviceViewControllerWithDeviceModel:deviceModel
                                               completion:^(UIViewController * _Nullable panelViewController) {
                if (panelViewController) {
                    [TopViewController().navigationController pushViewController:panelViewController animated:YES];
                }
            }];
        }
        
    } else if ([model isKindOfClass:[RinoGroupModel class]]) {//跳转群组面板
        RinoGroupModel *groupModel = model;
        id<RinoDeviceHomeProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoDeviceHomeProtocol)];
        if (impl && [impl respondsToSelector:@selector(gotoGroupViewControllerWithGroupModel:completion:)]) {
            [impl gotoGroupViewControllerWithGroupModel:groupModel
                                             completion:^(UIViewController * _Nullable panelViewController) {
                if (panelViewController) {
                    [TopViewController().navigationController pushViewController:panelViewController animated:YES];
                }
            }];
        }
    }
    
}

/// 获取家庭下的设备列表
- (void)getHomeDeviceList {
    [self.home getHomeDeviceListAndGroupListWithSuccess:^(NSArray * _Nonnull list) {
        for (id model in list) {
            if ([model isKindOfClass:[RinoDeviceModel class]]) {
                RinoDeviceModel *deviceModel = model;
                [self.dataList addObject:deviceModel];
            } else if ([model isKindOfClass:[RinoGroupModel class]]) {
                RinoGroupModel *groupModel = model;
                [self.dataList addObject:groupModel];
            }
        }
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
        
    }];
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
    }
    return _dataList;
}

@end
