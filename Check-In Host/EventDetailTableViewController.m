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
#import "XLFormDescriptor.h"
#import "XLFormSectionDescriptor.h"
#import "XLFormRowDescriptor.h"
//#import "DateAndTimeValueTrasform.h"
//#import "NativeEventFormViewController.h"
#import "XLForm.h"

@interface EventDetailTableViewController () <UITextFieldDelegate, UITableViewDelegate>
@property (nonatomic) XLFormRowDescriptor *eventTitleRowDescriptor;
//@property (nonatomic) XLFormRowDescriptor *eventAllDayRowDescriptor;
@property (nonatomic) XLFormRowDescriptor *eventStartDateRowDescriptor;
@property (nonatomic) XLFormRowDescriptor *eventEndDateRowDescriptor;
@property (nonatomic) BOOL edited;
@end

@implementation EventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeForm];
    [self.editButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];

    if ([self.event.title isEqualToString:@""]) {
        self.editButtonItem.title = @"Add";
    } else {
        self.editButtonItem.title = @"Edit";
        [self setCellsWithInfoFromMarker];
    }
    
    self.editButtonItem.enabled = true;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)initializeForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Add Event"];
    
    /* New Section */
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Title
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Title" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
    row.required = YES;
    self.eventTitleRowDescriptor = row;
    [section addFormRow:row];
    
    // Location
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"location" rowType:XLFormRowDescriptorTypeText];
//    [row.cellConfigAtConfigure setObject:@"Location" forKey:@"textField.placeholder"];
    
//    [section addFormRow:row];
    
    /* New Section */
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // All-day
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"all-day" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"All-day"];
//    self.eventAllDayRowDescriptor = row;
//    [section addFormRow:row];
    
    // Starts
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"starts" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Starts"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    self.eventStartDateRowDescriptor = row;
    [section addFormRow:row];
    
    // Ends
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ends" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Ends"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*25];
    self.eventEndDateRowDescriptor = row;
    [section addFormRow:row];
    
    self.form = form;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setCellsWithInfoFromMarker {
    self.eventTitleRowDescriptor.value = self.event.marker.title;
//    [self.eventDateField setDate:self.event.date animated:true];
//    [self reloadFormRow:self.eventTitleRowDescriptor];
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
#warning: Allow for an update to the existing object after editing.
//            [self.event update];
        } else {
            // Enable editing
            self.editButtonItem.title = @"Done";
            self.edited = true;
        }
    }
    
}


- (void)commitEvent {
    NSString *title = self.eventTitleRowDescriptor.value;
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
        NSDate *startDate = self.eventStartDateRowDescriptor.value;
        NSDate *endDate = self.eventEndDateRowDescriptor.value;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.event.location.coordinate.latitude
                                                              longitude:self.event.location.coordinate.longitude];
    
        // Update marker properties in map view
        [self.event setTitle:title location:location startDate:startDate endDate:endDate attendees:nil invitees:nil marker:self.event.marker];
        self.event.marker.title = self.eventTitleRowDescriptor.value;
        
        // Commit the event Parse db
        self.event.currentUserIsHost = true;
        [self.event commit];
        
        // Unwind back to map view
        [self performSegueWithIdentifier:@"unwindToMapFromCreate" sender:self];
    }
}


- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"ahh");
    MapViewController *mvc = (MapViewController *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"unwindToMapFromCreate"]) {
        NSLog(@"unwindToMapFromCreate");
        mvc.createdEvent = self.event;
    } else if ([segue.identifier isEqualToString:@"unwindToMapFromEdit"]) {
        if (self.edited) {
            mvc.editedEvent = self.event;
        } else {
            mvc.editedEvent = NULL;
        }
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
