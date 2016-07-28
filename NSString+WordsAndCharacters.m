//
//  NSString+WordsAndCharacters.m
//  WordsTest
//
//  Created by Chris Larsen on 11-01-29.
//  Copyright 2011 home. All rights reserved.
//

#import "NSString+WordsAndCharacters.h"

@implementation NSString(WordsAndCharacters)

-(NSArray *)wordsFromString 
{
	NSMutableArray *words = [NSMutableArray arrayWithArray:
							 [self componentsSeparatedByString:@" "]];
	
	NSArray *wordLoop = [words copy];
	for (NSString *word in wordLoop){
		if ([word isEqualToString:@""]) {
			[words removeObjectIdenticalTo:word];
		}
	}
	[wordLoop release];
	
	return words;	
}

+(NSString *)stringFromWords:(NSArray *)words 
{
	int i;
	for (i=0; i<[words count]; i++){
		if (![[words objectAtIndex:i] isKindOfClass:[NSString class]]) {
			NSLog(@"stringFromWords Error: Array contains non-string objects.");
			return [NSString string];
		}
	}

	NSMutableString *string = [NSMutableString stringWithString:[words objectAtIndex:0]];
	for (i=1; i<[words count]; i++){
		[string appendString:@" "];		
		[string appendString:[words objectAtIndex:i]];
	}
	
	return string;
}

-(NSString *)wordNumber:(int)index
{
	NSArray *words = [self wordsFromString];
	return [words objectAtIndex:index];
}

-(NSString *)firstWord
{
	return [self wordNumber:1];
}

-(NSString *)lastWord
{
	NSArray *words = [self wordsFromString];
	return [words objectAtIndex:[words count]];	
}

-(int)numberOfWords
{
	NSArray *words = [self wordsFromString];
	return [words count];
}

-(NSString *)keyFromName
{
	int i;
	// first step is to uncapitalize the first word	
	NSMutableArray *words = [NSMutableArray arrayWithArray:[self wordsFromString]];
	[words replaceObjectAtIndex:0 withObject:[[words objectAtIndex:0] lowercaseString]];
	// second step is to capitalize all the other words
	for (i=1; i<[words count]; i++){
		[words replaceObjectAtIndex:i withObject:[[words objectAtIndex:i] capitalizedString]];
	}
	// third step is to remove all spaces and punctuation
	NSMutableString *string = [NSMutableString stringWithString:[NSString stringFromWords:words]];
	NSRange range;
	range.length = 1;
	for (i=0; i<[string length]; i++){
		CLCharacter *c = [CLCharacter characterWithChar:[string characterAtIndex:i]];
		if (![c isLetter] && ![c isNumber]) {
			range.location = i;
			[string deleteCharactersInRange:range];
		}
	}
	[words release];
	
	return string;
}

-(NSString *)nameFromKey
{
	NSMutableString *string = [NSMutableString stringWithString:self];
	// first step is to add spaces and separate the words
	int i;
	for (i=1; i<[string length]; i++){
		CLCharacter *c = [CLCharacter characterWithChar:[string characterAtIndex:i]];
		if ([c isUpperCaseLetter] || [c isNumber]) {
			[string insertString:@" " atIndex:i];
			i++;
		}
	}
	NSMutableArray *words = [NSMutableArray arrayWithArray:[string wordsFromString]];
	// second step is to capitalize the first word
	[words replaceObjectAtIndex:0 withObject:[[words objectAtIndex:0] capitalizedString]];
	[string release];
	
	return [NSString stringFromWords:words];
}

#pragma mark CLCharacter compliance methods

-(NSArray *)lettersFromString
{
	NSMutableArray *letters = [[NSMutableArray alloc] init];
	int i;
	
	for (i=0; i<[self length]; i++){
		CLCharacter *aChar = [CLCharacter characterWithChar:[self characterAtIndex:i]];
		[letters addObject:aChar];
		[aChar release];
	}
	
	return letters;
}

-(CLCharacter *)letterAtIndex:(NSUInteger)index
{
	CLCharacter *aChar = [[CLCharacter alloc] initWithChar:[self characterAtIndex:index]];
	
	return aChar;
}

-(CLCharacter *)firstLetter
{
	CLCharacter *aChar = [[CLCharacter alloc] initWithChar:[self characterAtIndex:0]];
	
	return aChar;	
}

-(CLCharacter *)lastLetter
{
	CLCharacter *aChar = [[CLCharacter alloc] initWithChar:[self characterAtIndex:[self length]-1]];
	
	return aChar;	
}

@end
