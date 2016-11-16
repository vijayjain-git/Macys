//
//  StandsForTableViewCell.m
//  Acronym
//
//  Created by Vijay Jain on 11/15/16.
//  Copyright © 2016 Vijay Jain. All rights reserved.
//

#import "StandsForTableViewCell.h"

@interface StandsForTableViewCell()

@property (nonatomic, assign) IBOutlet UILabel *valueLabel;

@end
@implementation StandsForTableViewCell

- (void) setupValue:(NSString *)value
{
    self.valueLabel.text = value;
}

@end
