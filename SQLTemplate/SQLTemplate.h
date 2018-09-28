//
//  SQLTemplate.h
//  sqltest
//
//  Created by Yuuki on 2018/9/27.
//  Copyright © 2018 Yuuki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 该语句是何种类型

 - SQLTemplateModeAdd: 添加
 - SQLTemplateModeDelete: 删除
 - SQLTemplateModeUpdate: 修改
 - SQLTemplateModeSelect: 查询
 - SQLTemplateModeCreateTable: 创建表
 */
typedef NS_ENUM(NSInteger, SQLTemplateMode) {
    SQLTemplateModeAdd = 0,
    SQLTemplateModeDelete,
    SQLTemplateModeUpdate,
    SQLTemplateModeSelect,
    SQLTemplateModeCreateTable,
};

/**
 比较语句中与前一个条件的关系 是AND或OR 第一个条件不受影响

 - SQLTemplateRelationNone: 无关系 若不是第一个条件默认AND
 - SQLTemplateRelationAnd: AND
 - SQLTemplateRelationOr: OR
 */
typedef NS_ENUM(NSInteger, SQLTemplateRelation) {
    SQLTemplateRelationNone = 0,
    SQLTemplateRelationAnd,
    SQLTemplateRelationOr,
};

/**
 排序规则

 - SQLTemplateOrderAsc: 正序
 - SQLTemplateOrderDesc: 逆序
 */
typedef NS_ENUM(NSInteger, SQLTemplateOrder) {
    SQLTemplateOrderAsc,
    SQLTemplateOrderDesc,
};

@interface SQLTemplate : NSObject

#pragma mark - initial methods

/**
 初始化对象

 @param tableName 表名
 @param mode 语句类型
 @return 对象
 */
- (instancetype)initWithTableName:(NSString *)tableName withMode:(SQLTemplateMode)mode;

/**
 初始化

 @param tableName 表名
 @param mode 语句类型
 @return 对象
 */
+ (instancetype)templateWithTableName:(NSString *)tableName withMode:(SQLTemplateMode)mode;

/**
 语句类型
 */
@property (assign, nonatomic, readonly) SQLTemplateMode mode;

/**
 表名
 */
@property (copy, nonatomic, readonly) NSString *tableName;

/**
 最终生成的SQL语句
 */
@property (copy, nonatomic, readonly) NSString *SQL;

#pragma mark - common methods

/**
 添加WHERE语句

 @param whereString where语句
 @param relation 与前一个条件的关系 是AND或OR 如果是第一个条件不受影响
 */
- (void)addWhere:(NSString *)whereString relation:(SQLTemplateRelation)relation;
- (SQLTemplate *(^)(NSString *whereString, SQLTemplateRelation relation))addWhere;

#pragma mark - add methods

/**
 添加或修改数据到SQL中

 @param field columnn名称
 @param value 对应值名
 */
- (void)addField:(NSString *)field value:(id)value;
- (SQLTemplate *(^)(NSString *field, id value))addFieldWithValue;

#pragma mark - select methods

/**
 确认select返回显示的列名 默认为*

 @param select 需要展示的列名
 */
- (void)setSelect:(NSArray<NSString *> *)select;
- (SQLTemplate *(^)(NSArray<NSString *> *select))setSelect;

/**
 添加order 默认生序

 @param order order语句
 */
- (void)addOrder:(NSString *)order;
- (SQLTemplate *(^)(NSString *order))addOrder;

/**
 添加order

 @param order 需要排序的列名
 @param sortType 排序规则
 */
- (void)addOrder:(NSString *)order sort:(SQLTemplateOrder)sortType;
- (SQLTemplate *(^)(NSString *order, SQLTemplateOrder sortType))addOrderWithSortType;

/**
 添加分组

 @param group 分组的列名
 */
- (void)addGroup:(NSString *)group;
- (SQLTemplate *(^)(NSString *group))addGroup;

/**
 设置分页

 @param limit 每页展示数量
 */
- (void)setLimit:(int)limit;
- (SQLTemplate *(^)(int limit))setLimit;

/**
 设置分页

 @param limit 每页展示数量
 @param offset 偏移量
 */
- (void)setLimit:(int)limit offset:(int)offset;
- (SQLTemplate *(^)(int limit, int offset))setLimitAndOffset;

#pragma mark - create table methods

/**
 是否添加 IF NOT EXISTS
 */

- (void)setIfNotExist;
- (SQLTemplate *(^)(void))addIfNotExist;

/**
 添加列

 @param title 列标题
 @param type 列的变量类型
 */
- (void)addColumn:(NSString *)title type:(NSString *)type;
- (SQLTemplate *(^)(NSString *title, NSString *type))addColumn;

/**
 添加列

 @param title 列标题
 @param type 列的变量类型
 @param option 列的属性
 */
- (void)addColumn:(NSString *)title type:(NSString *)type option:(NSString *)option;
- (SQLTemplate *(^)(NSString *title, NSString *type, NSString *option))addColumnWithOption;

@end

NS_ASSUME_NONNULL_END
