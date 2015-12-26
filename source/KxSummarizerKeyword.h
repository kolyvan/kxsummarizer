//
//  KxSummarizerKeyword.h
//  https://github.com/kolyvan/kxsummarizer
//
//  Created by Kolyvan on 25.12.15.
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

typedef NS_ENUM(UInt8, KxSummarizerPartOfSpeech) {
    
    KxSummarizerPartOfSpeechUnknown,
    KxSummarizerPartOfSpeechOther,
    KxSummarizerPartOfSpeechAdjective,
    KxSummarizerPartOfSpeechAdverb,
    KxSummarizerPartOfSpeechVerb,
    KxSummarizerPartOfSpeechNoun,
    KxSummarizerPartOfSpeechName,
    KxSummarizerPartOfSpeechNumber,  
};

@class KxSummarizerParams;

@interface KxSummarizerKeyword : NSObject
@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic, strong) NSString *key;      // lemma or word
@property (readonly, nonatomic) KxSummarizerPartOfSpeech partOfSpeech;
@property (readonly, nonatomic) float score;
@property (readonly, nonatomic) float extraFactor;         // title, description, etc
@property (readonly, nonatomic) BOOL occurred;             // already occurred in a text
@property (readonly, nonatomic) BOOL off;                  // keyword will not used if true
- (NSComparisonResult) compareByScore:(KxSummarizerKeyword *)other;
- (NSString *) partOfSpeechName;
@end

@interface KxSummarizerWord : NSObject
@property (readonly, nonatomic, strong) KxSummarizerKeyword *keyword;
@property (readonly, nonatomic) NSUInteger index;           // position index in sentence
@property (readonly, nonatomic) BOOL isUppercase;

+ (NSArray *) buildWords:(NSString *)text
                  params:(KxSummarizerParams *)params
               stopwords:(NSSet *)stopwords
                 ltagger:(NSLinguisticTagger *)ltagger
                keywords:(NSMutableDictionary *)keywords
              totalCount:(NSUInteger *)totalCount;          // total word's count in sentence

@end

extern NSString *NSStringFromSummarizerPartOfSpeech(KxSummarizerPartOfSpeech);