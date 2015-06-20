//
//  TrainViewController.m
//  Tutorial2
//
//  Created by Mayanka  on 6/18/15.
//  Copyright (c) 2015 Bhargava. All rights reserved.
//

#import "TrainViewController.h"
#import "UNIRest.h"
#import "UNIUrlConnection.h"

@interface TrainViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *customImageView;

@end

@implementation TrainViewController

UIImage *image;
NSString *imgUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)getImageInside:(id)sender {
    NSLog(@"In get Images");
    
    UIImagePickerController *imagePicker = [[UIImagePickerController     alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [imagePicker setDelegate:self];
    [self presentModalViewController:imagePicker animated:YES];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Auto Call Back");
    [picker dismissModalViewControllerAnimated:YES];
    image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"info struct: %@", info);
    imgUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    
 //
    [_customImageView setImage:image];
    
//    imageView.image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *webData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:@"png"];
    imgUrl = [documentsDirectory stringByAppendingPathComponent:@"1.jpg"];

    [webData writeToFile:imgUrl atomically:YES];
    NSLog(@"localFilePath.%@",imgUrl);
    
    UIImage *image1 = [UIImage imageWithContentsOfFile:imgUrl];
    NSLog(@"image url: %@", image1);
    
     _customImageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (IBAction)trainImageService:(id)sender {

    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //NSString *pName =
    //NSMutableString *post = [NSMutableString alloc];
    //[post
    
    /*NSString *postLength = [NSString stringWithFormat:@"%ld", imageData.length];
    NSString *url = @"http://lasir.umkc.edu:8080/cisaservice/webresources/ocisa/facerecognition";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:imageData];
    NSLog(encodedString);
    */
    NSURL *urlFiles = [NSURL URLWithString:imgUrl];
    NSLog(@"setting ns dictionary headers");
     // These code snippets use an open-source library. http://unirest.io/objective-c
     NSDictionary *headers = @{@"X-Mashape-Key": @"5nTsIAy0HTmshvRZutOeG76fb69ep1apikljsnQEJ2AeL397C9"};
    NSLog(@"header is set: %lu", (unsigned long)headers.count);
     NSDictionary *parameters = @{@"album": @"faces4bda",
                                  @"albumkey": @"f6090736e90d23958d8695af5389f456eec597fd6615445c3324b4f9c954e162",
                                  @"entryid": @"demo",
//                                  @"files":encodedString};
    @"urls": @"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQHnSFtRTE_tmk28IZyB7QxvKU-WlymOtwvWDC-XiGYlRu2HpHRFL4G4jW-NQ"};
    NSLog(@"setting parameters");
    UNIUrlConnection *asyncConnection = [[UNIRest post:^(UNISimpleRequest *request) {
        NSLog(@" executing post");
        [request setUrl:@"https://lambda-face-recognition.p.mashape.com/album_train"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSLog(@" received response: %@", response);
        NSInteger code = response.code;
        NSLog(@"resp code: %lu", (unsigned long)code);
        
        NSDictionary *responseHeaders = response.headers;
        UNIJsonNode *body = response.body;
        NSData *rawBody = response.rawBody;
        NSLog(@"response: %@", body.JSONObject);// objectForKey:@"album"]);
//        NSLog(@"album name: %@",[body objectForKey:@"album"]);
    }];
    
    NSLog(@"executed uni url");
   }

@end
