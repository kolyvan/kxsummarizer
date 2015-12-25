//
//  KxSummarizerExtractor.m
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


#import "KxSummarizerExtractor.h"
#import "KxSummarizerConf.h"
#import "KxSummarizerParams.h"
#import "KxSummarizerKeyword.h"
#import "KxSummarizerSentence.h"
#import "KxSummarizerText.h"
#import "NSString+KxSummarizer.h"

//////////

static inline float partOfSpeechScore(KxSummarizerPartOfSpeech, KxSummarizerParams *);
static inline float scoreFactorOfSentencePosition(KxSummarizerSentence *, KxSummarizerParams *);
static inline float scoreFactorOfSentenceLength(KxSummarizerSentence *, KxSummarizerParams *);
static inline float scoreFactorOfSentenceFlags(KxSummarizerSentence *, KxSummarizerParams *);
static inline float scoreOfAdjacentKeywords(KxSummarizerSentence *, KxSummarizerSentence *, KxSummarizerSentence *);
static inline float scoreOfKeywords(KxSummarizerSentence *, KxSummarizerParams *);

//////////

@interface KxSummarizerKeyword()
@property (readwrite, nonatomic) NSUInteger count;
@property (readwrite, nonatomic) float score;
@property (readwrite, nonatomic) float extraFactor;
@property (readwrite, nonatomic) BOOL occurred;
@property (readwrite, nonatomic) BOOL off;
@end

@interface KxSummarizerSentence()
@property (readwrite, nonatomic) NSUInteger textNo;
@property (readwrite, nonatomic) float progress;
@property (readwrite, nonatomic) float score;
@end

//////////

@implementation KxSummarizerExtractor

+ (NSArray *) runText:(NSString *)text
               config:(KxSummarizerConf *)config
             keywords:(NSArray **)keywords
{
    return [self runText:text
                   range:NSMakeRange(0, text.length)
                  config:config
                keywords:keywords];
}

+ (NSArray *) runText:(NSString *)text
                range:(NSRange)range
               config:(KxSummarizerConf *)config
             keywords:(NSArray **)outKeywords
{
    KxSummarizerParams *params = config.params;
    NSMutableDictionary *keywordCache = [NSMutableDictionary dictionary];
    
    NSArray *sentences = [KxSummarizerSentence buildSentences:text
                                                        range:range
                                                       config:config
                                                     excluded:nil
                                                      ltagger:self.linguisticTagger
                                                     keywords:keywordCache];
    
    if (sentences.count) {
        
        NSArray *keywords = [KxSummarizerExtractor scoreKeywords:keywordCache.allValues params:params];
        if (outKeywords) {
            *outKeywords = keywords;
        }
        
        [KxSummarizerExtractor scoreSentences:sentences params:params];
        return [KxSummarizerExtractor topSentences:sentences
                                            params:params
                                           maxSize:text.length * config.sampling];
    }
    
    return nil;
}

+ (NSArray *) runTexts:(NSArray *)texts
                config:(KxSummarizerConf *)config
              keywords:(NSArray **)outKeywords
              progress:(BOOL(^)(float))progressBlock
{
    KxSummarizerParams *params = config.params;
    NSMutableDictionary *keywordCache = [NSMutableDictionary dictionary];
    NSMutableArray *allSentences = [NSMutableArray arrayWithCapacity:texts.count];
    
    NSUInteger contentLen = 0, totalContentLen = 0;
    for (KxSummarizerText *text in texts) {
        totalContentLen += text.content.length;
    }
    
    NSLinguisticTagger *ltagger = self.linguisticTagger;
    
    // build keywords
    
    float progress = 0;
    NSUInteger index = 0;
    
    for (KxSummarizerText *text in texts) {
        
        if (text.title.length) {
            
            NSArray *words = [KxSummarizerWord buildWords:text.title
                                                   config:config
                                                  ltagger:ltagger
                                                 keywords:keywordCache
                                               totalCount:NULL];
            
            for (KxSummarizerWord *word in words) {
                word.keyword.extraFactor = 3.;
            }
        }
        
        NSArray *sentences = [KxSummarizerSentence buildSentences:text.content
                                                            range:NSMakeRange(0, text.content.length)
                                                           config:config
                                                         excluded:text.title.summarizer_splitOnSentences
                                                          ltagger:ltagger
                                                         keywords:keywordCache];
        
        const float progress0 = progress;
        contentLen += text.content.length;
        progress = (float)contentLen / (float)totalContentLen;
        
        for (KxSummarizerSentence *sentence in sentences) {
            
            sentence.textNo = index;
            sentence.progress = progress0 + (progress - progress0) * sentence.progress;
            
            if (text.factor) {
                for (KxSummarizerWord *word in sentence.words) {
                    word.keyword.extraFactor = text.factor;
                }
            }
        }
        
        [allSentences addObjectsFromArray:sentences];
        
        if (progressBlock &&
            !progressBlock(progress))
        {
            return nil;
        }
        
        index += 1;
    }
    
    // summarize
    
    if (allSentences.count) {
        
        NSArray *keywords = [KxSummarizerExtractor scoreKeywords:keywordCache.allValues params:params];
        if (outKeywords) {
            *outKeywords = keywords;
        }
        
        [KxSummarizerExtractor scoreSentences:allSentences params:params];
        return [KxSummarizerExtractor topSentences:allSentences
                                            params:params
                                           maxSize:totalContentLen * config.sampling];
    }
    
    return nil;
}

