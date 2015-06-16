//
//  ViewController.m
//  Tutorial1
//
//  Created by Kuthala, Ramesh (UMKC-Student) on 6/12/15.
//  Copyright (c) 2015 IceAndFire. All rights reserved.
//

#import "ViewController.h"
#import "Link1ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
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

- (IBAction)hometouchUpInside:(id)sender {
    NSLog(@"touched inside");
    Link1ViewController *link1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Link1Controller"];
    
    [self presentViewController:link1 animated:YES completion:NULL ];
    
    _label1.text = @"Hello World";
}
- (IBAction)homeTouchDown:(id)sender {
    NSLog(@"touched down");
    _label1.text = @"Going to link1";
}

@end
