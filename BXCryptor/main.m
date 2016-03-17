//
//  main.m
//  BXCryptor
//
//  Created by 李翔 on 3/17/16.
//  Copyright © 2016 Xiang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXCryptor-Swift.h"

static NSString *const usageText = @"SYNOPSIS:\n ./AESEncrptionTool INPUT_FILE_PATH [-e-d]\n\nsample input:\n ./AESEncrptionTool /Users/Flybrother/aestest/index.js\n\nnote:\n -e for encrption, -d for decrption and the default mode is encryption.";
static NSString *const invalidPwdText = @"Invalid Password.";
static NSString *const noPwdText = @"Please provide a password following -p in your command";



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc == 1) {
            NSLog(usageText);
            return -1;
        }
        
        // encryption mode
        BOOL isDecryptionMode = NO;
        for (int i = 0; i < argc; i++) {
            if (!strcmp(argv[i], "-e")) {
                isDecryptionMode = NO;
                break;
            }
            
            if (!strcmp(argv[i], "-d")) {
                isDecryptionMode = YES;
                break;
            }
        }
        
        // password
        NSString *pwd;
        for (int i = 0; i < argc; i++) {
            if (!strcmp(argv[i], "-p")) {
                if (i == argc - 1) {
                    NSLog(invalidPwdText);
                    return -1;
                }
                pwd = [NSString stringWithCString:argv[i+1] encoding:NSASCIIStringEncoding];
                break;
            }
        }
        if (!pwd) {
            NSLog(noPwdText);
            return -1;
        }
        NSLog(@"password: %@", pwd);
        
        // file path
        NSString *filePath = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
        NSString *outputFilePath = [filePath stringByAppendingString:isDecryptionMode ? @".dec" : @".enc"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSLog(@"file size: %lu\n", (unsigned long)fileData.length);
        
        NSData *outputData;
        if (!isDecryptionMode) {
            outputData = [RNCryptor encryptData:fileData password:pwd];
        } else {
            NSError *error;
            outputData = [RNCryptor decryptData:fileData password:pwd error:&error];
            if (error) {
                NSLog(@"can't decrypt file at %@\n", filePath);
                return -1;
            }
        }
        if (!outputData) {
            NSLog(@"operation failed somehow.\n");
            return -1;
        }
        [outputData writeToFile:outputFilePath atomically:YES];
        NSLog(@"Operation succeeded.\nOutput file path:%@", outputFilePath);
    }
    return 0;
}