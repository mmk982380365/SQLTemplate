//
//  AppDelegate.m
//  SQLTemplateDemo
//
//  Created by Yuuki on 2018/9/27.
//  Copyright © 2018 Yuuki. All rights reserved.
//

#import "AppDelegate.h"
#import "SQLTemplate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //查询
    SQLTemplate *select = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeSelect];
    [select setSelect:@[@"column1",@"column2"]];
    [select addWhere:@"column1='value1'" relation:SQLTemplateRelationAnd];
    [select addWhere:@"column2='value2'" relation:SQLTemplateRelationOr];
    [select addOrder:@"column3"];
    [select addOrder:@"column4" sort:SQLTemplateOrderDesc];
    [select addGroup:@"column5"];
    [select addGroup:@"column6"];
    [select setLimit:10 offset:20];
    NSLog(@"%@",select.SQL);
    
    SQLTemplate *selectF = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeSelect];
    selectF.setSelect(@[@"column1",@"column2"])
    .addWhere(@"column1='value1'", SQLTemplateRelationAnd)
    .addWhere(@"column2='value2'", SQLTemplateRelationAnd)
    .addOrder(@"column3")
    .addOrderWithSortType(@"column4", SQLTemplateOrderDesc)
    .addGroup(@"column5")
    .setLimitAndOffset(10, 20);
    NSLog(@"%@", selectF.SQL);
    
    //插入
    SQLTemplate *add = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeAdd];
    [add addField:@"column1" value:@"value1"];
    [add addField:@"column2" value:@"value2"];
    [add addField:@"column3" value:@"value3"];
    NSLog(@"%@",add.SQL);
    
    SQLTemplate *addF = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeAdd];
    addF.addFieldWithValue(@"column1", @"value1")
    .addFieldWithValue(@"column2", @"value2")
    .addFieldWithValue(@"column3", @"value3");
    NSLog(@"%@",addF.SQL);
    
    //删除
    SQLTemplate *del = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeDelete];
    [del addWhere:@"column1='value1'" relation:SQLTemplateRelationAnd];
    NSLog(@"%@",del.SQL);
    
    SQLTemplate *delF = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeDelete];
    delF.addWhere(@"column1='value1'", SQLTemplateRelationAnd);
    NSLog(@"%@",delF.SQL);
    
    //修改
    SQLTemplate *update = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeUpdate];
    [update addField:@"column1" value:@"value1"];
    [update addField:@"column2" value:@"value2"];
    [update addField:@"column3" value:@"value3"];
    [update addWhere:@"column4='value4'" relation:SQLTemplateRelationAnd];
    [update addWhere:@"column5='value5'" relation:SQLTemplateRelationAnd];
    NSLog(@"%@",update.SQL);
    
    SQLTemplate *updateF = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeUpdate];
    updateF.addFieldWithValue(@"column1", @"value1")
    .addFieldWithValue(@"column2", @"value2")
    .addFieldWithValue(@"column3", @"value3")
    .addWhere(@"column4='value4'", SQLTemplateRelationAnd)
    .addWhere(@"column5='value5'", SQLTemplateRelationAnd);
    NSLog(@"%@",updateF.SQL);
    
    //创建表格
    SQLTemplate *createTable = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeCreateTable];
    [createTable setIfNotExist];
    [createTable addColumn:@"column1" type:@"integer" option:@"PRIMARY"];
    [createTable addColumn:@"column2" type:@"varchar(256)"];
    NSLog(@"%@",createTable.SQL);
    
    SQLTemplate *createTableF = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeCreateTable];
    createTableF.addIfNotExist()
    .addColumnWithOption(@"column1", @"integer", @"PRIMARY")
    .addColumn(@"column2", @"varchar(256)");
    NSLog(@"%@",createTableF.SQL);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
