//
//  DetailViewController.m
//  Flixster
//
//  Created by Daniel Shiferaw on 6/27/18.
//  Copyright © 2018 Daniel Shiferaw. All rights reserved.
//

#import "DetailViewController.h"
#import "TrailerViewController.h"
#import <AFNetworking.h>

@interface DetailViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

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
    
    //set up gesture
    self.tapGesture.delegate = self;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(posterTapped:)];
    self.posterImageView.userInteractionEnabled = YES;
    [self.posterImageView addGestureRecognizer: self.tapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)posterTapped:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"toTrailer" sender:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TrailerViewController *trailerController = segue.destinationViewController;
    trailerController.movie = self.movie;
    
}


@end
