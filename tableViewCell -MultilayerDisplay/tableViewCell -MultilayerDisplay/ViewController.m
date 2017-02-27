//
//  ViewController.m
//  tableViewCell -MultilayerDisplay
//
//  Created by ww on 17/2/25.
//  Copyright © 2017年 zww. All rights reserved.
//

#import "ViewController.h"
#import "CellItem.h"
#import <MJExtension.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *resultArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self initData];
}

- (void)initData {
    _dataArray = [NSMutableArray new];
    _resultArray = [NSMutableArray new];
    
    NSMutableArray *secondArray1 = [NSMutableArray new];
    NSMutableArray *threeArray1 = [NSMutableArray new];
    NSMutableArray *fourArray1 = [NSMutableArray new];
    NSMutableArray *fiveArray1 = [NSMutableArray new];
    NSMutableArray *sixArray1 = [NSMutableArray new];

    NSArray *FirstTitleArray = @[@"FirstTitle1", @"FirstTitle2", @"FirstTitle3", @"FirstTitle4", @"FirstTitle5", @"FirstTitle6", @"FirstTitle7", @"FirstTitle8", @"FirstTitle9", @"FirstTitle10"];
    NSArray *SecondTitleArray = @[@"SecondTitle1", @"SecondTitle2", @"SecondTitle3"];
    NSArray *ThreeTitleArray = @[@"ThreeTitle1", @"ThreeTitle2", @"ThreeTitle3", @"ThreeTitle4"];
    NSArray *FourTitleArray = @[@"FourTitle1", @"FourTitle2", @"FourTitle3"];
    NSArray *FiveTitleArray = @[@"FiveTitle1", @"FiveTitle2", @"FiveTitle3"];
    NSArray *SixTitleArray = @[@"SixTitle1", @"SixTitle2", @"SixTitle3"];

    //第6层数据
    for (int i = 0; i < FiveTitleArray.count; i++) {
        CellItem *model = [[CellItem alloc] init];
        model.title = SixTitleArray[i];
        model.level = 5;
        model.isOpen = NO;
        
        [sixArray1 addObject:model];
    }
    //第5层数据
    for (int i = 0; i < FiveTitleArray.count; i++) {
        CellItem *model = [[CellItem alloc] init];
        model.title = FiveTitleArray[i];
        model.level = 4;
        model.isOpen = NO;
        model.detailArray = [sixArray1 mutableCopy];

        [fiveArray1 addObject:model];
    }
    //第四层数据
    for (int i = 0; i < FourTitleArray.count; i++) {
        CellItem *model = [[CellItem alloc] init];
        model.title = FourTitleArray[i];
        model.level = 3;
        model.isOpen = NO;
        model.detailArray = [fiveArray1 mutableCopy];

        [fourArray1 addObject:model];
    }
    
    //第三层数据
    for (int i = 0; i < ThreeTitleArray.count; i++) {
        CellItem *model = [[CellItem alloc] init];
        model.title = ThreeTitleArray[i];
        model.level = 2;
        model.isOpen = NO;
        model.detailArray = [fourArray1 mutableCopy];
        
        [threeArray1 addObject:model];
    }
    
    //第二层数据
    for (int i = 0; i < SecondTitleArray.count; i++) {
        CellItem *model = [[CellItem alloc] init];
        model.title = SecondTitleArray[i];
        model.level = 1;
        model.isOpen = NO;
        model.detailArray = [threeArray1 mutableCopy];
        
        [secondArray1 addObject:model];
    }
    
    //第一层数据
    for (int i = 0; i < FirstTitleArray.count; i++) {
        CellItem *model = [[CellItem alloc] init];
        model.title = FirstTitleArray[i];
        model.level = 0;
        model.isOpen = NO;
        model.detailArray = [secondArray1 mutableCopy];
        
        [_dataArray addObject:model];
    }
    
    //处理源数据，获得展示数组_resultArray
    [self dealWithDataArray:_dataArray];
}

/**
 将源数据数组处理成要展示的一维数组，最开始是展示首层的所有的数据
 @param dataArray 源数据数组
 */
