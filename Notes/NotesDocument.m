//
//  NotesDocument.m
//  Notes
//
//  Created by Cameron Spickert on 10/2/15.
//  Copyright © 2015 Cameron Spickert. All rights reserved.
//

#import "NotesDocument.h"
#import <CoreData/CoreData.h>

@implementation NotesDocument

- (NSDictionary *)persistentStoreOptions
{
    return @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES };
}

- (BOOL)readFromURL:(NSURL *)url error:(NSError * _Nullable __autoreleasing *)outError
{
    NSError *error = nil;
    BOOL result = [super readFromURL:url error:&error];
    if (!result) {
        NSLog(@"Error: %@", error);
        if (error != nil) {
            if (outError != NULL) {
                *outError = error;
            }
        }
    }
    return result;
}

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted
{
    NSLog(@"Error: %@", error);

    if (userInteractionPermitted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        });
    }
}

@end
