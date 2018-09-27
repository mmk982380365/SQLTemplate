# SQLTemplate

一个便捷的生成SQL语句的帮助类，适用于SQLITE，并未测试其他数据库。

最终生成的SQL语句为`finalSqlString`


# Usage

### 查询语句

```
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
```

### 插入语句

```
    SQLTemplate *add = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeAdd];
    [add addField:@"column1" value:@"value1"];
    [add addField:@"column2" value:@"value2"];
    [add addField:@"column3" value:@"value3"];
    NSLog(@"%@",add.finalSqlString);
```

### 删除语句

```
    SQLTemplate *del = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeDelete];
    [del addWhere:@"column1='value1'" relation:SQLTemplateRelationAnd];
    NSLog(@"%@",del.finalSqlString);
```

### 修改语句

```
    SQLTemplate *update = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeUpdate];
    [update addField:@"column1" value:@"value1"];
    [update addField:@"column2" value:@"value2"];
    [update addField:@"column3" value:@"value3"];
    [update addWhere:@"column4='value4'" relation:SQLTemplateRelationAnd];
    [update addWhere:@"column5='value5'" relation:SQLTemplateRelationAnd];
    NSLog(@"%@",update.finalSqlString);
```

### 创建表格语句

```
    SQLTemplate *createTable = [[SQLTemplate alloc] initWithTableName:@"table" withMode:SQLTemplateModeCreateTable];
    createTable.addIfNotExists = YES;
    [createTable addColumn:@"column1" type:@"integer" option:@"PRIMARY"];
    [createTable addColumn:@"column2" type:@"varchar(256)"];
    NSLog(@"%@",createTable.finalSqlString);
```
