//
//  DetailViewController.m
//  Flixster
//
//  Created by Daniel Shiferaw on 6/27/18.
//  Copyright © 2018 Daniel Shiferaw. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //download poster image
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500";
    NSString *partialUrl = self.movie[@"poster_path"];
    NSString *url = [baseUrl stringByAppendingString: partialUrl];
    NSURL *posterUrl = [NSURL URLWithString: url];
    [self.posterImageView setImageWithURL:posterUrl];
    
    //download backdrop image
    NSString *partialBackdropUrl = self.movie[@"backdrop_path"];
    NSString *backdropImageUrl = [baseUrl stringByAppendingString: partialBackdropUrl];
    NSURL *backdropUrl = [NSURL URLWithString: backdropImageUrl];
    [self.backdropImageView setImageWithURL:backdropUrl];
    
    //set title and overview 
    self.titleLabel.text = self.movie[@"title"];
    self.overviewLabel.text = self.movie[@"overview"];

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
