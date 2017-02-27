//
//  CellItem.m
//  tableViewCell -MultilayerDisplay
//
//  Created by ww on 17/2/25.
//  Copyright © 2017年 zww. All rights reserved.
//

#import "CellItem.h"
#import <MJExtension.h>

@implementation CellItem

#pragma mark -- insert 

//- (NSArray *)insertMenuIndexPaths:(CellItem *)item
//{
//    NSArray *arr;
//    
//}

- (instancetype)init
{
    if (self = [super init]) {
        
        [CellItem mj_setupObjectClassInArray:^NSDictionary *{
            
            return @{
                     @"detailArray" : [CellItem class]
                     };
        }];
    }
    return self;
}
@end
