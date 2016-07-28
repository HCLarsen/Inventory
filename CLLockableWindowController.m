//
//  CLLockableWindowController.m
//  Inventory
//
//  Created by Chris Larsen on 10-10-20.
//  Copyright 2010 home. All rights reserved.
//

#import "CLLockableWindowController.h"

@implementation CLLockableWindowController

@synthesize newRecord;
@synthesize openForEditing;
@synthesize mandatoryFields;

-(void)dealloc
{
	[window release];
	
	[super dealloc];
}

#pragma mark setters & getters

-(void)setOpenForEditing:(BOOL)edit
{
	// Code to change the interface based on status
	NSArray *fields = [self allSubviews];

	for (NSView *view in fields){
		if ([view isKindOfClass:[NSControl class]]) {
			[(NSControl *)view setEnabled:edit];
		}		
	}
	
	openForEditing = edit;
	[fields release];
}

-(NSArray *)allSubviews{
	// This method returns an array that contains all of the subviews in the window
	NSMutableArray *fields = [NSMutableArray arrayWithArray:[[[self window] contentView] subviews]];
	NSMutableArray *views = [NSMutableArray arrayWithArray:[[[self window] contentView] subviews]];
	NSMutableArray *newViews = [[NSMutableArray alloc] init];
	
	do {
		[newViews removeAllObjects];	// clears the array to start the new cycle
		for (NSView *view in views){
			if ([view isKindOfClass:[NSTabView class]]) {
				for (NSTabViewItem *item in [(NSTabView *)view tabViewItems]){
					[newViews addObject:[item view]];
				}
			} else {
				[newViews addObjectsFromArray:[view subviews]];
			}
		}	
		[fields addObjectsFromArray:newViews];
		[views setArray:newViews];		// clears the views before replacing them with the new views
	} while ([newViews count] > 0);
	
	[views release];
	[newViews release];
	
	return fields;
}

# pragma mark Toolbar Actions
 
-(IBAction)open:(id)sender
{
	if ([self openForEditing]) return;
	[self setOpenForEditing:YES];
}

-(IBAction)cancel:(id)sender
{
	if (![self openForEditing]) return;
	
	if (self.newRecord) {
		[self close];
	}
	
	[self setOpenForEditing:NO];
}

-(IBAction)save:(id)sender
{
	if (![self openForEditing]) return;
	
	[[self window] endEditingFor:nil];
	
	for (NSString *key in mandatoryFields) {
		if ([[[mandatoryFields objectForKey:key] stringValue] isEqual:@""]) {
			NSAlert *alert = [[[NSAlert alloc] init] autorelease];
			[alert addButtonWithTitle:@"OK"];
			[alert setMessageText:@"Incomplete Record"];
			NSString *string = [NSString stringWithFormat:@"%@ is a required field and is currently blank.", key];
			[alert setInformativeText:string];
			[alert setAlertStyle:NSWarningAlertStyle];
			
			[alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
			return;
		}
	}	
	
	[self setOpenForEditing:NO];
}

#pragma mark menu validation method

-(BOOL)validateMenuItem:(NSMenuItem *)menuItem
{	
	if ([[self window] isKeyWindow]) {
		CLLockableWindowController *wc = [[self window] windowController];
		
		if ([menuItem tag] == CLUnlockMenuItemTag) {
			return ![wc openForEditing];
		}		
		if ([menuItem tag] == CLLockMenuItemTag) {
			return [wc openForEditing];
		}
	}
	
	return YES;
}

-(void)windowDidLoad{
	[[self window] setBackgroundColor:[NSColor whiteColor]];
	[self setOpenForEditing:self.newRecord];
}

# pragma mark Window Delegate methods

-(BOOL)windowShouldClose:(id)sender
{
	if ([self openForEditing]) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSInformationalAlertStyle];
		[alert setMessageText:@"Open Record"];
		[alert setInformativeText:@"This record is currently open for editing.  Please save or discard changes before closing the window."];
		[alert addButtonWithTitle:@"OK"];
		
		[alert beginSheetModalForWindow:[self window]
						  modalDelegate:self 
						 didEndSelector:nil
							contextInfo:nil];;
					
		return NO;
	} else {
		return YES;
	}
}

@end
