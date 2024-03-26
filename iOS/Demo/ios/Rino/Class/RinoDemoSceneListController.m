//
//  RinoDemoSceneListController.m
//  Rino
//
//  Created by super on 2023/12/13.
//

#import "RinoDemoSceneListController.h"
#import <RinoSceneKit/RinoSceneKit.h>
#import <RinoSceneDefaultUISkin/RinoSceneDefaultUISkin.h>
@interface RinoDemoSceneListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *myTableView;

@property (nonatomic , strong) NSArray *dataList;

@property (nonatomic , strong) RinoHome *home;

@end

@implementation RinoDemoSceneListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.home = [RinoHome homeWithHomeId:self.homeId];
    [self setTitle:@"场景列表"];
    [self.view addSubview:self.myTableView];
    [self getSceneData];
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
    RinoSceneModel * sceneModel = self.dataList[indexPath.row];
    cell.textLabel.text = sceneModel.name?:@"";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    RinoSceneModel * sceneModel = self.dataList[indexPath.row];
    
    if (sceneModel.sceneType == RinoSceneTypeManual) {//执行一键执行
        [[RinoScene sharedInstance] executeManualSceneWithSceneId:sceneModel.sceneId
                                                          success:^{
            [RinoProgressHUD showSuccessMessage:@"rino_scene_manual_execution_succeed".localized];
        } failure:^(NSError *error) {
            [RinoProgressHUD showFailMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
        }];
    } else {//编辑场景
        [[RinoSceneDefaultUISkinManager sharedInstance] gotoSceneDetailsPageWithSceneModel:sceneModel];
    }
}

- (void)getSceneData {
    [[RinoScene sharedInstance] getSceneListWithHomeId:self.homeId
                                               success:^(NSArray<RinoSceneModel *> * _Nonnull sceneList) {
       
        self.dataList = sceneList;
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
