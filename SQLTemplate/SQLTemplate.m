//
//  SQLTemplate.m
//  sqltest
//
//  Created by Yuuki on 2018/9/27.
//  Copyright © 2018 Yuuki. All rights reserved.
//

#import "SQLTemplate.h"

@interface SQLTemplate ()

@property (assign, nonatomic, readwrite) SQLTemplateMode mode;

@property (copy, nonatomic, readwrite) NSString *tableName;

@property (copy, nonatomic, readwrite) NSString *finalSqlString;

@property (strong, nonatomic) NSMutableArray *addFields;

@property (strong, nonatomic) NSMutableArray *whereFields;

@property (strong, nonatomic) NSArray<NSString *> *selectFields;

@property (strong, nonatomic) NSMutableArray *orderFields;

@property (strong, nonatomic) NSMutableArray *groupFields;

@property (strong, nonatomic) NSMutableArray *columnFields;

@property (assign, nonatomic) int alimit;

@property (assign, nonatomic) int aoffset;

@end

@implementation SQLTemplate

- (instancetype)initWithTableName:(NSString *)tableName withMode:(SQLTemplateMode)mode
{
    self = [super init];
    if (self) {
        self.mode = mode;
        self.tableName = tableName;
    }
    return self;
}

+ (instancetype)templateWithTableName:(NSString *)tableName withMode:(SQLTemplateMode)mode {
    return [[self alloc] initWithTableName:tableName withMode:mode];
}

- (void)addWhere:(NSString *)whereString relation:(SQLTemplateRelation)relation {
    if (self.mode == SQLTemplateModeAdd || whereString.length == 0) {
        return;
    }
    NSDictionary *info = @{
                           @"relation": @(relation),
                           @"field": whereString,
                           };
    [self.whereFields addObject:info];
}

- (void)addField:(NSString *)field value:(id)value {
    if ((self.mode != SQLTemplateModeAdd && self.mode != SQLTemplateModeUpdate) || !value || field.length == 0) {
        return;
    }
    NSDictionary *info = @{
                            @"value": value,
                            @"field": field,
                            };
    [self.addFields addObject:info];
}

- (void)setSelect:(NSArray<NSString *> *)select {
    self.selectFields = select;
}

- (void)addOrder:(NSString *)order sort:(SQLTemplateOrder)sortType {
    if (self.mode != SQLTemplateModeSelect || order.length == 0) {
        return;
    }
    NSDictionary *info = @{
                           @"sort": @(sortType),
                           @"field": order,
                           };
    [self.orderFields addObject:info];
}

- (void)addOrder:(NSString *)order {
    [self addOrder:order sort:SQLTemplateOrderAsc];
}

- (void)addGroup:(NSString *)group {
    if (group.length == 0) {
        return;
    }
    [self.groupFields addObject:group];
}

- (void)setLimit:(int)limit {
    [self setLimit:limit offset:0];
}

- (void)setLimit:(int)limit offset:(int)offset {
    if (limit < 0) {
        limit = 0;
    }
    if (offset < 0) {
        offset = 0;
    }
    self.alimit = limit;
    self.aoffset = offset;
}

- (void)addColumn:(NSString *)title type:(NSString *)type {
    [self addColumn:title type:type option:@""];
}

- (void)addColumn:(NSString *)title type:(NSString *)type option:(NSString *)option {
    if (self.mode != SQLTemplateModeCreateTable || title.length == 0 || type.length == 0) {
        return;
    }
    NSString *field = nil;
    if (option.length > 0) {
        field = [NSString stringWithFormat:@"%@ %@ %@", title, type, option];
    } else {
        field = [NSString stringWithFormat:@"%@ %@", title, type];
    }
    [self.columnFields addObject:field];
}

#pragma mark - getter

- (NSString *)whereString {
    if (self.whereFields.count == 0) {
        return @"";
    }
    NSMutableString *whereString = [NSMutableString stringWithFormat:@" WHERE "];
    for (int i = 0; i < self.whereFields.count; i++) {
        NSDictionary *info = self.whereFields[i];
        NSString *whereField = info[@"field"];
        if (i == 0) {
            [whereString appendFormat:@"%@",whereField];
            continue;
        }
        SQLTemplateRelation relation = [info[@"relation"] integerValue];
        [whereString appendFormat:@" %@ %@", relation == SQLTemplateRelationOr ? @"OR" : @"AND", whereField];
    }
    return whereString;
}

- (NSString *)groupString {
    if (self.groupFields.count == 0) {
        return @"";
    }
    
    return [@" GROUP BY " stringByAppendingString:[self.groupFields componentsJoinedByString:@", "]];
}

