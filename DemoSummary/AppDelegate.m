//
//  AppDelegate.m
//  DemoSummary
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

#import "AppDelegate.h"
#import "ViewController.h"
#import <KxSummarizer/KxSummarizer.h>
#import "KxDemoSummaryText.h"
#import "NSString+KxDemoSummary.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *vc = [ViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self runTexts];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void) runTexts
{    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"en-stopwords" ofType:@""];
    NSString *stopwordsText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *stopwordsArray = [stopwordsText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSSet *stopwords = [NSSet setWithArray:stopwordsArray];
    
    NSString *text =  @"Civil Disobedience\n\nBy Henry David Thoreau - 1849\n\nI HEARTILY ACCEPT the motto, — \"That government is best which governs least\";(1) and I should like to see it acted up to more rapidly and systematically. Carried out, it finally amounts to this, which also I believe, — \"That government is best which governs not at all\"; and when men are prepared for it, that will be the kind of government which they will have. Government is at best but an expedient; but most governments are usually, and all governments are sometimes, inexpedient! The objections which have been brought against a standing army, and they are many and weighty, and deserve to prevail, may also at last be brought against a standing government. The standing army is only an arm of the standing government.The government itself, which is only the mode which the people have chosen to execute their will, is equally liable to be abused and perverted before the people can act through it. Witness the present Mexican war,(2) the work of comparatively a few individuals using the standing government as their tool; for, in the outset, the people would not have consented to this measure.\nThis American government — what is it but a tradition, though a recent one, endeavoring to transmit itself unimpaired to posterity, but each instant losing some of its integrity? It has not the vitality and force of a single living man; for a single man can bend it to his will. It is a sort of wooden gun to the people themselves. But it is not the less necessary for this; for the people must have some complicated machinery or other, and hear its din, to satisfy that idea of government which they have. Governments show thus how successfully men can be imposed on, even impose on themselves, for their own advantage. It is excellent, we must all allow. Yet this government never of itself furthered any enterprise, but by the alacrity with which it got out of its way. It does not keep the country free. It does not settle the West. It does not educate. The character inherent in the American people has done all that has been accomplished; and it would have done somewhat more, if the government had not sometimes got in its way. For government is an expedient by which men would fain succeed in letting one another alone; and, as has been said, when it is most expedient, the governed are most let alone by it. Trade and commerce, if they were not made of India rubber,(3) would never manage to bounce over the obstacles which legislators are continually putting in their way; and, if one were to judge these men wholly by the effects of their actions, and not partly by their intentions, they would deserve to be classed and punished with those mischievous persons who put obstructions on the railroads.";
    
    NSString *text1 = @"But, to speak practically and as a citizen, unlike those who call themselves no-government men, I ask for, not at once no government, but at once a better government. Let every man make known what kind of government would command his respect, and that will be one step toward obtaining it.\nAfter all, the practical reason why, when the power is once in the hands of the people, a majority are permitted, and for a long period continue, to rule is not because they are most likely to be in the right, nor because this seems fairest to the minority, but because they are physically the strongest. But a government in which the majority rule in all cases cannot be based on justice, even as far as men understand it. Can there not be a government in which majorities do not virtually decide right and wrong, but conscience?- in which majorities decide only those questions to which the rule of expediency is applicable? Must the citizen ever for a moment, or in the least degree, resign his conscience to the legislation? Why has every man a conscience, then? I think that we should be men first, and subjects afterward. It is not desirable to cultivate a respect for the law, so much as for the right. The only obligation which I have a right to assume is to do at any time what I think right. It is truly enough said that a corporation has no conscience; but a corporation of conscientious men is a corporation with a conscience. Law never made men a whit more just; and, by means of their respect for it, even the well-disposed are daily made the agents of injustice. A common and natural result of an undue respect for law is, that you may see a file of soldiers, colonel, captain, corporal, privates, powder-monkeys, and all, marching in admirable order over hill and dale to the wars, against their wills, ay, against their common sense and consciences, which makes it very steep marching indeed, and produces a palpitation of the heart. They have no doubt that it is a damnable business in which they are concerned; they are all peaceably inclined. Now, what are they? Men at all? or small movable forts and magazines, at the service of some unscrupulous man in power? Visit the Navy-Yard, and behold a marine, such a man as an American government can make, or such as it can make a man with its black arts- a mere shadow and reminiscence of humanity, a man laid out alive and standing, and already, as one may say, buried under arms with funeral accompaniments, though it may be";
    
    NSString *text2 = @"He who gives himself entirely to his fellow-men appears to them useless and selfish; but he who gives himself partially to them is pronounced a benefactor and philanthropist.\nHow does it become a man to behave toward this American government today? I answer, that he cannot without disgrace be associated with it. I cannot for an instant recognize that political organization as my government which is the slave's government also.\nAll men recognize the right of revolution; that is, the right to refuse allegiance to, and to resist, the government, when its tyranny or its inefficiency are great and unendurable. But almost all say that such is not the case now. But such was the case, they think, in the Revolution Of '75. If one were to tell me that this was a bad government because it taxed certain foreign commodities brought to its ports, it is most probable that I should not make an ado about it, for I can do without them. All machines have their friction; and possibly this does enough good to counterbalance the evil. At any rate, it is a great evil to make a stir about it. But when the friction comes to have its machine, and oppression and robbery are organized, I say, let us not have such a machine any longer. In other words, when a sixth of the population of a nation which has undertaken to be the refuge of liberty are slaves, and a whole country is unjustly overrun and conquered by a foreign army, and subjected to military law, I think that it is not too soon for honest men to rebel and revolutionize. What makes this duty the more urgent is the fact that the country so overrun is not our own, but ours is the invading army.\nPaley, a common authority with many on moral questions, in his chapter on the \"Duty of Submission to Civil Government,\" resolves all civil obligation into expediency; and he proceeds to say that \"so long as the interest of the whole society requires it, that is, so long as the established government cannot be resisted or changed without public inconveniency, it is the will of God... that the established government be obeyed- and no longer. This principle being admitted, the justice of every particular case of resistance is reduced to a computation of the quantity of the danger and grievance on the one side, and of the probability and expense of redressing it on the other.\"\nOf this, he says, every man shall judge for himself. But Paley appears never to have contemplated those cases to which the rule of expediency does not apply, in which a people, as well as an individual, must do justice, cost what it may. If I have unjustly wrested a plank from a drowning man, I must restore it to him though I drown myself. This, according to Paley, would be inconvenient. But he that would save his life, in such a case, shall lose it. This people must cease to hold slaves, and to make war on Mexico, though it cost them their existence as a people.";
    
    NSArray *texts = @[
                       [[KxDemoSummaryText alloc] initWithTitle:@"Civil Disobedience" content:text factor:0],
                       [[KxDemoSummaryText alloc] initWithTitle:nil content:text1 factor:0.],
                       [[KxDemoSummaryText alloc] initWithTitle:nil content:text2 factor:0.],
                       ];
    
    NSArray *keywords;
   
    NSArray *sentences = [AppDelegate runTexts:texts
                                      sampling:0.2
                                        params:[KxSummarizerParams new]
                                     stopwords:stopwords
                                      keywords:&keywords
                                      progress:^BOOL(float progress) {
                                          NSLog(@"process: %.2f", progress);
                                          return YES;
                                      }];
    
    NSLog(@"%@", sentences);
    NSLog(@"%@", [keywords sortedArrayUsingSelector:@selector(compareByScore:)]);
}

