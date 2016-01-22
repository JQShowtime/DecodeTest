//
//  ViewController.m
//  DecodeTest
//
//  Created by roboca on 16/1/11.
//  Copyright © 2016年 demo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *a = @"abcd";
    NSScanner* scanner = [NSScanner scannerWithString:a];
    NSString* token = @"";
    [scanner scanUpToString:@"%" intoString:&token];
    NSUInteger pos = [scanner scanLocation];
    
    NSString *str = [self replaceUnicode:@"BN50%u6536%u76CA%u4EBA"];
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSMutableString* tokenizedString = [NSMutableString string];
    NSScanner* scanner = [NSScanner scannerWithString:unicodeStr];
    NSUInteger lastPos = 0, pos = 0;

    while (lastPos < unicodeStr.length){
        NSString* token = @"";
        [scanner scanUpToString:@"%" intoString:&token];
        pos = [scanner scanLocation];
        
        if (pos == lastPos) {
            NSRange nextChar = {pos+1, 1};
            if ([[unicodeStr substringWithRange:nextChar] isEqualToString:@"u"]) {//汉字
                NSRange range = {pos+2, 4};
                token = [scanner.string substringWithRange:range];
                unichar codeValue = (unichar) strtol([token UTF8String], NULL, 16);
                [tokenizedString appendString:[NSString stringWithFormat:@"%C", codeValue]];
                lastPos = pos + 6;
            }
            else{
                NSRange range = {pos+1, 2};
                token = [scanner.string substringWithRange:range];
                unichar codeValue = (unichar) strtol([token UTF8String], NULL, 16);
                [tokenizedString appendString:[NSString stringWithFormat:@"%C", codeValue]];
                lastPos = pos + 3;
            }
        }
        else{
            if (pos == unicodeStr.length) {
                [tokenizedString appendString:[unicodeStr substringFromIndex:lastPos]];
                lastPos = unicodeStr.length;
            }
            else{
                [tokenizedString appendString:[unicodeStr substringWithRange:NSMakeRange(lastPos, pos - lastPos)]];
                lastPos = pos;
            }
        }
        [scanner setScanLocation:lastPos];
    }
    return tokenizedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
