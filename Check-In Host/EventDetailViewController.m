//
//  EventDetailViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/16/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventDetailViewController.h"
#import "Event.h"

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;
@property (weak, nonatomic) IBOutlet UIButton *createEventButton;
@property (strong, nonatomic) Event *event;
@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
    
    [self.scrollView setFrame:self.view.frame];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
//    self.scrollView.contentSize = self.contentView.frame.size;
    // Do any additional setup after loading the view.
    
//    self.event = [[Event alloc] initWithEventWithTitle:@"My Event" location:nil date:nil attendees:nil];
//    [self.event commit];
}


- (IBAction)createEventButtonAction:(UIButton *)sender {
    [self.marker setTitle:self.eventTitleTextField.text];
}


- (BOOL)shouldAutorotate
{
    id currentViewController = self;
    
    if ([currentViewController isKindOfClass:[EventDetailViewController class]])
        return NO;
    
    return YES;
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
