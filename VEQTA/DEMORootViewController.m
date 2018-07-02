//
//  DEMOViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMORootViewController.h"
 
@interface DEMORootViewController ()

@end

@implementation DEMORootViewController

- (void)awakeFromNib
{
//    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"usagrrement"]) {
//
//    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController1"];
//    }
//    else
//    {
//      self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
//    }
     self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

@end
