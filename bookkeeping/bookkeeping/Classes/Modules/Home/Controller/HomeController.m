/**
 * 首页
 * @author 郑业强 2018-12-16 创建文件
 */

#import "HomeController.h"
#import "HomeNavigation.h"
#import "HomeHeader.h"
#import "HomeList.h"
#import "HomeListSubCell.h"
#import "LoginController.h"
#import "BKModel.h"
#import "BDController.h"
#import "HOME_EVENT.h"


#pragma mark - 声明
@interface HomeController()

@property (nonatomic, strong) HomeNavigation *navigation;
@property (nonatomic, strong) HomeHeader *header;
@property (nonatomic, strong) HomeList *list;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray<BKMonthModel *> *models;
@property (nonatomic, strong) NSDictionary<NSString *, NSInvocation *> *eventStrategy;

@end


#pragma mark - 实现
@implementation HomeController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setJz_navigationBarHidden:true];
//    [self navigation];
//    [self header];
//    [self list];
//    [self setDate:[NSDate date]];
//    [self monitorNotification];
//    [self setModels:[BKMonthModel statisticalMonthWithYear:_date.year month:_date.month]];
}
// 监听通知
- (void)monitorNotification {
    // 记账
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOT_BOOK_COMPLETE object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self setModels:[BKMonthModel statisticalMonthWithYear:self.date.year month:self.date.month]];
    }];
    // 删除记账
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOT_BOOK_DELETE object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self setModels:[BKMonthModel statisticalMonthWithYear:self.date.year month:self.date.month]];
    }];
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self syncedDataRequest];
}


#pragma mark - 请求
// 查账
- (void)bookRequest:(NSDate *)date {
//    // 未登录
//    if (![UserInfo isLogin]) {
//        BKModel *model = [BKModel new];
//        model.listSorts = @[].mutableCopy;
//        model.group = @[].mutableCopy;
//        model.list = @[].mutableCopy;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self setModel:model];
//            [self setDate:date];
//        });
//        return;
//    }
    
//    // 已登录
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                           @(date.year), @"year",
//                           @(date.month), @"month",
//                           @(1), @"hasList",
//                           @(1), @"hasGroup", nil];
//    @weakify(self)
//    [AFNManager POST:GetBookRequest params:param complete:^(APPResult *result) {
//        @strongify(self)
//        // 成功
//        if (result.status == ServiceCodeSuccess) {
//            [self setModel:[BKModel mj_objectWithKeyValues:result.data]];
//            [self setDate:date];
//        }
//        // 失败
//        else {
//            [self showWindowTextHUD:result.message delay:1.f];
//        }
//    }];
}


