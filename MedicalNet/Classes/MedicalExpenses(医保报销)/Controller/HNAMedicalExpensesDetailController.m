//
//  HNAMedicalExpensesDetailController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/27.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAMedicalExpensesDetailController.h"
#import "HNAExpenseDetailCell.h"
#import "HNAInsuranceTool.h"
#import "HNAExpenseDetailModel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#define DetailViewHeight 320

@interface HNAMedicalExpensesDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *checkDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_H;

@property (strong, nonatomic) NSMutableArray<HNAExpenseDetailStatusRecord *> *statusRecords;

- (IBAction)checkDetailBtnClick:(UIButton *)sender;

@end

@implementation HNAMedicalExpensesDetailController

- (NSMutableArray *)statusRecords{
    if (_statusRecords == nil) {
        _statusRecords = [NSMutableArray array];
        
        HNAExpenseDetailStatusRecord *record1 = [[HNAExpenseDetailStatusRecord alloc] init];
        record1.date = @"2015-11-11";
        record1.desc = @"已报销￥1,800";
        [_statusRecords addObject:record1];
        
        HNAExpenseDetailStatusRecord *record2 = [[HNAExpenseDetailStatusRecord alloc] init];
        record2.date = @"2015-11-11";
        record2.desc = @"开始处理";
        [_statusRecords addObject:record2];
        
        HNAExpenseDetailStatusRecord *record3 = [[HNAExpenseDetailStatusRecord alloc] init];
        record3.date = @"2015-11-11";
        record3.desc = @"需补交材料";
        [_statusRecords addObject:record3];
        
        HNAExpenseDetailStatusRecord *record4 = [[HNAExpenseDetailStatusRecord alloc] init];
        record4.date = @"2015-11-11";
        record4.desc = @"提交申请";
        [_statusRecords addObject:record4];
    }
    return _statusRecords;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAExpenseDetailCell" bundle:nil] forCellReuseIdentifier:@"HNAExpenseDetailCell"];
    
    for (UIImageView *imageView in self.imageViews) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tapGesture];
        imageView.userInteractionEnabled = YES;
    }

}

- (void)tapImageView:(UITapGestureRecognizer *)tap{
    NSMutableArray *photoArray = [NSMutableArray array];
    for (UIImageView *imageView in self.imageViews) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url =[NSURL URLWithString: @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/topnav/music.png?v=md5"];
        photo.srcImageView = imageView;
        [photoArray addObject:photo];
    }
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = photoArray;
    photoBrowser.currentPhotoIndex = tap.view.tag;
    [photoBrowser show];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.tableView_H.constant = self.tableView.contentSize.height;
    [self.view layoutIfNeeded];
}


#pragma mark - 请求数据
- (void)loadData {
    [HNAInsuranceTool getExpenseDirectionsWithCompanyId:@"" success:^(HNAExpenseDirectionModel *direction) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma  mark - 单击事件
- (IBAction)checkDetailBtnClick:(UIButton *)sender {
    if (self.detailView.hidden) {
        [self spreadDetailView];
    } else {
        [self closeDetailView];
    }
}

/**
 *  detailView展开
 */
- (void)spreadDetailView{
    CGFloat height = DetailViewHeight;
    
    // 隐藏detailView
    self.detailView.hidden = NO;
    
    // 设置“查看明细”文字
    [self.checkDetailBtn setTitle:@"收起" forState:UIControlStateNormal];
    
    // 展开动画
    WEAKSELF(weakSelf);
    self.detailViewHeightConstraint.constant = height;
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

/**
 *  detailView收起
 */
- (void)closeDetailView{
    CGFloat height = 0;
    
    // 设置“查看明细”按钮文字
    [self.checkDetailBtn setTitle:@"查看报销明细" forState:UIControlStateNormal];
    
    // 收起动画
    WEAKSELF(weakSelf);
    self.detailViewHeightConstraint.constant = height;
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.detailView.hidden = YES;
    }];
}

#pragma mark - tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statusRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAExpenseDetailCell *cell = [HNAExpenseDetailCell cellWithTableView:tableView];
    
    cell.model = self.statusRecords[indexPath.row];
    cell.showTip = indexPath.row == 2;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
