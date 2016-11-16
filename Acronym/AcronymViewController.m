//
//  ViewController.m
//  Acronym
//
//  Created by Vijay Jain on 11/15/16.
//  Copyright © 2016 Vijay Jain. All rights reserved.
//

#import "AcronymViewController.h"
#import "MBProgressHUD.h"
#import "ServiceAgent.h"
#import "StandsForTableViewCell.h"

@interface AcronymViewController ()  <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) IBOutlet UITextField *acronymTextField;
@property(nonatomic, retain) IBOutlet UITableView *standsForTableView;
@property(nonatomic, retain) IBOutlet UIButton *standsForButton;
@property(nonatomic, retain) IBOutlet UILabel *noResutsFoundLabel;

@property(nonatomic, retain) MBProgressHUD *progressView;
@property(nonatomic, retain) ServiceAgent *serviceAgent;
@property(nonatomic, retain) NSArray *acronymValues;
- (void) showProgressView;
- (void) hideProgressView;

@end

@implementation AcronymViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.serviceAgent = [[ServiceAgent alloc] init];
    self.acronymTextField.layer.cornerRadius = 5;
    self.acronymTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    self.acronymTextField.layer.borderWidth = 1;
    self.acronymTextField.clipsToBounds = YES;
    self.noResutsFoundLabel.hidden = YES;
    [self.acronymTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.acronymTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)standsForButtonTouched:(id)sender
{
    self.noResutsFoundLabel.hidden = YES;
    [self showProgressView];
    if (self.acronymTextField.text.length > 0)
    {
        [self.serviceAgent downloadAcronymValues:self.acronymTextField.text errorHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressView];
                self.acronymValues = nil;
                [self.standsForTableView reloadData];
            });
        } completionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressView];
                self.acronymValues = self.serviceAgent.acronymValues;
                if (self.acronymValues.count == 0)
                {
                    self.noResutsFoundLabel.hidden = NO;
                }
                else
                {
                    self.noResutsFoundLabel.hidden = YES;
                }
                [self.standsForTableView reloadData];
            });
        }];
         
    }
    else
    {
        [self.standsForTableView reloadData];
    }
}

- (void) showProgressView
{
    if (self.progressView == nil)
    {
        self.progressView = [[MBProgressHUD alloc] initWithView:self.standsForTableView];
        
        self.progressView.delegate = self;
        
        [self.standsForTableView addSubview:self.progressView];
        if (self.progressView.label.text.length == 0)
            self.progressView.label.text = @"Loading...";
    }
    
    [self.standsForTableView bringSubviewToFront:self.progressView];
    [self.progressView showAnimated:YES];
}

- (void) hideProgressView
{
    [self.progressView hideAnimated:YES];
    self.progressView.delegate = nil;
    
}

- (void) hudWasHidden
{
    
}

- (void)textFieldDidChange:(id)sender
{
    if (self.acronymTextField.text.length == 0)
    {
        self.acronymValues = nil;
        self.noResutsFoundLabel.hidden = YES;
        [self.standsForTableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.acronymValues == nil)
    {
        return 0;
    }
    return self.acronymValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *value = [self.acronymValues objectAtIndex:indexPath.row];
    
    StandsForTableViewCell *cell = (StandsForTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StandsForTableViewCell"];
    [cell setupValue:value];
    return cell;
}
@end
