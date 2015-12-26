//
//  KxSummarizerKeyword.m
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

#import "KxSummarizerKeyword.h"
#import "KxSummarizerParams.h"

//////////

static inline KxSummarizerPartOfSpeech partOfSpeechFromLinguisticTag(NSString *tag);

//////////

@interface KxSummarizerKeyword()
@property (readwrite, nonatomic) NSUInteger count;
@property (readwrite, nonatomic, strong) NSString *key;
@property (readwrite, nonatomic) KxSummarizerPartOfSpeech partOfSpeech;
@property (readwrite, nonatomic) float score;
@property (readwrite, nonatomic) float extraFactor;
@property (readwrite, nonatomic) BOOL occurred;
@property (readwrite, nonatomic) BOOL off;
@end

@implementation KxSummarizerKeyword

- (NSString *) description
{
    return [NSString stringWithFormat:@"%u(%.3f): %@(%@)",
            (unsigned)_count, _score, _key, NSStringFromSummarizerPartOfSpeech(_partOfSpeech)];
}

- (NSComparisonResult) compareByScore:(KxSummarizerKeyword *)other
{
    // in reverse order
    if (self.score < other.score) {
        return NSOrderedDescending;
    } else if (self.score > other.score) {
        return NSOrderedAscending;
    }
    return NSOrderedSame;
}

- (NSString *) partOfSpeechName
{
    return NSStringFromSummarizerPartOfSpeech(_partOfSpeech);
}

@end

//////////

@interface KxSummarizerWord()
@property (readwrite, nonatomic, strong) KxSummarizerKeyword *keyword;
@property (readwrite, nonatomic) NSUInteger index;
@property (readwrite, nonatomic) BOOL isUppercase;
@end

@implementation KxSummarizerWord

+ (NSArray *) buildWords:(NSString *)text
                  params:(KxSummarizerParams *)params
               stopwords:(NSSet *)stopwords
                 ltagger:(NSLinguisticTagger *)ltagger
                keywords:(NSMutableDictionary *)keywords
              totalCount:(NSUInteger *)totalCount
{
    NSMutableArray *words = [NSMutableArray array];
    const NSUInteger minSize = params.minKeywordSize;
    NSCharacterSet *uppercaseLetters = [NSCharacterSet uppercaseLetterCharacterSet];
    NSCharacterSet *lowercaseLetters = [NSCharacterSet lowercaseLetterCharacterSet];
    __block NSUInteger index = 0;
    
    ltagger.string = text;
    [ltagger enumerateTagsInRange:NSMakeRange(0, text.length)
                           scheme:NSLinguisticTagSchemeTokenType
                          options:NSLinguisticTaggerOmitWhitespace|NSLinguisticTaggerOmitOther|NSLinguisticTaggerOmitPunctuation
                       usingBlock:^(NSString * tag,
                                    NSRange tokenRange,
                                    NSRange sentenceRange,
                                    BOOL *stop)
     {
         if (tag.length > minSize &&
             [tag isEqualToString:NSLinguisticTagWord])
         {
             NSString *word = [text substringWithRange:tokenRange];
             
             NSString *lemma = [ltagger tagAtIndex:tokenRange.location
                                            scheme:NSLinguisticTagSchemeLemma
                                        tokenRange:NULL
                                     sentenceRange:NULL];
             
             NSString *key = (lemma ?: word).lowercaseString;
             
             if ([stopwords containsObject:key]) {
                 return; // skip stopword
             }
             
             KxSummarizerKeyword *keyword = keywords[key];
             if (keyword) {
                 
                 keyword.count += 1;
                 
             } else {
                 
                 // setup new keyword
                 
                 NSString *tag = [ltagger tagAtIndex:tokenRange.location
                                              scheme:NSLinguisticTagSchemeLexicalClass
                                          tokenRange:NULL
                                       sentenceRange:NULL];
                 
                 KxSummarizerPartOfSpeech partOfSpeech = partOfSpeechFromLinguisticTag(tag);
                 
                 if (partOfSpeech == KxSummarizerPartOfSpeechUnknown) {
                     return; // skip word
                 }
                 
                 if (partOfSpeech == KxSummarizerPartOfSpeechNoun ||
                     partOfSpeech == KxSummarizerPartOfSpeechOther) {
                     
                     NSString *tag = [ltagger tagAtIndex:tokenRange.location
                                                  scheme:NSLinguisticTagSchemeNameType
                                              tokenRange:NULL
                                           sentenceRange:NULL];
                     
                     if ([tag isEqualToString:NSLinguisticTagPersonalName] ||
                         [tag isEqualToString:NSLinguisticTagPlaceName] ||
                         [tag isEqualToString:NSLinguisticTagOrganizationName])
                     {
                         partOfSpeech = KxSummarizerPartOfSpeechName;
                         
                     } else if (index > 0) {
                         
                         const unichar letter = [word characterAtIndex:0];
                         const BOOL isCapitalLetter = [uppercaseLetters characterIsMember:letter];
                         if (isCapitalLetter) {
                             partOfSpeech = KxSummarizerPartOfSpeechName;
                         }
                     }
                 }
                 
                 keyword = [KxSummarizerKeyword new];
                 keyword.key = key;
                 keyword.partOfSpeech = partOfSpeech;
                 keyword.count = 1;
                 keywords[key] = keyword;
             }
             
             // add word
             KxSummarizerWord *p = [KxSummarizerWord new];
             p.keyword = keyword;
             p.index = index;
             p.isUppercase = (NSNotFound == [word rangeOfCharacterFromSet:lowercaseLetters].location);
             
             [words addObject:p];
         }
         
         index += 1;
     }];
    
    if (totalCount) {
        *totalCount = index;
    }
    
    return words;
}

@end

#pragma mark - utils

static inline KxSummarizerPartOfSpeech partOfSpeechFromLinguisticTag(NSString *tag)
{
    if ([tag isEqualToString:NSLinguisticTagOtherWord]) {
        return KxSummarizerPartOfSpeechOther;
    } else if ([tag isEqualToString:NSLinguisticTagAdjective]) {
        return KxSummarizerPartOfSpeechAdjective;
    } else if ([tag isEqualToString:NSLinguisticTagAdverb]) {
        return KxSummarizerPartOfSpeechAdverb;
    } else if ([tag isEqualToString:NSLinguisticTagVerb]) {
        return KxSummarizerPartOfSpeechVerb;
    } else if ([tag isEqualToString:NSLinguisticTagNoun]) {
        return KxSummarizerPartOfSpeechNoun;
    } else if ([tag isEqualToString:NSLinguisticTagClassifier]) {
        return KxSummarizerPartOfSpeechName;
    } else if ([tag isEqualToString:NSLinguisticTagNumber]) {
        return KxSummarizerPartOfSpeechNumber;
    } else {
        return KxSummarizerPartOfSpeechUnknown;
    }
}

NSString *NSStringFromSummarizerPartOfSpeech(KxSummarizerPartOfSpeech partOfSpeech)
{
    switch (partOfSpeech) {
        case KxSummarizerPartOfSpeechUnknown:   return @"unk";
        case KxSummarizerPartOfSpeechOther:     return @"other";
        case KxSummarizerPartOfSpeechAdjective: return @"adj";
        case KxSummarizerPartOfSpeechAdverb:    return @"adv";
        case KxSummarizerPartOfSpeechVerb:      return @"verb";
        case KxSummarizerPartOfSpeechNoun:      return @"noun";
        case KxSummarizerPartOfSpeechName:      return @"name";
        case KxSummarizerPartOfSpeechNumber:    return @"num";
    }
}