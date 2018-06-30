//
//  ViewController.m
//  Flixster
//
//  Created by Daniel Shiferaw on 6/27/18.
//  Copyright © 2018 Daniel Shiferaw. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <MBProgressHUD.h>
#import "MovieCell.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property NSArray *movies;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 200;
    
    //customioze navigation bar
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.backgroundColor = UIColor.blueColor;
    navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.25 blue:0.25 alpha:0.8];
    
    //display activity indicator
    [self.activityIndicator startAnimating];
    //load movies
    [self loadMovies];
    //hide the activity indicator when loading is done
    //setup refresh control
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView.refreshControl addTarget:self action:@selector(loadMovies) forControlEvents:UIControlEventValueChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    
    //download movie poster
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500";
    NSString *partialUrl = movie[@"poster_path"];
    NSString *url = [baseUrl stringByAppendingString: partialUrl];
    NSURL *posterUrl = [NSURL URLWithString: url];
    //get movie title
    movieCell.movieTitle.text = movie[@"title"];
    //get movie overview
    movieCell.movieDescription.text = movie[@"overview"];
    
    //[movieCell.imageView setImageWithURL:posterUrl];
    NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@", movie[@"poster_path"]];
    NSURL *newUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:newUrl];
    
    [movieCell.movieImage setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        if (imageResponse) {
                                            NSLog(@"Image was NOT cached, fade in image");
                                            movieCell.movieImage.alpha = 0.0;
                                            movieCell.movieImage.image = image;
                                            
                                            //Animate UIImageView back to alpha 1 over 0.3sec
                                            [UIView animateWithDuration:0.3 animations:^{
                                                movieCell.movieImage.alpha = 1.0;
                                            }];
                                        }
                                        else {
                                            movieCell.movieImage.image = image;
                                        }
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
    
    
    return movieCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

-(void) loadMovies {
    //construct the url
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    //do get request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    //setup session
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]
delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't Get Movies" message:@"The internet connection appears to be offline" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //try to reload movies
                [self loadMovies];
            }];
            [alert addAction:tryAgain];
            //present the alert 
            [self presentViewController:alert animated:YES completion:^{}];
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //get movies
            self.movies = dataDictionary[@"results"];
            
            //reload table 
            [self.tableView reloadData];
            
        }
        [self.tableView.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    }];
    [task resume];
}
//enables to send data to a different view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *clickedCell = sender;
    //get the index of the clicked cell
    NSIndexPath *cellIndex = [self.tableView indexPathForCell:clickedCell];
    //get instance of detail view controller
    DetailViewController *detailViewControler = [segue destinationViewController];
    NSDictionary *currentMovie = self.movies[cellIndex.row];
    //pass the movie to the details view controller
    detailViewControler.movie = currentMovie;
    
}





@end
