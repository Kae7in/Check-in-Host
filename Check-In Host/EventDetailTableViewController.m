//
//  EventDetailTableViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/21/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventDetailTableViewController.h"
#import <Parse/Parse.h>
#import "MapViewController.h"

@interface EventDetailTableViewController () <UITextFieldDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *eventTitleCell;
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDateField;
@end

@implementation EventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.editButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];

    if ([self.event.title isEqualToString:@""]) {
        self.editButtonItem.title = @"Add";
    } else {
        self.editButtonItem.title = @"Edit";
        self.eventTitleTextField.enabled = false;
        self.eventDateField.enabled = false;
        [self setCellsWithInfoFromMarker];
    }
    self.editButtonItem.enabled = true;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupEventTitleField];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    NSInteger currentVCIndex = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
    MapViewController *parent = (MapViewController *)[self.navigationController.viewControllers objectAtIndex:currentVCIndex];
    parent.recentlyCreatedEvent = self.event;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setCellsWithInfoFromMarker {
    [self.eventTitleTextField setText:self.event.marker.title];
    [self.eventDateField setDate:self.event.date animated:true];
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
//    [super setEditing:editing animated:animated];
    
    if ([self.editButtonItem.title isEqualToString:@"Add"]) {
        // This is a new event - commit it to Parse db.
        [self commitEvent];
    } else {
        // This is an existing event --> Toggle editing
        if([self.editButtonItem.title isEqualToString:@"Done"]) {
            // Disable editing
            self.editButtonItem.title = @"Edit";
            self.eventTitleTextField.enabled = false;
            self.eventDateField.enabled = false;
#warning: Allow for an update to the existing object after editing.
//            [self.event update];
        } else {
            // Enable editing
            self.editButtonItem.title = @"Done";
            self.eventTitleTextField.enabled = true;
            self.eventDateField.enabled = true;
        }
    }
    
}


- (void)commitEvent {
    NSString *title = self.eventTitleTextField.text;
    if ([title isEqualToString:@""]) {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                    initWithTitle:@"Event Title Required"
                          message:@"Give your event a title"
                         delegate:nil
                cancelButtonTitle:@"OK"
                otherButtonTitles:nil];
    
        // Display Alert Message
        [messageAlert show];
    } else {
        // Submit event to Parse db
        NSDate *date = self.eventDateField.date;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.event.location.coordinate.latitude
                                                              longitude:self.event.location.coordinate.longitude];
    
        // Update marker properties in map view
        [self.event setTitle:title location:location date:date attendees:nil marker:self.event.marker];
        self.event.marker.title = self.eventTitleTextField.text;
        
        // Commit the event Parse db
        [self.event commit];
        
        // Unwind back to map view
        [self performSegueWithIdentifier:@"unwindToMap" sender:self];
    }
}


- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"unwindToMap"]) {
        MapViewController *mvc = (MapViewController *)segue.sourceViewController;
        mvc.recentlyCreatedEvent = self.event;
    }
}


- (void)setupEventTitleField {
    self.eventTitleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.eventTitleTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.eventTitleTextField.adjustsFontSizeToFitWidth = YES;
    self.eventTitleTextField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
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
