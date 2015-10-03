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
@property (nonatomic) NSDate *timestamp;

@end

@implementation NoteListItem

@dynamic titleText;
@dynamic subtitleText;

- (instancetype)initWithText:(NSString *)text timestamp:(NSDate *)timestamp
{
    if ((self = [super init])) {
        self.lines = [[text componentsSeparatedByString:@"\n"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
        self.timestamp = timestamp;
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;

    NSString *subtitleText = nil;
    if (self.lines.count < 2) {
        subtitleText = [self defaultSubtitleText];
    } else {
        subtitleText = self.lines[1];
    }

    NSString *timestampString = [dateFormatter stringFromDate:self.timestamp];

    return [NSString stringWithFormat:@"%@ – %@", timestampString, subtitleText];
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
