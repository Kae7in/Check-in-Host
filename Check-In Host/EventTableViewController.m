//
//  EventTableViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/15/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventTableViewController.h"
#import "EventDetailTableViewController.h"
#import <Parse/Parse.h>
#import "EventRepo.h"
#import "Event.h"
#import "XLFormDescriptor.h"
#import "XLFormSectionDescriptor.h"
#import "XLFormRowDescriptor.h"
#import "XLForm.h"

@interface EventTableViewController ()
@property (strong, nonatomic) EventRepo *eventRepo;
@property (strong, nonatomic) NSMutableArray *hostedEvents;
@property (strong, nonatomic) Event *eventToSegueWith;
@end

@implementation EventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHostedEvents];
    // Do any additional setup after loading the view.

    PFUser *currentUser = [PFUser currentUser];
    NSString *title = [currentUser[@"CHUserID"] stringByAppendingString:@"'s Events"];
    [[self navigationItem] setTitle:title];
}


- (void)loadHostedEvents {
    self.eventRepo = [[EventRepo alloc] init];
    [self.eventRepo loadCurrentUserEventsWithCompletionHandler:^{
        self.hostedEvents = [self.eventRepo currentUserEvents];
        NSLog(@"Loaded hosted events");
        [self initializeForm];
    }];
}


- (void)initializeForm {
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Add Event"];
//    self.eventFormDescriptor = form;
    
    /* New Section */
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Hosted Events"];
    [form addFormSection:section];
    
    // Hosted Events
    for (Event *event in self.hostedEvents) {
        NSLog(@"event: %@", event);
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Event" rowType:XLFormRowDescriptorTypeButton title:event.title];
        row.action.formSegueIdenfifier = @"toEventDetail";
        [row.valueData setValue:event forUndefinedKey:@"event"];
        NSLog(@"BEFORE event: %@", [row.valueData objectForKey:@"event"]);
        row.required = YES;
        [section addFormRow:row];
    }
    
    // New Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Events Invited To"];
    [form addFormSection:section];
    
    self.form = form;
    [self.tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    XLFormRowDescriptor *button = (XLFormRowDescriptor *)sender;
    NSLog(@"event: %@", [button.value objectForKey:@"event"]);
    if ([segue.identifier isEqualToString:@"toEventDetail"]) {
        EventDetailTableViewController *dest = (EventDetailTableViewController *)segue.destinationViewController;
        dest.event = [button.value objectForKey:@"event"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
