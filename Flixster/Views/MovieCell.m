//
//  MovieCell.m
//  Flixster
//
//  Created by Daniel Shiferaw on 6/27/18.
//  Copyright © 2018 Daniel Shiferaw. All rights reserved.
//

#import "MovieCell.h"


@implementation MovieCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.movieTitle sizeToFit];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //set the background
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = UIColor.redColor;
    self.selectedBackgroundView = backgroundView;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
