//
//  ViewController.m
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

#import "ViewController.h"
#import <KxSummarizer/KxSummarizer.h>

@interface ViewController () <UITextViewDelegate>
@property (readonly, nonatomic, strong) UITextView *textView;
@property (readonly, nonatomic, strong) UITextView *summaryView;
@end

@implementation ViewController {
    
    NSString *_stopwordsName;
    NSString *_textName;
}

- (instancetype) init
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        
        self.title = @"Demo";
        
        if ([[NSLocale currentLocale].localeIdentifier hasPrefix:@"ru"]) {
            _stopwordsName = @"ru-stopwords";
            _textName = @"sample2-ru";
        } else {
            _stopwordsName = @"en-stopwords";
            _textName = @"sample";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textView = ({
        UITextView *v = [[UITextView alloc] initWithFrame:self.view.bounds];
        v.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        v.font = [UIFont systemFontOfSize:17.];
        v.autocorrectionType = UITextAutocorrectionTypeNo;
        v.autocapitalizationType = UITextAutocapitalizationTypeNone;
        v.spellCheckingType = UITextSpellCheckingTypeNo;
        v.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        v.textColor = [UIColor darkTextColor];
        v.backgroundColor = [UIColor whiteColor];
        v.opaque = YES;
        v.editable = YES;
        v.selectable = YES;
        v.dataDetectorTypes = UIDataDetectorTypeNone;
        v.showsHorizontalScrollIndicator = NO;
        v.delegate = self;
        v;
    });
    
    _summaryView = ({
        UITextView *v = [[UITextView alloc] initWithFrame:self.view.bounds];
        v.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        v.font = [UIFont systemFontOfSize:17.];
        v.autocorrectionType = UITextAutocorrectionTypeNo;
        v.autocapitalizationType = UITextAutocapitalizationTypeNone;
        v.spellCheckingType = UITextSpellCheckingTypeNo;
        v.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        v.textColor = [UIColor darkTextColor];
        v.backgroundColor = [UIColor whiteColor];
        v.opaque = YES;
        v.editable = NO;
        v.selectable = YES;
        v.dataDetectorTypes = UIDataDetectorTypeNone;
        v.showsHorizontalScrollIndicator = NO;
        v.hidden = YES;
        v;
    });
    
    [self.view addSubview:_textView];
    [self.view addSubview:_summaryView];
    
    [self updateRightBarButton];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _summaryView.contentInset = _textView.contentInset;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:_textName ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    _textView.text = text;
}

- (void) actionSummary:(UIBarButtonItem *)sender
{
    _summaryView.hidden = !_summaryView.hidden;
    [self updateRightBarButton];

    if (!_summaryView.hidden && !_summaryView.hasText) {
        
        NSString *text = _textView.text;
        KxSummarizerParams *params = [KxSummarizerParams new];
        NSSet *stopwords = self.stopwords;
        
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSTimeInterval ts = [NSDate timeIntervalSinceReferenceDate];
            
            NSArray *keywords;
            NSArray *sentences = [KxSummarizerExtractor runText:text
                                                          range:NSMakeRange(0, text.length)
                                                       sampling:0.1
                                                         params:params
                                                      stopwords:stopwords
                                                       keywords:&keywords];
            
            ts = [NSDate timeIntervalSinceReferenceDate] - ts;
            NSLog(@"processed %u chars in %0.2f sec (%.2f ch/s)",
                  (unsigned)text.length, ts, (double)text.length/ts);
            
            sentences = [sentences sortedArrayUsingSelector:@selector(compareByLocation:)];
            keywords = [keywords sortedArrayUsingSelector:@selector(compareByScore:)];
            
            if (keywords.count > 64) {
                keywords = [keywords subarrayWithRange:NSMakeRange(0, 64)];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf didRunText:sentences keywords:keywords];
            });
        });
    }
}

- (void) didRunText:(NSArray *)sentences
           keywords:(NSArray *)keywords
{
    NSMutableString *ms = [NSMutableString string];
    
    _textView.textColor = [UIColor darkGrayColor];
    
    for (KxSummarizerSentence *sentence in sentences) {
        
        [ms appendString:[sentence description]];
        [ms appendString:@"\n"];
        
        [_textView.textStorage addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor darkTextColor]
                                      range:sentence.range];
    }
    
    [ms appendString:@"\n\n"];
    
    for (KxSummarizerKeyword *keyword in keywords) {
        
        [ms appendFormat:@"%@/%u(%@), ",
         keyword.key,
         (unsigned)keyword.count,
         [keyword partOfSpeechName]];
    }
    
    _summaryView.text = ms;
}

- (NSSet *)stopwords
{
    NSString *path = [[NSBundle mainBundle] pathForResource:_stopwordsName ofType:@""];
    NSString *stopwordsText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *stopwordsArray = [stopwordsText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return [NSSet setWithArray:stopwordsArray];
 
}

- (void) updateRightBarButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_summaryView.hidden ? @"SUMMARY" : @"TEXT"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(actionSummary:)];

}

#pragma mark - UITextViewDelegate

- (void) textViewDidChange:(UITextView *)textView
{
    if (textView == _textView) {
        _summaryView.text = nil;
    }
}

@end
