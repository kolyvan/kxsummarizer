//
//  KxSummarizerSentence+Edit.h
//  KxSummarizer
//
//  Created by Kolyvan on 26.12.15.
//  Copyright © 2015 Konstantin Bukreev. All rights reserved.
//

#import "KxSummarizerSentence.h"

@interface KxSummarizerSentence(Edit)
@property (readwrite, nonatomic) NSUInteger textNo;
@property (readwrite, nonatomic) NSUInteger index;
@property (readwrite, nonatomic) float progress;
@property (readwrite, nonatomic) NSRange range;
@property (readwrite, nonatomic, strong) NSString *string;
@property (readwrite, nonatomic, strong) NSArray *words;
@property (readwrite, nonatomic) NSUInteger totalCount;
@property (readwrite, nonatomic) KxSummarizerSentenceFlags flags;
@property (readwrite, nonatomic) float score;
@end
