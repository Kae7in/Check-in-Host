//
//  EventDetailTableViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/21/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventDetailTableViewController.h"
#import <Parse/Parse.h>
#import "Event.h"

@interface EventDetailTableViewController () <UITextFieldDelegate, UITableViewDelegate>
@property (strong, nonatomic) Event *event;
@property (weak, nonatomic) IBOutlet UITableViewCell *eventTitleCell;
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDateField;
@property (weak, nonatomic) IBOutlet UITableViewCell *eventCreateButtonCell;
@end

@implementation EventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEventTitleField];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupEventTitleField {
    self.eventTitleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.eventTitleTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.eventTitleTextField.adjustsFontSizeToFitWidth = YES;
    self.eventTitleTextField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
}


/* Responds to Create Event Button */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == self.eventCreateButtonCell) {
        // Display error message to user noting that event creation requires a title
        NSString *title = self.eventTitleTextField.text;
        if ([title isEqualToString:@""]) {
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Event Title Required" message:@"Give your event a title" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            // Display Alert Message
            [messageAlert show];
        } else {
            // Submit event to Parse db
            NSDate *date = self.eventDateField.date;
            CLLocation *location = [[CLLocation alloc] initWithLatitude:self.marker.position.latitude
                                                              longitude:self.marker.position.longitude];
            
            self.event = [[Event alloc] initEventWithTitle:title location:location date:date attendees:nil];
            self.marker.title = self.eventTitleTextField.text;
            [self.event commit];
            [self.navigationController popViewControllerAnimated:true];
        }
        self.eventCreateButtonCell.selected = false;
    }
}


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
