//
//  EventDetailViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/16/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventRepo.h"

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) EventRepo *eventRepo;
@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventRepo = [[EventRepo alloc] init];
    // Do any additional setup after loading the view.
    [self.eventTitle setText:self.marker.title];
    
    [self.eventRepo createEventWithTitle:@"My Event" location:nil date:nil attendees:nil];
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
