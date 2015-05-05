//
//  CheckinViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/28/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "CheckinViewController.h"
#import "Event.h"

@interface CheckinViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkinButton;
@end

@implementation CheckinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.eventTitleLabel setText:self.event.title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)checkinButtonAction:(UIButton *)sender {
    NSLog(@"CHECK-IN YAS");
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
