//
//  TestViewController.m
//  Tutorial2
//
//  Created by Mayanka  on 6/18/15.
//  Copyright (c) 2015 Bhargava. All rights reserved.
//

#import "TestViewController.h"
#import "UNIRest.h"
#import "UNIUrlConnection.h"

@interface TestViewController ()
@property (strong, nonatomic) IBOutlet UILabel *responseJson;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testRecognition:(id)sender {
    NSLog(@"test recognised");
    // These code snippets use an open-source library. http://unirest.io/objective-c
    NSDictionary *headers = @{@"X-Mashape-Key": @"5nTsIAy0HTmshvRZutOeG76fb69ep1apikljsnQEJ2AeL397C9", @"Content-Type": @"application/x-www-form-urlencoded", @"Accept": @"application/json"};
    NSDictionary *parameters = @{@"album": @"BRImages", @"albumkey": @"9dfede25210ccd92f681c70e6557a2fa844dfe41023b50e6aa27f99c23b576d1", @"urls": @"http://i.ndtvimg.com/mt/movies/2013-05/maheshbabu43.jpg"};
    UNIUrlConnection *asyncConnection = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://lambda-face-recognition.p.mashape.com/recognize"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSInteger code = response.code;
        NSDictionary *responseHeaders = response.headers;
        UNIJsonNode *body = response.body;
        NSData *rawBody = response.rawBody;
//        NSLog(@"uids: ",[[[body.JSONObject objectForKey:@"photos"] objectForKey:@"tags"] objectForKey:@"uids"]);
//        NSArray *photos = [body.JSONObject[@"photos"] ];
//        NSArray *tags = photos[@"tags"];
//        NSArray *uids = tags[@"uids"];

        NSLog(@"total response: %@", body.JSONObject);
        NSLog(@"response: %@", [body.JSONObject objectForKey:@"photos"]);
        NSArray *photos = [body.JSONObject objectForKey:@"photos"];
        NSLog(@"photos array: %@", photos);
        NSArray *tags = [[photos objectAtIndex:0] valueForKey:@"tags"];
        NSLog(@"tags resp: %@", tags);
        NSArray *uids = [[tags objectAtIndex:0] valueForKey:@"uids"];
        NSLog(@"uids: %@", uids);
        NSString *prediction = [[uids objectAtIndex:0] valueForKey:@"prediction"];
        NSLog(@"predicted name: %@", prediction);
        //NSLog(@"predicted name: %@", [[uids objectAtIndex:0] valueForKey:@"prediction"]);

        //        NSString *str = [NSString stringWithFormat:@"%s", [[uids objectAtIndex:0] valueForKey:@"prediction"]];
        _responseJson.text = @"Detected face:" + prediction;
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
