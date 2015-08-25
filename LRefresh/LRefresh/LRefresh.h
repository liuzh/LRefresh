//
//  LRefresh.h
//  LRefresh
//
//  Created by mac on 15/8/25.
//  Copyright (c) 2015年 com.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LRefresh;

@protocol LRefreshDelegate <NSObject>
@required
- (NSDictionary *)paramsForRefresh:(LRefresh *)refresh;
- (void)refreshDidSuccess:(id)success;
@optional
- (void)refreshDidFailure:(id)failure;
@end

@interface LRefresh : NSObject
//总页数
@property (nonatomic,assign,readonly) NSInteger allRows;
//当前页索引 第几页
@property (nonatomic,assign,readonly) NSInteger pageIndex;
//表格数据数组(默认初始化)
@property (nonatomic,strong) NSMutableArray *arrData;
//代理
@property (nonatomic,weak) id <LRefreshDelegate>delegate;
//初始化
- (instancetype)initWithContentView:(UIScrollView *)scrollView;

//添加上拉、下拉刷新
- (void)addRefreshView;
//添加下拉刷新
- (void)addHeadRefreshView;
//添加上啦刷新
- (void)addFooterRefreshView;
//分页时，请求下一页
- (void)loadMorePage;
//刷新表格 并且为第一页数据
-(void)reload;

@end
