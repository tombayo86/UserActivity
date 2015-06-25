//
//  UserActivitiesTableViewDataSource.m
//  UserActivity
//
//  Created by el mariachi on 25/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import "UATypesTableViewDataSource.h"

@interface UATypesTableViewDataSource()

@property (strong, nonatomic) NSString *cellIdentifier;
@property (nonatomic, copy) void (^cellConfigurationBlock)(ActivityViewCell *, NSInteger index);

@end

@implementation UATypesTableViewDataSource

-(instancetype)initWithItems: (NSArray *)items cellIdentifier: (NSString *) cellIdentifier configureCellBlock: (void (^)(ActivityViewCell *, NSInteger index))cellConfigureBlock
{
    self = [self init];
    if(self) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.cellConfigurationBlock = cellConfigureBlock;
    }
    
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityViewCell *cell = (ActivityViewCell *)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    //Setting up the cell (title, background ,selectiontype, alpha)
    NSString *activityTitle = self.items[indexPath.row];
    cell.textLabel.text = activityTitle;
    
    self.cellConfigurationBlock(cell, indexPath.row);
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

@end
