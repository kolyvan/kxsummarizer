//
//  KxDemoSummaryText.m
//  https://github.com/kolyvan/kxsummarizer
//
//  Created by Kolyvan on 25.12.15.
//  Copyright © 2015 Konstantin Bukreev. All rights reserved.
//

#import "KxDemoSummaryText.h"

@implementation KxDemoSummaryText

+ (instancetype) textWithTitle:(NSString *)title
                       content:(NSString *)content
                        factor:(float)factor
{
    return [[self alloc] initWithTitle:title content:content factor:factor];
}

- (instancetype) initWithTitle:(NSString *)title
                       content:(NSString *)content
                        factor:(float)factor
{
    if ((self = [super init])) {
        _title = title;
        _content = content;
        _factor = factor;
    }
    return self;
}

@end
