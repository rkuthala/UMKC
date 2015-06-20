//
//  ViewController.m
//  Tutorial2
//
//  Created by Mayanka  on 6/18/15.
//  Copyright (c) 2015 Bhargava. All rights reserved.
//

#import "ViewController.h"
#import "TrainViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goTrainImages:(id)sender {
    NSLog(@"Going to TrainController");
    TrainViewController *train = [self.storyboard instantiateViewControllerWithIdentifier:@"TrainController"];
    
    [self presentViewController:train animated:YES completion:NULL ];
}

- (IBAction)goTestImages:(id)sender {
    
    NSLog(@"Going to TestController");
    TestViewController *test = [self.storyboard instantiateViewControllerWithIdentifier:@"TestController"];
    
    [self presentViewController:test animated:YES completion:NULL ];
    
}


@end
