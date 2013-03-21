//
//  ViewController.m
//  test
//
//  Created by nickcheng on 13-3-12.
//  Copyright (c) 2013年 NC. All rights reserved.
//

#import "ViewController.h"
#import "NCCWL.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)logTapped:(id)sender {
  DDLogInfo(@"This is Info Hello!");
  DDLogWarn(@"This is Warn Hello!");
  DDLogError(@"This is Error Hello!");
}

- (IBAction)crashTapped:(id)sender {
  [self performSelector:@selector(Crash:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