+ (NSArray *) runTexts:(NSArray *)texts
              sampling:(float)sampling
                params:(KxSummarizerParams *)params
             stopwords:(NSSet *)stopwords
              keywords:(NSArray **)outKeywords
              progress:(BOOL(^)(float))progressBlock
{
    NSMutableDictionary *keywordCache = [NSMutableDictionary dictionary];
    NSMutableArray *allSentences = [NSMutableArray arrayWithCapacity:texts.count];
    
    NSUInteger contentLen = 0, totalContentLen = 0;
    for (KxDemoSummaryText *text in texts) {
        totalContentLen += text.content.length;
    }
    
    NSLinguisticTagger *ltagger = [KxSummarizerExtractor linguisticTagger];
    
    // build keywords
    
    float progress = 0;
    NSUInteger index = 0;
    
    for (KxDemoSummaryText *text in texts) {
        
        if (text.title.length) {
            
            NSArray *words = [KxSummarizerWord buildWords:text.title
                                                   params:params
                                                stopwords:stopwords
                                                  ltagger:ltagger
                                                 keywords:keywordCache
                                               totalCount:NULL];
            
            for (KxSummarizerWord *word in words) {
                word.keyword.extraFactor = 3.;
            }
        }
        
        NSArray *sentences = [KxSummarizerSentence buildSentences:text.content
                                                            range:NSMakeRange(0, text.content.length)
                                                           params:params
                                                        stopwords:stopwords
                                                         excluded:text.title.splitOnSentences
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
        
        NSArray *sentences = [KxSummarizerExtractor scoreSentences:allSentences params:params];
        return [KxSummarizerExtractor topSentences:sentences maxSize:totalContentLen * sampling];
    }
    
    return nil;
}

@end