- (NSString *)orderString {
    if (self.orderFields.count == 0) {
        return @"";
    }
    
    NSMutableString *orderString = [NSMutableString stringWithFormat:@" ORDER BY"];
    
    for (NSDictionary *info in self.orderFields) {
        NSString *field = info[@"field"];
        SQLTemplateOrder order = [info[@"sort"] integerValue];
        [orderString appendFormat:@" %@ %@,", field ,order == SQLTemplateOrderAsc ? @"ASC" : @"DESC"];
    }
    [orderString deleteCharactersInRange:NSMakeRange(orderString.length - 1, 1)];
    return orderString;
}

- (NSString *)finalSqlString {
    if (!_finalSqlString) {
        switch (self.mode) {
            case SQLTemplateModeAdd:
            {
                if (self.addFields.count == 0) {
                    return nil;
                }
                NSMutableString *fieldNamesString = [NSMutableString string];
                NSMutableString *valuesString = [NSMutableString string];
                for (NSDictionary *info in self.addFields) {
                    NSString *key = info[@"field"];
                    id value = info[@"value"];
                    [fieldNamesString appendFormat:@"%@, ",key];
                    [valuesString appendFormat:@"'%@', ",value];
                }
                
                [fieldNamesString deleteCharactersInRange:NSMakeRange(fieldNamesString.length - 2, 2)];
                [valuesString deleteCharactersInRange:NSMakeRange(valuesString.length - 2, 2)];
                
                _finalSqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);",self.tableName, fieldNamesString, valuesString];
                
            }
                break;
            case SQLTemplateModeDelete:
            {
                
                NSString *whereString = [self whereString];
                _finalSqlString = [NSString stringWithFormat:@"DELETE FROM %@%@;", self.tableName, whereString];
                
            }
                break;
            case SQLTemplateModeUpdate:
            {
                if (self.addFields.count == 0) {
                    return nil;
                }
                
                NSMutableString *setString = [NSMutableString string];
                
                for (NSDictionary *info in self.addFields) {
                    NSString *key = info[@"field"];
                    id value = info[@"value"];
                    if ([value isKindOfClass:[NSNumber class]]) {
                        [setString appendFormat:@"%@ = %@, ", key, value];
                    } else {
                        [setString appendFormat:@"%@ = '%@', ", key, value];
                    }
                }
                [setString deleteCharactersInRange:NSMakeRange(setString.length - 2, 2)];
                
                NSString *whereString = [self whereString];
                _finalSqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@%@;", self.tableName, setString, whereString];
                
                
            }
                break;
            case SQLTemplateModeSelect:
            {
                NSString *selectString = self.selectFields.count > 0 ? [self.selectFields componentsJoinedByString:@", "] : @"*";
                
                NSString *whereString = [self whereString];
                
                NSString *groupString = [self groupString];
                
                NSString *orderString = [self orderString];
                
                _finalSqlString = [NSString stringWithFormat:@"SELECT %@ FROM %@%@%@%@", selectString, self.tableName, whereString, groupString, orderString];
                
                if (self.alimit > 0) {
                    _finalSqlString = [_finalSqlString stringByAppendingFormat:@" LIMIT %d",self.alimit];
                    if (self.aoffset > 0) {
                        _finalSqlString = [_finalSqlString stringByAppendingFormat:@" OFFSET %d",self.aoffset];
                    }
                }
                _finalSqlString = [_finalSqlString stringByAppendingFormat:@";"];
            }
                break;
            case SQLTemplateModeCreateTable:
            {
                if (self.columnFields.count == 0) {
                    return nil;
                }
                
                NSMutableString *columnString = [NSMutableString string];
                
                for (NSString *field in self.columnFields) {
                    [columnString appendFormat:@"%@, ",field];
                }
                [columnString deleteCharactersInRange:NSMakeRange(columnString.length - 2, 2)];
                
                if (self.addIfNotExists) {
                    _finalSqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);", self.tableName, columnString];
                } else {
                    _finalSqlString = [NSString stringWithFormat:@"CREATE TABLE %@ (%@);", self.tableName, columnString];
                }
                
                
            }
                break;
        }
    }
    return _finalSqlString;
}

- (NSMutableArray *)addFields {
    if (!_addFields) {
        _addFields = [NSMutableArray arrayWithCapacity:0];
    }
    return _addFields;
}

- (NSMutableArray *)whereFields {
    if (!_whereFields) {
        _whereFields = [NSMutableArray arrayWithCapacity:0];
    }
    return _whereFields;
}

- (NSMutableArray *)orderFields {
    if (!_orderFields) {
        _orderFields = [NSMutableArray arrayWithCapacity:0];
    }
    return _orderFields;
}

- (NSMutableArray *)groupFields {
    if (!_groupFields) {
        _groupFields = [NSMutableArray arrayWithCapacity:0];
    }
    return _groupFields;
}

- (NSMutableArray *)columnFields {
    if (!_columnFields) {
        _columnFields = [NSMutableArray arrayWithCapacity:0];
    }
    return _columnFields;
}

@end
