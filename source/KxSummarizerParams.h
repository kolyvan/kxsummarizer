//
//  KxSummarizerParams.h
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

@interface KxSummarizerParams : NSObject

@property (readwrite, nonatomic) NSUInteger maxKeywordCount;
@property (readwrite, nonatomic) NSUInteger idealSentenceSize;
@property (readwrite, nonatomic) NSUInteger minKeywordSize;

@property (readwrite, nonatomic) float partOfSpeechUnknownScore;
@property (readwrite, nonatomic) float partOfSpeechOtherScore;
@property (readwrite, nonatomic) float partOfSpeechAdjectiveScore;
@property (readwrite, nonatomic) float partOfSpeechAdverbScore;
@property (readwrite, nonatomic) float partOfSpeechVerbScore;
@property (readwrite, nonatomic) float partOfSpeechNounScore;
@property (readwrite, nonatomic) float partOfSpeechNameScore;
@property (readwrite, nonatomic) float partOfSpeechNumberScore;

@property (readwrite, nonatomic) float plotProgress;
@property (readwrite, nonatomic) float middleProgress;
@property (readwrite, nonatomic) float finalProgress;

@property (readwrite, nonatomic) float introScoreFactor;
@property (readwrite, nonatomic) float plotScoreFactor;
@property (readwrite, nonatomic) float middleScoreFactor;
@property (readwrite, nonatomic) float finalScoreFactor;

@property (readwrite, nonatomic) float firstEntryScoreFactor;
@property (readwrite, nonatomic) float uppercaseScoreFactor;

@property (readwrite, nonatomic) float keywordScoreFactor;
@property (readwrite, nonatomic) float summationBasedScoreFactor;
@property (readwrite, nonatomic) float densityBasedScoreFactor;
@property (readwrite, nonatomic) float extraScoreFactor;

@property (readwrite, nonatomic) float firstLineScoreFactor;
@property (readwrite, nonatomic) float lastLineScoreFactor;
@property (readwrite, nonatomic) float leadingDashScoreFactor;
@property (readwrite, nonatomic) float leadingQuoteScoreFactor;
@property (readwrite, nonatomic) float exclamationScoreFactor;
@property (readwrite, nonatomic) float questionScoreFactor;
@property (readwrite, nonatomic) float colonScoreFactor;

@property (readwrite, nonatomic) float adjacentKeywordsFactor;
@property (readwrite, nonatomic) float idealSentenceSizeDampFactor;

- (instancetype) initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *) asDictionary;

@end