// 同步数据
- (void)syncedDataRequest {
    
    // 类别
    // 系统 - 添加的 - 支出
    NSMutableArray<BKCModel *> *cateSysHasPayArr = [[PINDiskCache sharedCache] objectForKey:PIN_CATE_SYS_Has_PAY_SYNCED];
    // 系统 - 删除的 - 支出
    NSMutableArray<BKCModel *> *cateSysRemovePayArr = [[PINDiskCache sharedCache] objectForKey:PIN_CATE_SYS_REMOVE_PAY_SYNCED];
    // 用户 - 添加的 - 支出
    NSMutableArray<BKCModel *> *cateCusHasPayArr = [[PINDiskCache sharedCache] objectForKey:PIN_CATE_CUS_HAS_PAY_SYNCED];
    // 用户 - 删除的 - 支出
    NSMutableArray<BKCModel *> *cateCusRemovePayArr = [[PINDiskCache sharedCache] objectForKey:PIN_CATE_CUS_REMOVE_PAY_SYNCED];
    
    
    // 系统 - 添加的 - 收入
    NSMutableArray *cateSysHasIncomeArr = [[PINDiskCache sharedCache] objectForKey:PIN_CATE_SYS_Has_INCOME_SYNCED];
    // 系统 - 删除的 - 收入
    NSMutableArray *cateSysRemoveIncomeArr = [[PINDiskCache sharedCache] objectForKey:PIN_CATE_SYS_REMOVE_INCOME_SYNCED];
    // 用户 - 添加的 - 收入
    NSMutableArray *cateCusHasIncomeArr = [[PINDiskCache sharedCache] objectForKey:PIN_CATE_CUS_HAS_INCOME_SYNCED];
    // 用户 - 删除的 - 收入
    NSMutableArray *cateCusRemoveIncomeArr = [[PINDiskCache sharedCache] objectForKey:PIN_CATE_CUS_REMOVE_INCOME_SYNCED];
    
    
    // 记账信息
    NSMutableArray<BKModel *> *bookArr = [[PINDiskCache sharedCache] objectForKey:PIN_BOOK_SYNCED];
    
    
    // 声音开关
    NSNumber *sound = [[PINDiskCache sharedCache] objectForKey:PIN_SETTING_SOUND_SYNCED];
    // 明细详情
    NSNumber *detail = [[PINDiskCache sharedCache] objectForKey:PIN_SETTING_DETAIL_SYNCED];
    
    
    // 定时
    NSMutableArray *timing = [[PINDiskCache sharedCache] objectForKey:PIN_TIMING_SYNCED];
    
    
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [[BKCModel mj_keyValuesArrayWithObjectArray:cateSysRemovePayArr] mj_JSONString], @"cateSysRemovePayArr",
                                  [[BKCModel mj_keyValuesArrayWithObjectArray:cateSysHasPayArr] mj_JSONString], @"cateSysHasPayArr",
                                  [[BKCModel mj_keyValuesArrayWithObjectArray:cateCusRemovePayArr] mj_JSONString], @"cateCusRemovePayArr",
                                  [[BKCModel mj_keyValuesArrayWithObjectArray:cateCusHasPayArr] mj_JSONString], @"cateCusHasPayArr",
//
//                                  [[BKCModel mj_keyValuesArrayWithObjectArray:cateSysRemoveIncomeArr] mj_JSONString], @"cateSysRemoveIncomeArr",
//                                  [[BKCModel mj_keyValuesArrayWithObjectArray:cateSysHasIncomeArr] mj_JSONString], @"cateSysHasIncomeArr",
//                                  [[BKCModel mj_keyValuesArrayWithObjectArray:cateCusRemoveIncomeArr] mj_JSONString], @"cateCusRemoveIncomeArr",
//                                  [[BKCModel mj_keyValuesArrayWithObjectArray:cateCusHasIncomeArr] mj_JSONString], @"cateCusHasIncomeArr",
//
//                                  [[BKModel mj_keyValuesArrayWithObjectArray:bookArr] mj_JSONString], @"book",
//                                  sound, @"sound",
                                  detail, @"detail",
//                                  timing, @"timing",
                                  nil];
    
    
    
    
    
    @weakify(self)
    [self showTextHUD:@"同步中...."];
    [AFNManager POST:SyncedDataRequest params:param complete:^(APPResult *result) {
        @strongify(self)
        [self hideHUD];
        // 成功
        if (result.status == ServiceCodeSuccess) {
            [[PINDiskCache sharedCache] setObject:[NSMutableArray array] forKey:PIN_CATE_SYS_REMOVE_PAY_SYNCED];
            [[PINDiskCache sharedCache] setObject:[NSMutableArray array] forKey:PIN_CATE_SYS_Has_PAY_SYNCED];
            [[PINDiskCache sharedCache] setObject:[NSMutableArray array] forKey:PIN_CATE_CUS_REMOVE_PAY_SYNCED];
            [[PINDiskCache sharedCache] setObject:[NSMutableArray array] forKey:PIN_CATE_CUS_HAS_PAY_SYNCED];
            
            
        }
        // 失败
        else {
            [self showTextHUD:result.message delay:1.5f];
        }
    }];
}



#pragma mark - set
- (void)setModels:(NSMutableArray<BKMonthModel *> *)models {
    _models = models;
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        self.header.models = models;
        self.list.models = models;
    });
}
- (void)setDate:(NSDate *)date {
    _date = date;
    _header.date = date;
}


