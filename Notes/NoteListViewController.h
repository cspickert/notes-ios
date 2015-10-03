//
//  NoteListViewController.h
//  Notes
//
//  Created by Cameron Spickert on 10/2/15.
//  Copyright (c) 2015 Cameron Spickert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteStore;

@interface NoteListViewController : UITableViewController

@property (nonatomic) NoteStore *store;

@end
