//
//  XLAllViewController.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/25.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "XLAllViewController.h"

@interface XLAllViewController ()

@end

@implementation XLAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor blueColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@----%zd", [self class], indexPath.row];
    
    return cell;

}
@end
