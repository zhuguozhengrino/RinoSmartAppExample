//
//  RinoDemoFmailyListController.m
//  Rino
//
//  Created by super on 2023/12/13.
//

#import "RinoDemoFamilyListController.h"

@interface RinoDemoFamilyListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *myTableView;

@property (nonatomic , strong) NSArray *dataList;
@end

@implementation RinoDemoFamilyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"家庭列表"];
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
    RinoHomeModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = model.name?:@"";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RinoHomeModel *model = self.dataList[indexPath.row];
    if(self.clickBlock){
        self.clickBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

/// 获取家庭列表
- (void)getHomeList {
    RinoHomeManager *homeManager = [[RinoHomeManager alloc] init];
    [homeManager getHomeListWithSuccess:^(NSArray<RinoHomeModel *> * _Nonnull homes) {
        self.dataList = homes;
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
