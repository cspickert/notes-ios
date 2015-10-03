//
//  NoteListItem.h
//  Notes
//
//  Created by Cameron Spickert on 10/2/15.
//  Copyright (c) 2015 Cameron Spickert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteListItem : NSObject

@property (nonatomic, readonly) NSString *titleText;
@property (nonatomic, readonly) NSString *subtitleText;

- (instancetype)initWithText:(NSString *)text;

@end
