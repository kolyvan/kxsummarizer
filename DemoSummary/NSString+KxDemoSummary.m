//
//  NSString+KxDemoSummary.m
//  https://github.com/kolyvan/kxsummarizer
//
//  Created by Kolyvan on 25.12.15.
//  Copyright © 2015 Konstantin Bukreev. All rights reserved.
//

#import "NSString+KxDemoSummary.h"

@implementation NSString(KxDemoSummary)

- (NSArray *) splitOnSentences
{
    if (!self.length) {
        return nil;
    }
    
    NSMutableArray *sentences = [NSMutableArray array];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationBySentences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL * stop)
     {
         substring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         if (substring.length) {
             [sentences addObject:substring];
         }
     }];    
    return sentences;
}
@end
