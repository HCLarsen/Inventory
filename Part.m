// 
//  Part.m
//  Inventory
//
//  Created by Chris Larsen on 10-11-02.
//  Copyright 2010 home. All rights reserved.
//

#import "Part.h"

@implementation Part 

/* Should have separate initializers for a "new part" and one that's 
 been imported from a CSV or external source. */

# pragma mark Getters and Setters

-(NSNumber *)available {
	[self willAccessValueForKey:@"onHand"];
	[self willAccessValueForKey:@"allocated"];
	NSNumber *value = [NSNumber numberWithInt:[[self onHand] intValue] - [[self allocated] intValue]];
	[self didAccessValueForKey:@"onHand"];
	[self didAccessValueForKey:@"allocated"];
	
	return value;
}

-(NSNumber *)canDelete {
	NSNumber *value;
	
	[self willAccessValueForKey:@"onHand"];
	if ([[self onHand] intValue] == 0) {
		value = [NSNumber numberWithBool:YES];
	} else {
		value = [NSNumber numberWithBool:NO];
	}
	[self didAccessValueForKey:@"onHand"];
	
	return value;
}

@dynamic onHand;
@dynamic allocated;
@dynamic manufacturer;
@dynamic partDescription;
@dynamic available;
@dynamic onOrder;
@dynamic openForEditing;
@dynamic canDelete;
@dynamic partNumber;
@dynamic uOfM;

@end
