//
//  KxSummarizerParams.m
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

#import "KxSummarizerParams.h"

@implementation KxSummarizerParams


- (instancetype) init
{
    if ((self = [super init])) {
        
        _maxKeywordCount            = 256;
        _idealSentenceSize          = 10;
        _minKeywordSize             = 2;
        
        _partOfSpeechUnknownScore   = 0.0f;
        _partOfSpeechOtherScore     = 0.1f;
        _partOfSpeechAdjectiveScore = 0.2f;
        _partOfSpeechAdverbScore    = 0.3f;
        _partOfSpeechVerbScore      = 0.4f;
        _partOfSpeechNounScore      = 1.0f;
        _partOfSpeechNameScore      = 2.0f;
        _partOfSpeechNumberScore    = 1.5f;
        
        _plotProgress               = 0.1f;
        _middleProgress             = 0.4f;
        _finalProgress              = 0.9f;
        
        _introScoreFactor           = 1.0f; // location = 0.0
        _plotScoreFactor            = 0.8f;
        _middleScoreFactor          = 0.6f;
        _finalScoreFactor           = 1.5f;
        
        _firstEntryScoreFactor      = 2.0f;
        _uppercaseScoreFactor       = 3.0f;
        
        _keywordScoreFactor         = 10.0f;
        _summationBasedScoreFactor  = 1.0f;
        _densityBasedScoreFactor    = 5.0f;
        _extraScoreFactor           = 5.0f;
        
        _firstLineScoreFactor       = 1.5f;
        _lastLineScoreFactor        = 1.5f;
        _leadingDashScoreFactor     = 0.2f;
        _leadingQuoteScoreFactor    = 0.5f;
        _exclamationScoreFactor     = 2.0f;
        _questionScoreFactor        = 0.7f;
        _colonScoreFactor           = 0.3f;
                
        _adjacentKeywordsFactor     = 0.7f;
        _idealSentenceSizeDampFactor= 0.5f;
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])) {
        
        id val;
        
        val = dict[@"maxKeywordCount"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _maxKeywordCount = [val unsignedIntegerValue];
        }
        
        val = dict[@"idealSentenceSize"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _idealSentenceSize = [val unsignedIntegerValue];
        }
        
        val = dict[@"minKeywordSize"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _minKeywordSize = [val unsignedIntegerValue];
        }
        
        val = dict[@"partOfSpeechUnknownScore"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _partOfSpeechUnknownScore = [val floatValue];
        }
        
        val = dict[@"partOfSpeechOtherScore"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _partOfSpeechOtherScore = [val floatValue];
        }
        
        val = dict[@"partOfSpeechAdjectiveScore"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _partOfSpeechAdjectiveScore = [val floatValue];
        }
        
        val = dict[@"partOfSpeechAdverbScore"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _partOfSpeechAdverbScore = [val floatValue];
        }
        
        val = dict[@"partOfSpeechVerbScore"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _partOfSpeechVerbScore = [val floatValue];
        }
        
        val = dict[@"partOfSpeechNounScore"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _partOfSpeechNounScore = [val floatValue];
        }
        
        val = dict[@"partOfSpeechNameScore"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _partOfSpeechNameScore = [val floatValue];
        }
        
        val = dict[@"partOfSpeechNumberScore"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _partOfSpeechNumberScore = [val floatValue];
        }
                
        val = dict[@"plotProgress"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _plotProgress = [val floatValue];
        }
        
        val = dict[@"middleProgress"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _middleProgress = [val floatValue];
        }
        
        val = dict[@"finalProgress"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _finalProgress = [val floatValue];
        }
        
        val = dict[@"introScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _introScoreFactor = [val floatValue];
        }
        
        val = dict[@"plotScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _plotScoreFactor = [val floatValue];
        }
        
        val = dict[@"middleScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _middleScoreFactor = [val floatValue];
        }
        
        val = dict[@"finalScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _finalScoreFactor = [val floatValue];
        }
        
        val = dict[@"firstEntryScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _firstEntryScoreFactor = [val floatValue];
        }
                
        val = dict[@"uppercaseScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _uppercaseScoreFactor = [val floatValue];
        }
        
        val = dict[@"keywordScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _keywordScoreFactor = [val floatValue];
        }
        
        val = dict[@"summationBasedScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _summationBasedScoreFactor = [val floatValue];
        }
        
        val = dict[@"densityBasedScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _densityBasedScoreFactor = [val floatValue];
        }
        
        val = dict[@"extraScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _extraScoreFactor = [val floatValue];
        }
        
        val = dict[@"firstLineScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _firstLineScoreFactor = [val floatValue];
        }
        
        val = dict[@"lastLineScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _lastLineScoreFactor = [val floatValue];
        }
        
        val = dict[@"leadingDashScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _leadingDashScoreFactor = [val floatValue];
        }
        
        val = dict[@"leadingQuoteScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _leadingQuoteScoreFactor = [val floatValue];
        }
        
        val = dict[@"exclamationScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _exclamationScoreFactor = [val floatValue];
        }
        
        val = dict[@"questionScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _questionScoreFactor = [val floatValue];
        }
        
        val = dict[@"colonScoreFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _colonScoreFactor = [val floatValue];
        }
        
        val = dict[@"adjacentKeywordsFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _adjacentKeywordsFactor = [val floatValue];
        }
        
        val = dict[@"idealSentenceSizeDampFactor"];
        if ([val isKindOfClass:[NSNumber class]]) {
            _idealSentenceSizeDampFactor = [val floatValue];
        }
    }
    return self;
}