#pragma mark - private

+ (NSLinguisticTagger *) linguisticTagger
{    
    const NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace|NSLinguisticTaggerOmitOther|NSLinguisticTaggerOmitPunctuation;
    
    NSArray *tagSchemes = @[NSLinguisticTagSchemeLemma,
                            NSLinguisticTagSchemeLexicalClass,
                            NSLinguisticTagSchemeNameType,
                            NSLinguisticTagSchemeTokenType];
    
    return [[NSLinguisticTagger alloc] initWithTagSchemes:tagSchemes options:options];
}

+ (NSArray *) scoreKeywords:(NSArray *)keywords
                     params:(KxSummarizerParams *)params
{
    NSUInteger keywordCount = keywords.count;
    for (KxSummarizerKeyword *kw in keywords) {
        if (!kw.off) {
            keywordCount += kw.count;
        }
    }
    
    const float keywordFactor = MIN(1.0f, params.keywordScoreFactor / (float)keywordCount);
    
    for (KxSummarizerKeyword *kw in keywords) {
        
        const float partOfSpeehScore = partOfSpeechScore(kw.partOfSpeech, params);
        kw.score = partOfSpeehScore * kw.count * keywordFactor;
    }
    
    const NSUInteger maxCount = params.maxKeywordCount;
    
    if (maxCount &&
        keywords.count > maxCount) {
        
        keywords = [keywords sortedArrayUsingSelector:@selector(compareByScore:)];
        
        for (NSUInteger i = maxCount; i < keywords.count; ++i) {
            ((KxSummarizerKeyword *)keywords[i]).off = YES;
        }
        
        keywords = [keywords subarrayWithRange:NSMakeRange(0, maxCount)];
    }
    
    return keywords;
}

+ (void) scoreSentences:(NSArray *)sentences
                 params:(KxSummarizerParams *)params
{
    const BOOL doAdjacent = params.adjacentKeywordsFactor > 0 && sentences.count > 1;
    
    NSUInteger i = 0;
    KxSummarizerSentence *prev;
    
    for (KxSummarizerSentence *sentence in sentences) {
        
        const float keywordsScore = scoreOfKeywords(sentence, params);
        
        float adjacentScore = 0;
        if (doAdjacent) {
            
            KxSummarizerSentence *next = (i + 1) < sentences.count ? sentences[i + 1] : nil;
            adjacentScore = scoreOfAdjacentKeywords(prev, sentence, next);
            adjacentScore *= params.adjacentKeywordsFactor;
        }
        
        const float posFactor  = scoreFactorOfSentencePosition(sentence, params);
        const float lenFactor  = scoreFactorOfSentenceLength(sentence, params);
        const float flagFactor = scoreFactorOfSentenceFlags(sentence, params);
        
        sentence.score = (keywordsScore + adjacentScore) * posFactor * lenFactor * flagFactor;
        
        //NSLog(@"%u: %.2f=(%.2f+%.2f)*%.1f*%.1f*%.1f [%@]", (unsigned)i, sentence.score, keywordsScore, adjacentScore, posFactor, lenFactor, flagFactor, sentence.string);
        
        i += 1;
        prev = sentence;
    }
}

+ (NSArray *) topSentences:(NSArray *)sentences
                    params:(KxSummarizerParams *)params
                   maxSize:(NSUInteger)maxSize
{
    sentences = [sentences sortedArrayUsingSelector:@selector(compareByScore:)];
    
    NSUInteger size = 0;
    NSMutableArray *top = [NSMutableArray array];
    for (KxSummarizerSentence *sentence in sentences) {
        [top addObject:sentence];
        size += sentence.range.length;
        if (size > maxSize) {
            break;
        }
    }
    
    return top;
}
 
@end

#pragma mark - utils

static inline float partOfSpeechScore(KxSummarizerPartOfSpeech partOfSpeech,
                                      KxSummarizerParams *params)
{
    switch (partOfSpeech) {
        case KxSummarizerPartOfSpeechUnknown    : return params.partOfSpeechUnknownScore;
        case KxSummarizerPartOfSpeechOther      : return params.partOfSpeechOtherScore;
        case KxSummarizerPartOfSpeechAdjective  : return params.partOfSpeechAdjectiveScore;
        case KxSummarizerPartOfSpeechAdverb     : return params.partOfSpeechAdverbScore;
        case KxSummarizerPartOfSpeechVerb       : return params.partOfSpeechVerbScore;
        case KxSummarizerPartOfSpeechNoun       : return params.partOfSpeechNounScore;
        case KxSummarizerPartOfSpeechName       : return params.partOfSpeechNameScore;
        case KxSummarizerPartOfSpeechNumber     : return params.partOfSpeechNumberScore;
    }
}

