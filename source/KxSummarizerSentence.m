//
//  KxSummarizerSentence.m
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

#import "KxSummarizerSentence.h"
#import "KxSummarizerParams.h"
#import "KxSummarizerKeyword.h"

//////////

static inline BOOL containsStringInStrings(NSString *string, NSArray *array);
static inline BOOL containsStringInSentences(NSString *string, NSArray *array);
static inline BOOL characterIsDashSymbol(unichar ch);
static inline BOOL characterIsQuoteSymbol(unichar ch);
static inline KxSummarizerSentenceFlags sentencesFlagsForString(NSString *string);

//////////

@interface KxSummarizerSentence()
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

@implementation KxSummarizerSentence

+ (NSArray *) buildSentences:(NSString *)text
                       range:(NSRange)range
                      params:(KxSummarizerParams *)params
                   stopwords:(NSSet *)stopwords
                    excluded:(NSArray *)excluded
                     ltagger:(NSLinguisticTagger *)ltagger
                    keywords:(NSMutableDictionary *)keywords

{
    const NSUInteger minSize = params.minKeywordSize;
    const float textLen = (float)text.length;;
    NSCharacterSet *whites = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSMutableArray *sentences = [NSMutableArray array];
    __block NSUInteger index = 0;
    
    [text enumerateSubstringsInRange:range
                             options:NSStringEnumerationBySentences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop)
     {         
         substring = [substring stringByTrimmingCharactersInSet:whites];
         
         if (substringRange.length <= minSize ||
             (excluded.count && containsStringInStrings(substring, excluded)) ||
             (sentences.count && containsStringInSentences(substring, sentences)))
         {
             return; // skip
         }
         
         NSUInteger totalCount = 0;
         NSArray *words = [KxSummarizerWord buildWords:substring
                                                params:params
                                             stopwords:stopwords
                                               ltagger:ltagger
                                              keywords:keywords
                                            totalCount:&totalCount];
         if (words.count) {
             
             KxSummarizerSentence *sentence = [KxSummarizerSentence new];
             sentence.index = index;
             sentence.range = substringRange;
             sentence.string = substring;
             sentence.words = words;
             sentence.totalCount = totalCount;
             sentence.progress = (float)substringRange.location / textLen;
             sentence.flags = sentencesFlagsForString(substring);
             [sentences addObject:sentence];
         }
         
         index += 1;
     }];
    
    if (sentences.count > 0) {
        KxSummarizerSentence *first = sentences.firstObject;
        first.flags |= KxSummarizerSentenceFlagFirst;
        KxSummarizerSentence *last = sentences.lastObject;
        last.flags |= KxSummarizerSentenceFlagLast;
    }
        
    return sentences;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"%u:%u(%.3f): %@",
            (unsigned)_textNo, (unsigned)_index, _score, _string];
}

- (NSComparisonResult) compareByScore:(KxSummarizerSentence *)other
{
    // reverse
    if (self.score < other.score) {
        return NSOrderedDescending;
    } else if (self.score > other.score) {
        return NSOrderedAscending;
    }
    return NSOrderedSame;
}

- (NSComparisonResult) compareByLocation:(KxSummarizerSentence *)other
{
    if (self.textNo < other.textNo) {
        return NSOrderedAscending;
    } else if (self.textNo > other.textNo) {
        return NSOrderedDescending;
    } else if (self.range.location < other.range.location) {
        return NSOrderedAscending;
    } else if (self.range.location > other.range.location) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

@end

#pragma mark - utils

static inline BOOL containsStringInStrings(NSString *string, NSArray *array)
{
    for (NSString *p in array) {
        
        if (NSOrderedSame == [p compare:string
                                options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch])
        {
            return YES;
        }
    }
    
    return NO;
}

static inline BOOL containsStringInSentences(NSString *string, NSArray *array)
{
    for (KxSummarizerSentence *p in array) {
        
        if (NSOrderedSame == [p.string compare:string
                                       options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch])
        {
            return YES;
        }
    }
    
    return NO;
}

static inline BOOL characterIsDashSymbol(unichar ch)
{
    return (ch == 0x002D || // hyphen-minus
            ch == 0x007E || // tilde
            ch == 0x058A || // armenian hyphen
            ch == 0x05BE || // hebrew punctuation maqaf
            ch == 0x1400 || // canadian syllabics hyphen
            ch == 0x1806 || // mongolian todo soft hyphen
            ch == 0x2010 || // hyphen
            ch == 0x2011 || // non-breaking hyphen
            ch == 0x2012 || // figure dash
            ch == 0x2013 || // en dash
            ch == 0x2014 || // em dash
            ch == 0x2015 || // horizontal bar
            ch == 0x2053 || // swung dash
            ch == 0x207B || // superscript minus
            ch == 0x208B || // subscript minus
            ch == 0x2212 || // minus sign
            ch == 0x2E17 || // double oblique hyphen
            ch == 0x2E3A || // two-em dash
            ch == 0x2E3B || // hree-em dash
            ch == 0x301C || // wave dash
            ch == 0x3030 || // wavy dash
            ch == 0x30A0 );  // katakana-hiragana double hyphen
}

static inline BOOL characterIsQuoteSymbol(unichar ch)
{
    return (ch == 0x0022 || // quotation mark
            ch == 0x0027 || // apostrophe
            ch == 0x00AB || // left-pointing double angle quotation mark
            ch == 0x00BB || // right-pointing double angle quotation mark
            ch == 0x0060 || // grave accent
            ch == 0x00B4 || // acute accent
            ch == 0x2018 || // left single quotation mark
            ch == 0x2019 || // right single quotation mark
            ch == 0x201A || // single low-9 quotation mark
            ch == 0x201B || // ingle high-reversed-9 quotation mark
            ch == 0x201C || // left double quotation mark
            ch == 0x201D || // right double quotation mark
            ch == 0x201E || // double low-9 quotation mark
            ch == 0x201F || // double high-reversed-9 quotation mark
            ch == 0x201E || // double low-9 quotation mark
            ch == 0x201F || // double high-reversed-9 quotation mark
            ch == 0x2039 || // single left-pointing angle quotation mark
            ch == 0x203A || // single right-pointing angle quotation mark
            ch == 0x300C || // left corner bracket
            ch == 0x300D || // right corner bracket
            ch == 0x300E || // left white corner bracket
            ch == 0x300F || // right white corner bracket
            ch == 0x301D || // reversed double prime quotation mark
            ch == 0x301E || // double prime quotation mark
            ch == 0x301F ); // low double prime quotation mark
}

static inline KxSummarizerSentenceFlags sentencesFlagsForString(NSString *string)
{
    KxSummarizerSentenceFlags flags = KxSummarizerSentenceFlagNone;
    
    const unichar headLetter = [string characterAtIndex:0];
    const unichar termLetter = [string characterAtIndex:string.length - 1];
    
    if (characterIsDashSymbol(headLetter)) {
        flags = KxSummarizerSentenceFlagLeadingDash;
    } else if (characterIsQuoteSymbol(headLetter)) {
        flags = KxSummarizerSentenceFlagLeadingQuote;
    }
    
    if (termLetter == '!') {
        flags |= KxSummarizerSentenceFlagExclamation;
    } else if (termLetter == '?') {
        flags |= KxSummarizerSentenceFlagQuestion;
    } else if (termLetter == ':') {
        flags |= KxSummarizerSentenceFlagColon;
    }
    
    return flags;
}
