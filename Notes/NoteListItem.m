//
//  NoteListItem.m
//  Notes
//
//  Created by Cameron Spickert on 10/2/15.
//  Copyright (c) 2015 Cameron Spickert. All rights reserved.
//

#import "NoteListItem.h"

@interface NoteListItem ()

@property (nonatomic, copy) NSArray *lines;

@end

@implementation NoteListItem

@dynamic titleText;
@dynamic subtitleText;

- (instancetype)initWithText:(NSString *)text
{
    if ((self = [super init])) {
        self.lines = [[text componentsSeparatedByString:@"\n"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    }
    return self;
}

- (NSString *)titleText
{
    if (self.lines.count == 0) {
        return [self defaultTitleText];
    }
    return self.lines.firstObject;
}

- (NSString *)subtitleText
{
    if (self.lines.count < 2) {
        return [self defaultSubtitleText];
    }
    return self.lines[1];
}

- (NSString *)defaultTitleText
{
    return @"New note";
}

- (NSString *)defaultSubtitleText
{
    return @"No additional text";
}

@end
