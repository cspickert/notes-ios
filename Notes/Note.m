//
//  Note.m
//  Notes
//
//  Created by Cameron Spickert on 10/2/15.
//  Copyright (c) 2015 Cameron Spickert. All rights reserved.
//

#import "Note.h"

@implementation Note

@dynamic text;
@dynamic timestamp;
@dynamic empty;

- (void)awakeFromInsert
{
    [super awakeFromInsert];

    self.timestamp = [NSDate date];
}

- (BOOL)isEmpty
{
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

@end
