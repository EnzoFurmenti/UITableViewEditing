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


typedef enum{
    ViewContolletAddCellType = 0
}ViewControllerCellType;
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)NSArray *arrayGroups;
@property (weak,nonatomic)UITableView *tableView;
@end

@implementation ViewController

-(void)loadView{
    [super loadView];
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddSection:)];
    
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    self.navigationItem.leftBarButtonItem = addBarButton;
    self.navigationItem.rightBarButtonItem = editBarButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSMutableArray *mArrayGroups = [[NSMutableArray alloc]init];
//    
//    for (int i = 0; i <= arc4random() % 10; i++)
//    {
//        Group *group = [[Group alloc]initGroupWithNumberOfRandomStudents:arc4random() % 10 andTitleOfHeader:[NSString stringWithFormat:@"Группа-%d",i] andGroupColor:[self randomColor]];
//        [mArrayGroups addObject:group];
//    }
//    
//     [mArrayGroups sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        Group *group1 = (Group*)obj1;
//        Group *group2 = (Group*)obj2;
//        return [group1.titleOfHeader  localizedCompare:group2.titleOfHeader];
//    }];
//    NSArray *arrayGroups = [[NSArray alloc]initWithArray:mArrayGroups];
//    self.arrayGroups = arrayGroups;
    
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - Lazy initialization

-(NSArray *)arrayGroups{
    if(!_arrayGroups)
    {
        Group *group = [[Group alloc]initGroupWithNumberOfRandomStudents:2 andTitleOfHeader:@"Группа-1" andGroupColor:[self randomColor]];
        _arrayGroups = [[NSArray alloc]initWithObjects:group, nil];
    }
    return _arrayGroups;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.arrayGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    Group *currentGroup = [self.arrayGroups objectAtIndex:section];
    return [self getNumbersOfRow:[currentGroup.arrayStudents count]];
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
    if(indexPath.row == ViewContolletAddCellType)
    {
        static NSString *identifier = @"AddCellStudent";
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = @"add new student";
        
    }
    else
    {
        Group *currentGroup = [self.arrayGroups objectAtIndex:indexPath.section];
        Student *currentStudent = [currentGroup.arrayStudents objectAtIndex:[self getRow:indexPath.row]];

        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentStudent.lastName,currentStudent.firstName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f",currentStudent.averageMark];
        cell.backgroundColor = currentGroup.groupColor;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Group *sourceGroup = [self.arrayGroups objectAtIndex:sourceIndexPath.section];
    Student *student = [sourceGroup.arrayStudents objectAtIndex:[self getRow:sourceIndexPath.row]];
 //   if(destinationIndexPath.row != ViewContolletAddCellType)
  //  {
        NSMutableArray *mArrayStudents = [[NSMutableArray alloc]initWithArray:sourceGroup.arrayStudents];
        if(sourceIndexPath.section == destinationIndexPath.section)
        {
            [mArrayStudents exchangeObjectAtIndex:[self getRow:sourceIndexPath.row] withObjectAtIndex:[self getRow:destinationIndexPath.row]];
            sourceGroup.arrayStudents = mArrayStudents;
        }
        else
        {
            [mArrayStudents removeObject:student];
            sourceGroup.arrayStudents = [[NSArray alloc] initWithArray:mArrayStudents];
            
            Group *destinationGroup = [self.arrayGroups objectAtIndex:destinationIndexPath.section];
            NSMutableArray *mArrayDestinationStudents = [[NSMutableArray alloc] initWithArray:destinationGroup.arrayStudents];
            [mArrayDestinationStudents insertObject:student atIndex:[self getRow:destinationIndexPath.row]];
            destinationGroup.arrayStudents = [[NSArray alloc] initWithArray:mArrayDestinationStudents];
        }
  //  }
    [self.tableView reloadData];
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath.row == ViewContolletAddCellType ? NO : YES;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    NSIndexPath *totalIndexPath = nil;
    if(proposedDestinationIndexPath.row == ViewContolletAddCellType)
    {
        totalIndexPath = sourceIndexPath;
    }
    else
    {
        totalIndexPath = proposedDestinationIndexPath;
    }
    return totalIndexPath;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == ViewContolletAddCellType)
    {
        Group *group = [self.arrayGroups objectAtIndex:indexPath.section];
        NSMutableArray *mArrayStudents = nil;
        if(group.arrayStudents)
        {
            mArrayStudents = [[NSMutableArray alloc]initWithArray:group.arrayStudents];
        }
        else
        {
            mArrayStudents = [[NSMutableArray alloc]init];
        }
        NSInteger newStudentIndex = 0;
        [mArrayStudents insertObject:[Student randomStudent] atIndex:newStudentIndex];
        group.arrayStudents = [[NSArray alloc]initWithArray:mArrayStudents];
        [self.tableView beginUpdates];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newStudentIndex + 1 inSection:indexPath.section];
        NSArray *arrayIndexPath = [[NSArray alloc]initWithObjects:newIndexPath, nil];
        
        [self.tableView insertRowsAtIndexPaths:arrayIndexPath withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIApplication *app = [UIApplication sharedApplication];
            if([app isIgnoringInteractionEvents])
            {
                [app endIgnoringInteractionEvents];
            }
        });
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == ViewContolletAddCellType ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Group *group = [self.arrayGroups  objectAtIndex:indexPath.section];
        Student *student = [group.arrayStudents objectAtIndex:[self getRow:indexPath.row]];
        NSMutableArray *mArrayStudents = [[NSMutableArray alloc]initWithArray:group.arrayStudents];
        [mArrayStudents removeObject:student];
        group.arrayStudents = [[NSArray alloc]initWithArray:mArrayStudents];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section];
        NSArray *arrayIndexPath = [[NSArray alloc]initWithObjects:newIndexPath, nil];

        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:arrayIndexPath withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIApplication *app = [UIApplication sharedApplication];
            if([app isIgnoringInteractionEvents])
            {
                [app endIgnoringInteractionEvents];
            }
        });
        
    }
}


