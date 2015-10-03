//
//  NoteListViewController.m
//  Notes
//
//  Created by Cameron Spickert on 10/2/15.
//  Copyright (c) 2015 Cameron Spickert. All rights reserved.
//

#import "NoteListViewController.h"
#import "NoteDetailViewController.h"
#import "Note.h"
#import "NoteListItem.h"

@interface NoteListViewController ()

@property (nonatomic, copy) NSArray *notes;

@end

@implementation NoteListViewController

#pragma mark -
#pragma mark View controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 56;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self removeEmptyNotes:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditNote"]) {
        NoteDetailViewController *detailController = (NoteDetailViewController *)segue.destinationViewController;

        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        detailController.note = self.notes[indexPath.row];

    } else if ([segue.identifier isEqualToString:@"CreateNote"]) {
        NoteDetailViewController *detailController = (NoteDetailViewController *)segue.destinationViewController;

        Note *note = [[Note alloc] init];
        self.notes = [@[ note ] arrayByAddingObjectsFromArray:self.notes];

        [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];

        detailController.note = note;
    }
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell"];

    Note *note = self.notes[indexPath.row];

    NoteListItem *noteItem = [[NoteListItem alloc] initWithText:note.text];
    cell.textLabel.text = noteItem.titleText;
    cell.detailTextLabel.text = noteItem.subtitleText;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *notes = [self.notes mutableCopy];
        [notes removeObjectAtIndex:indexPath.row];
        self.notes = notes;

        [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -
#pragma mark Helpers

- (void)removeEmptyNotes:(BOOL)animated
{
    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSet];
    NSMutableArray *indexPathsToRemove = [NSMutableArray array];

    [self.notes enumerateObjectsUsingBlock:^(Note *note, NSUInteger idx, BOOL *stop) {
        if (note.isEmpty) {
            [indexesToRemove addIndex:idx];
            [indexPathsToRemove addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
        }
    }];

    NSMutableArray *notes = [self.notes mutableCopy];
    [notes removeObjectsAtIndexes:indexesToRemove];
    self.notes = notes;

    [self.tableView deleteRowsAtIndexPaths:indexPathsToRemove withRowAnimation:animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

@end
