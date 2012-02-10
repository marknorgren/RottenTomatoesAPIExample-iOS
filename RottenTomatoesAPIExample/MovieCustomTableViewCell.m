//
//  MovieCustomTableViewCell.m
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/5/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import "MovieCustomTableViewCell.h"

@implementation MovieCustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
