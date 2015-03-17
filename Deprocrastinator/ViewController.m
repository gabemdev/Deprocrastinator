//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Rockstar. on 3/16/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ViewController.h"
#import "Task.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tastTextField;
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;
@property (nonatomic) NSMutableArray *taskArray;
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property NSIndexPath *deleted;
@property BOOL isCompleted;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskArray = [NSMutableArray arrayWithObjects:@"Finish Mobile Makers", @"Get level 2 certification", @"Create an awesome app", @"Change the world", nil];
    self.isCompleted = NO;
    self.title = @"Deprocastinator".uppercaseString;

    self.addTaskButton.layer.cornerRadius = 3;
    // Do any additional setup after loading the view, typically from a nib.

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.taskArray objectAtIndex:indexPath.row];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [cell addGestureRecognizer:swipe];

    return cell;
}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.deleted = indexPath;

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution?" message:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        [alert show];
        
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *taskTitle = [self.taskArray objectAtIndex:sourceIndexPath.row];
    [self.taskArray removeObject:taskTitle];
    [self.taskArray insertObject:taskTitle atIndex:destinationIndexPath.row];

    [self.taskTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.isCompleted == NO) {
        cell.accessoryType = UITableViewCellAccessoryNone;

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor greenColor];
        self.isCompleted = YES;
    }
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.isCompleted = NO;
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    [view setBackgroundColor:[UIColor colorWithRed:0.23 green:0.47 blue:0.85 alpha:1.00]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}

#pragma mark - Actions
- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender {
    if (self.editing) {
        self.editing = NO;
        [self.taskTableView setEditing:NO animated:NO];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
    } else {
        self.editing = YES;
        [self.taskTableView setEditing:YES animated:YES];
        sender.title = @"Done";
        sender.style = UIBarButtonItemStylePlain;
    }
    [self.taskTableView reloadData];
}

- (IBAction)onAddButtonTapped:(id)sender {
    if ([self.tastTextField.text isEqualToString:@""]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No text" message:@"Please add task" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    } else {
        Task *task = [Task new];
        task.taskName = self.tastTextField.text;


        NSString *newTask = self.tastTextField.text;
        [self.taskArray addObject:newTask];

            }
    [self.tastTextField resignFirstResponder];
    self.tastTextField.text = @"";
    [self.taskTableView reloadData];
}


- (void)swipeHandler:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        CGPoint location = [sender locationInView:self.taskTableView];
        NSIndexPath *swipeIndexPath = [self.taskTableView indexPathForRowAtPoint:location];
        UITableViewCell *cell = [self.taskTableView cellForRowAtIndexPath:swipeIndexPath];

        if (cell.textLabel.textColor == [UIColor blackColor]) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        else if (cell.textLabel.textColor == [UIColor redColor]) {
            cell.textLabel.textColor = [UIColor yellowColor];
        }
        else if (cell.textLabel.textColor == [UIColor yellowColor]) {
            cell.textLabel.textColor = [UIColor greenColor];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.isCompleted = YES;
        }
        else if (cell.textLabel.textColor == [UIColor greenColor]) {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.isCompleted = NO;
        }
        [self.taskTableView reloadData];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self canDelete];
    }
}

- (void)canDelete{
    [self.taskArray removeObjectAtIndex:self.deleted.row];
    [self.taskTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.deleted] withRowAnimation:UITableViewRowAnimationLeft];
    [self.taskTableView reloadData];
}



@end
