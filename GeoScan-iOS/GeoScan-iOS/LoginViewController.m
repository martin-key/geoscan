//
//  LoginViewController.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "LoginViewController.h"
#import "DatabaseInformation.h"

@interface LoginViewController ()
{
    NSNotificationCenter * notificationCenter;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *rememberPasswordSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *automaticLoginSwitch;
@property (strong, nonatomic) DatabaseInformation * database;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.database = [DatabaseInformation sharedInstance];
    notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(loginCompleteNotificationHandler:)
                               name:LOGIN_SUCCESSFUL
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(loginUnsuccessfulNotificationHandler:)
                               name:LOGIN_NOT_SUCCESSFUL
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(connectionProblemsNotificationHandler:)
                               name:CONNECTION_PROBLEMS
                             object:nil];
    
    
    [self.usernameTextField becomeFirstResponder];
    
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    
    
    // Do any additional setup after loading the view.
}

- (void) dealloc
{
    [notificationCenter removeObserver:self];
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

- (IBAction)loginButtonHandler:(UIButton *)sender {
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.database loginWithName:self.usernameTextField.text andPassword:self.passwordTextField.text];
}


- (IBAction)registerButtonHandler:(UIButton *)sender {
}

- (void) loginCompleteNotificationHandler: (NSNotification *) notification
{
   dispatch_async(dispatch_get_main_queue(), ^{
       [self performSegueWithIdentifier:@"loginSuccessfulSegue" sender:nil];
       [self.activityIndicator setHidden:YES];
       [self.activityIndicator stopAnimating];
   });
    
}

- (void) loginUnsuccessfulNotificationHandler: (NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Login unsuccessful" message:@"Please check your username and/or password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //do nothing
        }];
        
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
            [self.activityIndicator setHidden:YES];
            [self.activityIndicator stopAnimating];
            
        }];
        
    });
}

- (void) connectionProblemsNotificationHandler: (NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Connection Problems" message:@"Please check your internet connections" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //do nothing
        }];
        
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
            [self.activityIndicator setHidden:YES];
            [self.activityIndicator stopAnimating];
            
        }];
    });
}

@end
