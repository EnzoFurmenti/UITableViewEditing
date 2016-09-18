//
//  ViewController.m
//  UITableViewEditing
//
//  Created by EnzoF on 17.09.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import "ViewController.h"
#import "Group.h"
#import "Student.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)NSArray *arrayGroups;
@property (weak,nonatomic)UITableView *tableView;
@end

@implementation ViewController

-(void)loadView{
    [super loadView];
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
//                                 UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *mArrayGroups = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= arc4random() % 10; i++)
    {
        Group *group = [[Group alloc]initGroupWithNumberOfRandomStudents:arc4random() % 10 andTitleOfHeader:[NSString stringWithFormat:@"Группа-%d",i] andGroupColor:[self randomColor]];
        [mArrayGroups addObject:group];
    }
    
     [mArrayGroups sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Group *group1 = (Group*)obj1;
        Group *group2 = (Group*)obj2;
        return [group1.titleOfHeader  localizedCompare:group2.titleOfHeader];
    }];
    NSArray *arrayGroups = [[NSArray alloc]initWithArray:mArrayGroups];
    self.arrayGroups = arrayGroups;
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Group *currentGroup = [self.arrayGroups objectAtIndex:section];
    return [currentGroup.arrayStudents count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.arrayGroups count];
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Group *currentGroup = [self.arrayGroups objectAtIndex:section];
    return currentGroup.titleOfHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"CellStudent";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    Group *currentGroup = [self.arrayGroups objectAtIndex:indexPath.section];
    Student *currentStudent = [currentGroup.arrayStudents objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentStudent.lastName,currentStudent.firstName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f",currentStudent.averageMark];
    cell.backgroundColor = currentGroup.groupColor;
    return cell;
}




#pragma mark - metods
-(UIColor*)randomColor{
    return [[UIColor alloc]initWithRed:(float)(arc4random() % 256) /255.f green:(float)(arc4random() % 256) /255.f blue:(float)(arc4random() % 256) /255.f alpha:1.f];
}
@end
