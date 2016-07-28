/*
 
 CLCharacter.h
 Created by Chris Larsen on 11-01-22.

 Copyright 2011 Chris Larsen
 
 This is an Objective-C class for a character object.  It is meant to 
 extend the functionality of the primitive char by adding querying and 
 modification methods, and allowing the primitive to be used in 
 collections such as arrays and sets. Unlike NSNumber, which treats a 
 char as a numeric value, the methods in this class assume the program 
 needs to use it as a character.
 
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


@interface CLCharacter : NSObject {
	char character;
}
+(id)characterWithChar:(char)aChar;
-(id)initWithChar:(char)aChar;
-(char)charValue;
-(NSString *)charAsString;
-(BOOL)isNumber;
-(BOOL)isLetter;
-(BOOL)isUpperCaseLetter;
-(BOOL)isLowerCaseLetter;
-(void)makeUpperCase;
-(void)makeLowerCase;

@end
