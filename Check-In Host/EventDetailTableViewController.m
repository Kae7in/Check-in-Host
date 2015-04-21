//
//  EventDetailTableViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/21/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventDetailTableViewController.h"
#import "Event.h"

@interface EventDetailTableViewController () <UITextFieldDelegate>
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) UITextField *eventTitleField;
@property (strong, nonatomic) UIDatePicker *eventDatePicker;
@end

@implementation EventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITextField*) makeEventTitleField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
    self.eventTitleField = [[UITextField alloc] init];
    self.eventTitleField.placeholder = placeholder ;
    self.eventTitleField.text = text;
    self.eventTitleField.autocorrectionType = UITextAutocorrectionTypeNo ;
    self.eventTitleField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.eventTitleField.adjustsFontSizeToFitWidth = YES;
    self.eventTitleField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];

    return self.eventTitleField;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self constructEventTitleTableViewCell:cell];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return [self constructEventDateTableViewCell:cell];
        }
    }
    
    return cell;
}


/* Get a UITableViewCell for the Event Title UITextField entry */
- (UITableViewCell *)constructEventTitleTableViewCell:(UITableViewCell *)cell {
    
    // Configure the cell...
    cell.textLabel.text = @"Event Title" ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Create UITextField
    self.eventTitleField = [self makeEventTitleField:@"" placeholder:@"Scott Hickle's Rocket Launch"];
    
    // Set UITextfield frame
    CGFloat optionalRightMargin = 10.0;
    CGFloat optionalBottomMargin = 10.0;
    self.eventTitleField.frame = CGRectMake(110, 10, cell.contentView.frame.size.width - 110 - optionalRightMargin, cell.contentView.frame.size.height - 10 - optionalBottomMargin);
    self.eventTitleField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Add UITextField to cell
    [cell addSubview:self.eventTitleField];
    
    return cell;
}


- (UITableViewCell *)constructEventDateTableViewCell:(UITableViewCell *)cell {
    
    // Set UIDatePicker frame
    self.eventDatePicker = [[UIDatePicker alloc] init];
    self.eventDatePicker.frame = CGRectMake(0, 0, self.view.bounds.size.width, 100);
//    cell.contentView.frame = self.eventDatePicker.frame;
    cell.frame = self.eventDatePicker.frame;
    
    // Add UIDatePicker to cell
    [cell addSubview:self.eventDatePicker];
    
    return cell;
}


//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField == self.eventTitleField) {
//        self.createEventButton.enabled = true;
//    }
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
