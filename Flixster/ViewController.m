//
//  ViewController.m
//  Flixster
//
//  Created by Daniel Shiferaw on 6/27/18.
//  Copyright © 2018 Daniel Shiferaw. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "MovieCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *movies;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 200;
    
    [self loadMovies];
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
    [movieCell.imageView setImageWithURL:posterUrl];
    
    //get movie title
    movieCell.movieTitle.text = movie[@"title"];
    
    //get movie overview
    movieCell.movieDescription.text = movie[@"overview"];
    
    
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
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //get movies
            self.movies = dataDictionary[@"results"];
            
            //reload table 
            [self.tableView reloadData];
            
        }
        [self.tableView.refreshControl endRefreshing];
    }];
    [task resume];
}


@end
