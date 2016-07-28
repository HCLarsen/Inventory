/*
 
 NSString+WordsAndCharacters.h
 Created by Chris Larsen on 11-01-29.

 Copyright 2011 Chris Larsen
 
 This is an Objective-C category for NSString and NSMutableString that offers
 additional methods for treating a string as a sentence.  Methods include
 converting the string to an array of words and vice-versa, and finding words by
 their location in the string.
 
 This category also adds the ability to work directly with my CLCharacter class.
 An array of character objects can be created directly from a string, and a 
 character can be found based on it's position in the string.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */


#import <Cocoa/Cocoa.h>
#include "CLCharacter.h"

@interface NSString(WordsAndCharacters)

-(NSArray *)wordsFromString;
+(NSString *)stringFromWords:(NSArray *)words;
-(NSString *)wordNumber:(int)index;
-(int)numberOfWords;
-(NSString *)firstWord;
-(NSString *)lastWord;

-(NSString *)keyFromName;
-(NSString *)nameFromKey;

-(NSArray *)lettersFromString;
//-(CLCharacter *)characterAtIndex:(NSUInteger)index;
-(CLCharacter *)letterAtIndex:(NSUInteger)index;
-(CLCharacter *)firstLetter;
-(CLCharacter *)lastLetter;

@end
