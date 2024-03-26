//
//  RinoDemoDeviceListController.m
//  Rino
//
//  Created by super on 2023/12/13.
//

#import "RinoDemoDeviceListController.h"
#import <RinoBizCore/RinoBizCore.h>
@interface RinoDemoDeviceListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *myTableView;

@property (nonatomic , strong) NSArray *dataList;

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
        [impl gotoDeviceViewControllerWithDeviceModel:model completion:^(UIViewController * _Nullable panelViewController) {
            [self.navigationController pushViewController:panelViewController animated:YES];
        }];
    } else if ([model isKindOfClass:[RinoGroupModel class]]) {//跳转群组面板
        RinoGroupModel *groupModel = model;
        [impl gotoGroupViewControllerWithGroupModel:model completion:^(UIViewController * _Nullable panelViewController) {
            [self.navigationController pushViewController:panelViewController animated:YES];
        }];
    }
    
}

/// 获取家庭下的设备列表
- (void)getHomeDeviceList {
    [self.home getHomeDeviceListAndGroupListWithSuccess:^(NSArray * _Nonnull list) {
        
        self.dataList = list;
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

@end
