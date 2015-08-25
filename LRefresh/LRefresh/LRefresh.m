//
//  LRefresh.m
//  LRefresh
//
//  Created by mac on 15/8/25.
//  Copyright (c) 2015年 com.liu. All rights reserved.
//

#import "LRefresh.h"
#import "MJRefresh.h"
#import "AFNetworking.h"

NSString *const kPaging = @"paging";
NSString *const kPage = @"page";
NSString *const kPerPage = @"perPage";

@interface LRefresh ()
//数据列表（UITableView或UICollectionView）
@property (nonatomic,strong)UIScrollView *contentView;
//总页数
@property (nonatomic,assign,readwrite) NSInteger allRows;
//当前页索引 第几页
@property (nonatomic,assign,readwrite) NSInteger pageIndex;

@end

@implementation LRefresh

- (instancetype)initWithContentView:(UIScrollView *)scrollView{
    self = [super init];
    if (self) {
        _contentView = scrollView;
        _arrData = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}

//添加上拉、下拉刷新
- (void)addRefreshView{
    [self addHeadRefreshView];
    [self addFooterRefreshView];
}
//添加下拉刷新
- (void)addHeadRefreshView{
    __weak LRefresh *weakSelf = self;
    self.contentView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf.arrData removeAllObjects];
        [weakSelf requestNetWorkIsHead:YES];
    }];
    [self reload];
}
//添加上啦刷新
- (void)addFooterRefreshView{
    __weak LRefresh *weakSelf = self;
    self.contentView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ++ weakSelf.pageIndex;
        [weakSelf requestNetWorkIsHead:NO];
    }];
    self.contentView.footer.hidden = YES;

}
//分页时，请求下一页
- (void)loadMorePage
{
    [self.contentView.footer beginRefreshing];
}
//刷新表格 并且为第一页数据
-(void)reload{
    if (self.contentView.header) {
        [self.contentView.header beginRefreshing];
    } else {
        self.pageIndex = 1;
        [self.arrData removeAllObjects];
        [self requestNetWorkIsHead:YES];
    }
}

- (void)requestNetWorkIsHead:(BOOL)isHead
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(paramsForRefresh:)] && [self.delegate respondsToSelector:@selector(refreshDidSuccess:)]) {
        NSDictionary *parameter = [self requestParameter];
        //该部分根据自己的业务替换网络请求
        NSString *urlStr = @"http://v5.pc.duomi.com/search-ajaxsearch-searchall";
        __weak LRefresh *weakSelf = self;
        [[AFHTTPRequestOperationManager manager] POST:urlStr parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //数据回调
            [weakSelf didSuccess:responseObject isHead:isHead];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf didFailure:error isHead:isHead];
        }];
    }
}

- (void)didSuccess:(id)responseObject isHead:(BOOL)isHead
{
    //数据回调
    [self.delegate refreshDidSuccess:responseObject];
    //处理上拉加在更多
    [self endRefreshIsHead:isHead response:responseObject];
    //reloadData
    if ([self.contentView respondsToSelector:@selector(reloadData)]) {
        [(id)self.contentView reloadData];
    }
    if (self.arrData.count > 0){
        self.contentView.footer.hidden = NO;
    }
}

- (void)didFailure:(NSError *)error isHead:(BOOL)isHead
{
    [self endRefreshIsHead:isHead response:error];
    if ([self.delegate respondsToSelector:@selector(refreshDidFailure:)]) {
        [self.delegate refreshDidFailure:error];
    }
    self.contentView.footer.hidden = !(self.arrData.count > 0);
}

- (void)endRefreshIsHead:(BOOL)isHead response:(id)responseObject
{
    //根据自己的业务获取总页数
    self.allRows = 100;
    
    if (isHead) {
        [self.contentView.header endRefreshing];
    }else{
        [self.contentView.footer endRefreshing];
    }
    
    if (self.allRows <= self.arrData.count && self.arrData.count>0) {
        [self.contentView.footer noticeNoMoreData];
    }else{
        [self.contentView.footer resetNoMoreData];
    }
}

- (NSDictionary *)requestParameter
{
    NSMutableDictionary *parameter = [[self.delegate paramsForRefresh:self] mutableCopy];
    //根据自己的业务处理页码
    if (!parameter[kPaging]) {
        parameter[kPaging] = @(YES);
    }
    parameter[kPage] = @(self.pageIndex);
    return parameter;
}
@end
