//
//  LoginController.m
//  cf
//
//  Created by DX197 on 8/11/15.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import "LoginController.h"
#import "CFBridge.h"

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *target;

@property (weak, nonatomic) IBOutlet UIView *SpinView;

- (IBAction)login:(id)sender;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       self.target = self.navigationItem.rightBarButtonItem;
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

- (IBAction)login:(id)sender {
    self.SpinView.hidden = NO;
    self.target.enabled = NO;


    [[CFBridge shared] loginWithUserName:self.user.text password:self.password.text block:^(NSError*error) {
        self.SpinView.hidden = YES;
        self.target.enabled = YES;
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error description]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            [self performSegueWithIdentifier:@"showOrgs" sender:self];
        }
    }];

}
@end
