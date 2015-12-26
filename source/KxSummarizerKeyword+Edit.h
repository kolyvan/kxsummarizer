//
//  KxSummarizerKeyword+Edit.h
//  KxSummarizer
//
//  Created by Kolyvan on 26.12.15.
//  Copyright © 2015 Konstantin Bukreev. All rights reserved.
//

#import "KxSummarizerKeyword.h"

@interface KxSummarizerKeyword(Edit)
@property (readwrite, nonatomic) NSUInteger count;
@property (readwrite, nonatomic, strong) NSString *key;
@property (readwrite, nonatomic) KxSummarizerPartOfSpeech partOfSpeech;
@property (readwrite, nonatomic) float score;
@property (readwrite, nonatomic) float extraFactor;
@property (readwrite, nonatomic) BOOL occurred;
@property (readwrite, nonatomic) BOOL off;
@end

