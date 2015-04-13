//
//  UserViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/12/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "UserViewController.h"
#import "AuthViewController.h"
#import <PFFacebookUtils.h>

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutButtonAction:(UIButton *)sender {
    [PFUser logOut];
    NSLog(@"Logged Out");
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
