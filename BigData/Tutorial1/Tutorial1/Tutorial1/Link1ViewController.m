//
//  Link1ViewController.m
//  Tutorial1
//
//  Created by Kuthala, Ramesh (UMKC-Student) on 6/12/15.
//  Copyright (c) 2015 IceAndFire. All rights reserved.
//

#import "Link1ViewController.h"
#import "RameshViewController.h"

@interface Link1ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *link1text;

@end

@implementation Link1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)link1HomeTouchUpInside:(id)sender {
    NSLog(@"touched inside");
    [self dismissModalViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)callRamesh:(id)sender {
    RameshViewController *rameshView = [self.storyboard instantiateViewControllerWithIdentifier:@"RameshController"];

    [self presentViewController:rameshView animated:YES completion:NULL];
}

@end
