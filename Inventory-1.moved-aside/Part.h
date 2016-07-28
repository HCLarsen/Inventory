//
//  Part.h
//  Inventory
//
//  Created by Chris Larsen on 10-10-20.
//  Copyright 2010 home. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Part :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * onHand;
@property (nonatomic, retain) NSNumber * allocated;
@property (nonatomic, retain) NSString * manufacturer;
@property (nonatomic, retain) NSString * partDescription;
@property (nonatomic, retain) NSNumber * available;
@property (nonatomic, retain) NSNumber * onOrder;
@property (nonatomic, retain) NSNumber * openForEditing;
@property (nonatomic, retain) NSNumber * newAttribute;
@property (nonatomic, retain) NSString * name;

@end