#pragma mark - action UIBarButtonItem

-(void)actionAddSection:(UIBarButtonItem*)barButton{
    
    NSString *titleOfHeader = [NSString stringWithFormat:@"Группа-%lu",[self.arrayGroups count] + 1];

    Group *group = [[Group alloc]initGroupWithNumberOfRandomStudents:0 andTitleOfHeader:titleOfHeader andGroupColor:[self randomColor]];
    NSInteger newSectionIndex = 0;
    NSMutableArray *mArrayGroups = [[NSMutableArray alloc]initWithArray:self.arrayGroups];
    [mArrayGroups insertObject:group atIndex:newSectionIndex];
    self.arrayGroups = mArrayGroups;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:newSectionIndex];
    [self.tableView beginUpdates];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIApplication *app = [UIApplication sharedApplication];
        if([app isIgnoringInteractionEvents])
        {
            [app endIgnoringInteractionEvents];
        }
    });
    
}

-(void)actionEdit:(UIBarButtonItem*)barButton{
    
    UIBarButtonSystemItem item = self.tableView.editing ? UIBarButtonSystemItemEdit : UIBarButtonSystemItemDone;

    [self.tableView setEditing:self.tableView.editing ? NO : YES animated:YES];

    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:item target:self action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:editBarButton animated:YES];
}


#pragma mark - metods
-(UIColor*)randomColor{
    return [[UIColor alloc]initWithRed:(float)(arc4random() % 256) /255.f green:(float)(arc4random() % 256) /255.f blue:(float)(arc4random() % 256) /255.f alpha:1.f];
}

-(NSInteger)getRow:(NSInteger)row{
    return row - 1;
}
    
-(NSInteger)getNumbersOfRow:(NSInteger)count{
    return count + 1;
}

    
@end
