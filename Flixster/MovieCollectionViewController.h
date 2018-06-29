//
//  MovieCollectionViewController.h
//  Flixster
//
//  Created by Daniel Shiferaw on 6/28/18.
//  Copyright © 2018 Daniel Shiferaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewController : UIViewController

@property(nonatomic, strong) NSArray *movies;

@property(nonatomic, strong) NSArray *filterdMovies; 

@end