- (void)dealWithDataArray:(NSMutableArray *)dataArray {
    for (CellItem *model in dataArray) {
        [_resultArray addObject:model];
        
        if (model.isOpen && model.detailArray.count > 0) {
            [self dealWithDataArray:model.detailArray];
        }
    }
}

/**
 在指定位置插入要展示的数据
 @param dataArray 数据数组
 @param row       需要插入的数组下标
 */
- (void)addObjectWithDataArray:(NSMutableArray *)dataArray row:(NSInteger)row {
    for (int i = 0; i < dataArray.count; i++) {
        CellItem *model = dataArray[i];
        model.isOpen = NO;
        [_resultArray insertObject:model atIndex:row];
        row += 1;
    }
}

/**
 删除要收起的数据
 @param dataArray 数据
 @param count     统计删除数据的个数
 @return 删除数据的个数
 */
- (CGFloat)deleteObjectWithDataArray:(NSMutableArray *)dataArray count:(NSInteger)count {
    for (CellItem *model in dataArray) {
        count += 1;
        
        if (model.isOpen && model.detailArray.count > 0) {
            count = [self deleteObjectWithDataArray:model.detailArray count:count];
        }
        
        model.isOpen = NO;
        
        [_resultArray removeObject:model];
    }
    return count;
}

/**
 与点击同一层的数据比较，然后删除要收起的数据和插入要展开的数据
 @param model 点击的cell对应的model
 @param row   点击的在tableview的indexPath.row,也对应_resultArray的下标
 */
- (void)compareSameLevelWithModel:(CellItem *)model row:(NSInteger)row {
    NSInteger count = 0;
    NSInteger index = 0;    //需要收起的起始位置
    //如果直接用_resultArray，在for循环为完成之前，_resultArray会发生改变，使程序崩溃。
    NSMutableArray *copyArray = [_resultArray mutableCopy];
    
    for (int i = 0; i < copyArray.count; i++) {
        CellItem *openModel = copyArray[i];
        if (openModel.level == model.level) {
            //同一个层次的比较
            if (openModel.isOpen) {
                //删除openModel所有的下一层
                count = [self deleteObjectWithDataArray:openModel.detailArray count:count];
                index = i;
                openModel.isOpen = NO;
                break;
            }
        }
    }
    
    //插入的位置在删除的位置的后面，则需要减去删除的数量。
    if (row > index && row > count) {
        row -= count;
    }
    
    [self addObjectWithDataArray:model.detailArray row:row + 1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CellItem  *model = _resultArray[indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width / 2, 32)];
        label.font = [UIFont systemFontOfSize:14];
        label.tag = 100;
        
        [cell.contentView addSubview:label];
    }

    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == 100) {
            ((UILabel *)view).text = model.title;
            ((UILabel *)view).frame = CGRectMake(20 + (model.level - 1) * 20 , 0, [UIScreen mainScreen].bounds.size.width / 2, 32);
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    CellItem  *model = _resultArray[row];
    
    if (model.isOpen) {
        //原来是展开的，现在要收起,则删除model.detailArray存储的数据
        [self deleteObjectWithDataArray:model.detailArray count:0];
    }
    else {
        if (model.detailArray.count > 0) {
            //原来是收起的，现在要展开，则需要将同层次展开的收起，然后再展开
            [self compareSameLevelWithModel:model row:row];
        }
        else {
            //点击的是最后一层数据，跳转到别的界面
            NSLog(@"最后一层");
        }
    }
    
    model.isOpen = !model.isOpen;
    
    //滑动到屏幕顶部
    for (int i = 0; i < _resultArray.count; i++) {
        CellItem *openModel = _resultArray[i];
        
        if (openModel.isOpen && openModel.level == 0) {
            //将点击的cell滑动到屏幕顶部
            NSIndexPath *selectedPath = [NSIndexPath indexPathForRow:i inSection:0];
            [tableView scrollToRowAtIndexPath:selectedPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            if (([UIScreen mainScreen].bounds.size.width + (model.level-1) * 20) > [UIScreen mainScreen].bounds.size.width) {

            }
            
        }
    }
    
    [tableView reloadData];
}

@end