#pragma mark - 事件
- (void)routerEventWithName:(NSString *)eventName data:(id)data {
    [self handleEventWithName:eventName data:data];
}
- (void)handleEventWithName:(NSString *)eventName data:(id)data {
    NSInvocation *invocation = self.eventStrategy[eventName];
    [invocation setArgument:&data atIndex:2];
    [invocation invoke];
    [super routerEventWithName:eventName data:data];
}
// 点击月份
- (void)homeMonthClick:(id)data {
    @weakify(self)
    NSDate *date = self.date;
    NSDate *min = [NSDate br_setYear:2000 month:1 day:1];
    NSDate *max = [NSDate br_setYear:[NSDate date].year + 3 month:12 day:31];
    [BRDatePickerView showDatePickerWithTitle:@"选择日期" dateType:BRDatePickerModeYM defaultSelValue:[date formatYM] minDate:min maxDate:max isAutoSelect:false themeColor:nil resultBlock:^(NSString *selectValue) {
        @strongify(self)
        [self setDate:[NSDate dateWithYM:selectValue]];
        [self setModels:[BKMonthModel statisticalMonthWithYear:self.date.year month:self.date.month]];
    }];
}
// 下拉
- (void)homeTablePull:(id)data {
    [self setDate:[self.date offsetMonths:1]];
    [self setModels:[BKMonthModel statisticalMonthWithYear:_date.year month:_date.month]];
}
// 上拉
- (void)homeTableUp:(id)data {
    [self setDate:[self.date offsetMonths:-1]];
    [self setModels:[BKMonthModel statisticalMonthWithYear:_date.year month:_date.month]];
}
// 删除Cell
- (void)homeTableCellRemove:(HomeListSubCell *)cell {
    NSLog(@"删除Cell");
    // 删除
    NSMutableArray<BKModel *> *bookArrm = [[PINCacheManager sharedManager] objectForKey:PIN_BOOK];
    NSMutableArray<BKModel *> *bookSyncedArrm = [[PINCacheManager sharedManager] objectForKey:PIN_BOOK_SYNCED];
    if ([bookSyncedArrm containsObject:cell.model]) {
        [bookSyncedArrm removeObject:cell.model];
    }
    [bookArrm removeObject:cell.model];
    [[PINCacheManager sharedManager] setObject:bookArrm forKey:PIN_BOOK];
    [[PINCacheManager sharedManager] setObject:bookArrm forKey:PIN_BOOK_SYNCED];
    
    // 更新
    [[NSNotificationCenter defaultCenter] postNotificationName:NOT_BOOK_DELETE object:nil];
}
// 点击Cell
- (void)homeTableCellClick:(BKModel *)model {
    NSNumber *detail = [[PINCacheManager sharedManager] objectForKey:PIN_SETTING_DETAIL];
    // 详情
    if ([detail boolValue] == true) {
        BDController *vc = [[BDController alloc] init];
        vc.model = model;
        vc.complete = ^{
            [self setModels:[BKMonthModel statisticalMonthWithYear:_date.year month:_date.month]];
        };
        [self.navigationController pushViewController:vc animated:true];
    }
    // 修改
    else {
        BKCController *vc = [[BKCController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:true];
    }
}


#pragma mark - get
- (HomeNavigation *)navigation {
    if (!_navigation) {
        _navigation = [HomeNavigation loadFirstNib:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBarHeight)];
        [self.view addSubview:_navigation];
    }
    return _navigation;
}
- (HomeHeader *)header {
    if (!_header) {
        _header = [HomeHeader loadFirstNib:CGRectMake(0, _navigation.bottom, SCREEN_WIDTH, countcoordinatesX(64))];
        [self.view addSubview:_header];
    }
    return _header;
}
- (HomeList *)list {
    if (!_list) {
        _list = [HomeList loadCode:({
            CGFloat top = CGRectGetMaxY(_header.frame);
            CGFloat height = SCREEN_HEIGHT - top - TabbarHeight;
            CGRectMake(0, top, SCREEN_WIDTH, height);
        })];
        [self.view addSubview:_list];
    }
    return _list;
}
- (NSDictionary<NSString *, NSInvocation *> *)eventStrategy {
    if (!_eventStrategy) {
        _eventStrategy = @{
                           HOME_MONTH_CLICK: [self createInvocationWithSelector:@selector(homeMonthClick:)],
                           HOME_TABLE_PULL: [self createInvocationWithSelector:@selector(homeTablePull:)],
                           HOME_TABLE_UP: [self createInvocationWithSelector:@selector(homeTableUp:)],
                           HOME_CELL_REMOVE: [self createInvocationWithSelector:@selector(homeTableCellRemove:)],
                           HOME_CELL_CLICK: [self createInvocationWithSelector:@selector(homeTableCellClick:)],
                           
                           };
    }
    return _eventStrategy;
}


@end
