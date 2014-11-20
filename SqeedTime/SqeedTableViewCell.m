//
//  UITableViewCell+SqeedTableViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 19/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "SqeedTableViewCell.h"

@interface SqeedTableViewCell()

@end

@implementation SqeedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

//manage the cell selection and deselection state hear
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
    [super setSelected:selected animated:animated];
    UIView *cellBgView = [self viewWithTag:12345];
    if(selected)
    {
        
        [cellBgView setBackgroundColor:[UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0
                                                       alpha:1.0]]; //your selected background color
    }
    else
    {
        [cellBgView setBackgroundColor:[UIColor clearColor]]; //your deselected background color
        
    }
    
}

//setting the frames of views within the cell
- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView *cellBgView = [self viewWithTag:12345];
    cellBgView.frame = CGRectMake(10, 0, 300, 80);//always set the frame in layoutSubviews
    
}

@end
