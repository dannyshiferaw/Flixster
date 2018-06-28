//
//  MovieCell.h
//  Flixster
//
//  Created by Daniel Shiferaw on 6/27/18.
//  Copyright © 2018 Daniel Shiferaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *movieImage;

@property (weak, nonatomic) IBOutlet UILabel *movieTitle;

@property (weak, nonatomic) IBOutlet UILabel *movieDescription;


@end
