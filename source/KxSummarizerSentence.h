//
//  KxSummarizerSentence.h
//  https://github.com/kolyvan/kxsummarizer
//
//  Created by Kolyvan on 24.12.15.
//  Copyright © 2015 Konstantin Bukreev. All rights reserved.
//

/*
 Copyright (c) 2015 Konstantin Bukreev All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(UInt8, KxSummarizerSentenceFlags) {
    
    KxSummarizerSentenceFlagNone            = 0,
    KxSummarizerSentenceFlagFirst           = 1 << 0,
    KxSummarizerSentenceFlagLast            = 1 << 1,
    KxSummarizerSentenceFlagLeadingDash     = 1 << 2,
    KxSummarizerSentenceFlagLeadingQuote    = 1 << 3,
    KxSummarizerSentenceFlagExclamation     = 1 << 4,
    KxSummarizerSentenceFlagQuestion        = 1 << 5,
    KxSummarizerSentenceFlagColon           = 1 << 6,
};

@class KxSummarizerParams;

@interface KxSummarizerSentence : NSObject
@property (readonly, nonatomic) NSUInteger textNo;             // index of piece of text
@property (readonly, nonatomic) NSUInteger index;               // position index in a text
@property (readonly, nonatomic) float progress;                 // position progess in a text
@property (readonly, nonatomic) NSUInteger totalCount;          // total word's count in sentence
@property (readonly, nonatomic) NSRange range;                  // range of sentence in a text
@property (readonly, nonatomic, strong) NSString *string;       // sentence's string
@property (readonly, nonatomic, strong) NSArray *words;         // keywords
@property (readonly, nonatomic) KxSummarizerSentenceFlags flags;
@property (readonly, nonatomic) float score;

- (NSComparisonResult) compareByScore:(KxSummarizerSentence *)other;
- (NSComparisonResult) compareByLocation:(KxSummarizerSentence *)other;

+ (NSArray *) buildSentences:(NSString *)text
                       range:(NSRange)range
                      params:(KxSummarizerParams *)params
                   stopwords:(NSSet *)stopwords
                    excluded:(NSArray *)excluded
                     ltagger:(NSLinguisticTagger *)ltagger
                    keywords:(NSMutableDictionary *)keywords;

@end



