//
//  KxDemoSummaryText.h
//  https://github.com/kolyvan/kxsummarizer
//
//  Created by Kolyvan on 25.12.15.
//  Copyright © 2015 Konstantin Bukreev. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface KxDemoSummaryText : NSObject
@property (readonly, nonatomic, strong) NSString *title;
@property (readonly, nonatomic, strong) NSString *content;
@property (readonly, nonatomic) float factor;

+ (instancetype) textWithTitle:(NSString *)title
                       content:(NSString *)content
                        factor:(float)factor;

- (instancetype) initWithTitle:(NSString *)title
                       content:(NSString *)content
                        factor:(float)factor;
@end
