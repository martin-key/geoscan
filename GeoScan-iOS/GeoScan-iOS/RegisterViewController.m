//
//  RegisterViewController.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "RegisterViewController.h"
#import "DatabaseInformation.h"

@interface RegisterViewController ()
{
    DatabaseInformation * database;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    database = [DatabaseInformation sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrationSuccessfulNotificationHandler:)
                                                 name:REGISTRATION_SUCCESSFUL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionProblemsNotificationHandler:)
                                                 name:CONNECTION_PROBLEMS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrationNotSuccessfulNotificationHandler:)
                                                 name:REGISTRATION_NOT_SUCCESSFUL
                                               object:nil];
    
    [self.activityIndicator setHidden:YES];
    
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
- (IBAction)registerButtonHandler:(UIButton *)sender {
    if([self.usernameTextField.text length] > 4 &&
       [self.passwordTextField.text length] > 5 &&
       [self.passwordAgainTextField.text length] > 5 &&
       [self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text] &&
       [self.emailTextField.text length] > 5 &&
       [self.firstNameTextField.text length] > 0 &&
       [self.lastNameTextField.text length] > 0
       )
    {
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        
        [database registerUserWithUsername:self.usernameTextField.text
                                  password:self.passwordTextField.text
                                     email:self.emailTextField.text
                                 firstname:self.firstNameTextField.text
                                  lastname:self.lastNameTextField.text];
        
    }
    else
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Failed" message:@"Check your data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //do nothing
        }];
        
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
            // no completion
        }];
    }
}

- (void) registrationSuccessfulNotificationHandler: (NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Registration successful" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
            // no completion
        }];
    });

}

- (void) registrationNotSuccessfulNotificationHandler: (NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Registration failed" message:@"Registration not successful. Check username and email" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //do nothing
        }];
        
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
            // no completion
        }];
    });
    
    
}


- (void) connectionProblemsNotificationHandler: (NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Connection Problems" message:@"Please check your data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //do nothing
        }];
        
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
            // no completion
        }];
    });
    
}


@end
