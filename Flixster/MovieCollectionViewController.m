//
//  MovieCollectionViewController.m
//  Flixster
//
//  Created by Daniel Shiferaw on 6/28/18.
//  Copyright © 2018 Daniel Shiferaw. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"

@interface MovieCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation MovieCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self loadMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    //download movie poster
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500";
    NSString *partialUrl = movie[@"poster_path"];
    NSString *url = [baseUrl stringByAppendingString: partialUrl];
    NSURL *posterUrl = [NSURL URLWithString: url];
    
    //get post images
    [collectionViewCell.imageView setImageWithURL:posterUrl];
    
    return collectionViewCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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
            [self.collectionView reloadData];
            
        }

    }];
    [task resume];
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