- (NSDictionary *) asDictionary
{
    return @{
             @"maxKeywordCount"             : @(_maxKeywordCount),
             @"idealSentenceSize"           : @(_idealSentenceSize),
             @"minKeywordSize"              : @(_minKeywordSize),
             
             @"partOfSpeechUnknownScore"    : @(_partOfSpeechUnknownScore),
             @"partOfSpeechOtherScore"      : @(_partOfSpeechOtherScore),
             @"partOfSpeechAdjectiveScore"  : @(_partOfSpeechAdjectiveScore),
             @"partOfSpeechAdverbScore"     : @(_partOfSpeechAdverbScore),
             @"partOfSpeechVerbScore"       : @(_partOfSpeechVerbScore),
             @"partOfSpeechNounScore"       : @(_partOfSpeechNounScore),
             @"partOfSpeechNameScore"       : @(_partOfSpeechNameScore),
             @"partOfSpeechNumberScore"     : @(_partOfSpeechNumberScore),
             
             @"plotProgress"                : @(_plotProgress),
             @"middleProgress"              : @(_middleProgress),
             @"finalProgress"               : @(_finalProgress),
             
             @"introScoreFactor"            : @(_introScoreFactor),
             @"plotScoreFactor"             : @(_plotScoreFactor),
             @"middleScoreFactor"           : @(_middleScoreFactor),
             @"finalScoreFactor"            : @(_finalScoreFactor),
             
             @"firstEntryScoreFactor"       : @(_firstEntryScoreFactor),
             @"uppercaseScoreFactor"        : @(_uppercaseScoreFactor),
             
             @"keywordScoreFactor"          : @(_keywordScoreFactor),
             @"summationBasedScoreFactor"   : @(_summationBasedScoreFactor),
             @"densityBasedScoreFactor"     : @(_densityBasedScoreFactor),
             @"extraScoreFactor"            : @(_extraScoreFactor),
             
             @"firstLineScoreFactor"        : @(_firstLineScoreFactor),
             @"lastLineScoreFactor"         : @(_lastLineScoreFactor),
             @"leadingDashScoreFactor"      : @(_leadingDashScoreFactor),
             @"leadingQuoteScoreFactor"     : @(_leadingQuoteScoreFactor),
             @"exclamationScoreFactor"      : @(_exclamationScoreFactor),
             @"questionScoreFactor"         : @(_questionScoreFactor),
             @"colonScoreFactor"            : @(_colonScoreFactor),
             
             @"adjacentKeywordsFactor"      : @(_adjacentKeywordsFactor),
             @"idealSentenceSizeDampFactor" : @(_idealSentenceSizeDampFactor),
             };
}

@end
