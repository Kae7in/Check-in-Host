//
//  RegistrationViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/12/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AuthViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <PFFacebookUtils.h>

@interface RegistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@end


@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitButtonAction:(UIButton *)sender {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        // Create user with given username
        PFUser *user = [PFUser currentUser];
#warning check if username is already in DB
        user[@"CHUserID"] = self.usernameTextField.text;
        [user save];
        
        // Create userMetadata entry for this user
        PFObject *userMetadata = [PFObject objectWithClassName:@"userMetadata"];
        [userMetadata save];
        
        [user setObject:userMetadata forKey:@"userMetadata"];
        [user save];
    });
    
    [self performSegueWithIdentifier:@"segueToTabBar" sender:self];
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
