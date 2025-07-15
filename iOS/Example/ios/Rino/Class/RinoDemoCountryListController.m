//
//  RinoDemoCountryListController.m
//  Rino
//
//  Created by super on 2023/12/13.
//

#import "RinoDemoCountryListController.h"

@interface RinoDemoCountryListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *myTableView;

@property (nonatomic , strong) NSArray *dataList;
@end

@implementation RinoDemoCountryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myTableView];
    [self getCountryList];
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
    RinoCountryModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:+%@",model.countryName,model.countryCode];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RinoCountryModel *model = self.dataList[indexPath.row];
    if(self.clickBlock){
        self.clickBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 国家列表
- (void)getCountryList{
    [[RinoCountry sharedInstance] getCountryListWithCompletion:^(NSArray<RinoCountryModel *> * _Nonnull list) {
        NSLog(@"国家列表：%@",list);
        self.dataList = list;
        [self.myTableView reloadData];
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
