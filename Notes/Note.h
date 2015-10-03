//
//  Note.h
//  Notes
//
//  Created by Cameron Spickert on 10/2/15.
//  Copyright (c) 2015 Cameron Spickert. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Note : NSManagedObject

@property (nonatomic) NSString *text;

@property (nonatomic, readonly, getter=isEmpty) BOOL empty;

@end
