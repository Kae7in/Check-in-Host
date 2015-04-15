//
//  EventViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/15/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventViewController.h"
#import <Parse/Parse.h>

@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *title = [currentUser[@"CHUserID"] stringByAppendingString:@"'s Events"];
    [[self navigationItem] setTitle:title];
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
