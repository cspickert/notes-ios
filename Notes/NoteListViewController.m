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
#import "NotesDocument.h"

@interface NoteListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NotesDocument *document;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation NoteListViewController

#pragma mark -
#pragma mark View controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 56;

    NSURL *fileURL = [self documentFileURL];

    NotesDocument *document = [[NotesDocument alloc] initWithFileURL:fileURL];
    self.document = document;

    void (^completion)(BOOL) = ^(BOOL success) {
        if (success) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
            fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO] ];

            NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:document.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
            fetchedResultsController.delegate = self;
            self.fetchedResultsController = fetchedResultsController;

            [fetchedResultsController performFetch:NULL];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error opening document!");
        }
    };

    if ([[NSFileManager defaultManager] fileExistsAtPath:fileURL.path]) {
        [document openWithCompletionHandler:completion];
    } else {
        [document saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:completion];
    }
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
    [self saveNotes];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditNote"]) {
        NoteDetailViewController *detailController = (NoteDetailViewController *)segue.destinationViewController;

        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        detailController.note = [self.fetchedResultsController objectAtIndexPath:indexPath];

    } else if ([segue.identifier isEqualToString:@"CreateNote"]) {
        NoteDetailViewController *detailController = (NoteDetailViewController *)segue.destinationViewController;

        Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:self.document.managedObjectContext];
        [self.document updateChangeCount:UIDocumentChangeDone];
        [self saveNotes];

        detailController.note = note;
    }
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell"];

    Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NoteListItem *noteItem = [[NoteListItem alloc] initWithText:note.text timestamp:note.timestamp];
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
        Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [note.managedObjectContext deleteObject:note];
        [self.document updateChangeCount:UIDocumentChangeDone];
        [self saveNotes];
    }
}

#pragma mark -
#pragma mark Fetched results controller methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark Helpers

- (NSURL *)documentFileURL
{
    return [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL] URLByAppendingPathComponent:@"Notes.sqlite"];
}

- (void)removeEmptyNotes:(BOOL)animated
{
    if (self.fetchedResultsController == nil) {
        return;
    }

    NSFetchRequest *fetchRequest = [[self.fetchedResultsController fetchRequest] copy];

    NSArray *allNotes = [self.document.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    for (Note *note in allNotes) {
        if (note.isEmpty) {
            [note.managedObjectContext deleteObject:note];
            [self.document updateChangeCount:UIDocumentChangeDone];
        }
    }
}

- (void)saveNotes
{
    [self.document savePresentedItemChangesWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error saving notes: %@", error);
        }
    }];
}

@end
