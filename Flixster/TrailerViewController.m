//
//  TrailerViewController.m
//  Flixster
//
//  Created by Daniel Shiferaw on 6/28/18.
//  Copyright © 2018 Daniel Shiferaw. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *trailerWebkitView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatoer;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //base trailer url on youtube

    NSString *baseYoutubeUrl = @"https://www.youtube.com/watch?v=";
    
    //construct the url
    NSURL *requestUrl = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movie[@"id"]]];
    //do get request
    NSURLRequest *request = [NSURLRequest requestWithURL: requestUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    //setup session
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    [self.activityIndicatoer startAnimating];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't Get Movies" message:@"The internet connection appears to be offline" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //close
                [alert dismissViewControllerAnimated:YES completion:^{}];
            }];
            [alert addAction:tryAgain];
            //present the alert
            [self presentViewController:alert animated:YES completion:^{}];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //get movie
            NSDictionary *movie = dataDictionary[@"results"][0];
        
            //reload table
            NSString *trailerAddress = [baseYoutubeUrl stringByAppendingString: movie[@"key"]];
            
            //create a url request
            NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:trailerAddress]
                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            
            //load request into webView
            [self.trailerWebkitView loadRequest:request];
            
            [self.activityIndicatoer stopAnimating];
        }
        
    }];
    [task resume];
    
    
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

@end