static inline float scoreFactorOfSentencePosition(KxSummarizerSentence *sentence,
                                                  KxSummarizerParams *params)
{
    if (sentence.progress > params.finalProgress) {
        return params.finalScoreFactor;
    } else if (sentence.progress > params.middleProgress) {
        return params.middleScoreFactor;
    } else if (sentence.progress > params.plotProgress) {
        return params.plotScoreFactor;
    }
    return params.introScoreFactor;
}


static inline float scoreFactorOfSentenceLength(KxSummarizerSentence *sentence,
                                                KxSummarizerParams *params)
{
    if (params.idealSentenceSize &&  params.idealSentenceSizeDampFactor) {
        
        const float R = ABS((NSInteger)params.idealSentenceSize - (NSInteger)sentence.totalCount) / (float)params.idealSentenceSize;
        const float score = 1.0f - R  * params.idealSentenceSizeDampFactor;
        return MAX(0.2, score);
    }
    return 1.0f;
}

static inline float scoreFactorOfSentenceFlags(KxSummarizerSentence *sentence,
                                               KxSummarizerParams *params)
{
    float score = 1.;
    if (sentence.flags & KxSummarizerSentenceFlagFirst) {
        score *= params.firstLineScoreFactor;
    }
    if (sentence.flags & KxSummarizerSentenceFlagLast) {
        score *= params.lastLineScoreFactor;
    }
    if (sentence.flags & KxSummarizerSentenceFlagLeadingDash) {
        score *= params.leadingDashScoreFactor;
    }
    if (sentence.flags & KxSummarizerSentenceFlagLeadingQuote) {
        score *= params.leadingQuoteScoreFactor;
    }
    if (sentence.flags & KxSummarizerSentenceFlagExclamation) {
        score *= params.exclamationScoreFactor;
    }
    if (sentence.flags & KxSummarizerSentenceFlagQuestion) {
        score *= params.questionScoreFactor;
    }
    if (sentence.flags & KxSummarizerSentenceFlagColon) {
        score *= params.colonScoreFactor;
    }
    return score;
}

static inline float scoreOfAdjacentKeywords(KxSummarizerSentence *prev,
                                            KxSummarizerSentence *sentence,
                                            KxSummarizerSentence *next)
{
    float score = 0;
    for (KxSummarizerWord *w in sentence.words) {
        
        KxSummarizerKeyword *kw = w.keyword;
        if (!kw.off) {
            
            if (prev) {
                for (KxSummarizerWord *p in prev.words) {
                    if (kw == p.keyword) {
                        score += kw.score;
                    }
                }
            }
            
            if (next) {
                for (KxSummarizerWord *p in next.words) {
                    if (kw == p.keyword) {
                        score += kw.score;
                    }
                }
            }
        }
    }
    return score;
}

static inline float scoreOfKeywords(KxSummarizerSentence *sentence,
                                    KxSummarizerParams *params)

{
    float sbs   = 0; // summation based
    float dbs   = 0; // density based
    float extra = 0;
    float scorePrev = 0;
    
    NSUInteger indexPrev = NSNotFound;
    NSUInteger keywordsCount = 0;
    
    for (KxSummarizerWord *word in sentence.words) {
        
        KxSummarizerKeyword *kw = word.keyword;
        
        if (!kw.off) {
            
            ++keywordsCount;
            
            float sbsScore = kw.score;
            const float dbsScore = sbsScore;
            
            if (!kw.occurred) {
                kw.occurred = YES;
                sbsScore *= params.firstEntryScoreFactor;
            }
            
            if (word.isUppercase) {
                sbsScore *= params.uppercaseScoreFactor;
            }
            
            sbs += sbsScore;
            
            if (indexPrev != NSNotFound) {
                const NSUInteger density = word.index - indexPrev;
                dbs += (dbsScore * scorePrev) / (density * density);
            }
            
            indexPrev = word.index;
            scorePrev = dbsScore;
            
            // additional score from title/annotation
            if (kw.extraFactor && params.extraScoreFactor) {
                extra += (kw.score * kw.extraFactor);
            }
        }
    }
    
    extra *= params.extraScoreFactor;
    
    sbs *= ((float)keywordsCount / (float)sentence.totalCount);
    sbs *= params.summationBasedScoreFactor;
    
    const float K = (float)keywordsCount + 1.0f;
    dbs = ((1.0f / K * (K + 1.0f)) * dbs);
    dbs *= params.densityBasedScoreFactor;
    
    return (sbs + dbs + extra);
}
