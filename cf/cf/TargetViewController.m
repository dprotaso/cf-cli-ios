//
//  TargetViewController.m
//  cf
//
//  Created by DX197 on 8/11/15.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import "TargetViewController.h"
#import "CFBridge.h"

@interface TargetViewController ()

@end

@implementation TargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.target = self.navigationItem.rightBarButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)textChanged:(id)sender {
    self.target.enabled = [[sender text] length] > 0;
}


- (IBAction)target:(id)sender {
    self.SpinView.hidden = NO;
    self.target.enabled = NO;
    [[CFBridge shared] setAPIWithEndpoint:self.endpoint.text skipSSL:self.skipSSL.on block:^(NSError*error) {
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
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];

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
