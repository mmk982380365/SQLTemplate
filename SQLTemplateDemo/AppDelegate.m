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
    NSLog(@"%@",select.finalSqlString);
    
    //插入
    SQLTemplate *add = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeAdd];
    [add addField:@"column1" value:@"value1"];
    [add addField:@"column2" value:@"value2"];
    [add addField:@"column3" value:@"value3"];
    NSLog(@"%@",add.finalSqlString);
    
    //删除
    SQLTemplate *del = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeDelete];
    [del addWhere:@"column1='value1'" relation:SQLTemplateRelationAnd];
    NSLog(@"%@",del.finalSqlString);
    
    //修改
    SQLTemplate *update = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeUpdate];
    [update addField:@"column1" value:@"value1"];
    [update addField:@"column2" value:@"value2"];
    [update addField:@"column3" value:@"value3"];
    [update addWhere:@"column4='value4'" relation:SQLTemplateRelationAnd];
    [update addWhere:@"column5='value5'" relation:SQLTemplateRelationAnd];
    NSLog(@"%@",update.finalSqlString);
    
    //创建表格
    SQLTemplate *createTable = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeCreateTable];
    [createTable addColumn:@"column1" type:@"integer" option:@"PRIMARY"];
    [createTable addColumn:@"column2" type:@"varchar(256)"];
    NSLog(@"%@",createTable.finalSqlString);
    
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
