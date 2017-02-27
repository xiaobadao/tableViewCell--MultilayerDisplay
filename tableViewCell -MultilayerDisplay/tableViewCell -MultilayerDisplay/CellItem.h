//
//  CellItem.h
//  tableViewCell -MultilayerDisplay
//
//  Created by ww on 17/2/25.
//  Copyright © 2017年 zww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellItem : NSObject

//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, assign) NSInteger *level;
//@property (nonatomic, strong) NSMutableArray *subItems;
//@property (nonatomic, assign) BOOL isSubItemOpen;
//@property (nonatomic, assign) BOOL isSubCascadeOpen;
@property (copy, nonatomic) NSString *title;    //非首层展示的标题
@property (assign, nonatomic) NSInteger level;  //决定偏移量大小
@property (copy, nonatomic) NSString *openUrl;  //最后一层跳转的规则
@property (copy, nonatomic) NSMutableArray *detailArray; //下一层的数据
@property (assign, nonatomic) BOOL isOpen;        //是否要展开

@end
