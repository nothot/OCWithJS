//
//  ViewController.m
//  OCWithJS
//
//  Created by mengminduan on 2017/11/30.
//  Copyright © 2017年 mengminduan. All rights reserved.
//

#import "ViewController.h"
#import "UIView+DUACategory.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *viewcontrollers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.viewcontrollers = @[@"FirstViewController", @"SecondViewController", @"ThirdViewController", @"fourthViewController"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.dua_x, self.view.dua_y, self.view.dua_width, self.view.dua_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test.cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test.cell"];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 60)];
    label.text = self.viewcontrollers[indexPath.row % 4];
    label.textColor = [UIColor blackColor];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcString = self.viewcontrollers[indexPath.row % 4];
    UIViewController *vc = [[NSClassFromString(vcString) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
