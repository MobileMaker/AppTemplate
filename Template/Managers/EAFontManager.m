//
//  EAFontManager.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EAFontManager.h"

@interface EAFontManager()

@property (atomic, strong) NSMutableDictionary* fonts;

@end

@implementation EAFontManager

@synthesize fonts;

/** Generate key for fonts cache */
+(NSString*)keyForFontWithName:(NSString*)fontName andSize:(CGFloat)fontSize
{
    return [NSString stringWithFormat:@"%@_%.1f", fontName, fontSize];
}

+(EAFontManager*)shared
{
    static dispatch_once_t pred;
    static EAFontManager* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^{
        sharedInstance = [[EAFontManager alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    if (self = [super init])
    {
        self.fonts = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // Subscribe on memory warnings to optimize emmory management
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

-(void)dealloc
{
    NSAssert(NO, @"This function must not be called");
}

-(void)handleMemoryWarning:(NSNotification *)notification
{
    // Clear fonts cache
    [self.fonts removeAllObjects];
}

-(void)cleanup
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    self.fonts = nil;
}

-(UIFont*)fontWithName:(NSString*)fontName andSize:(CGFloat)fontSize
{
    NSAssert(fontName, @"Nil font name argument");
    
    NSString* encodedFontName = [EAFontManager keyForFontWithName:fontName andSize:fontSize];
    
    UIFont* fnt = [self.fonts objectForKey:encodedFontName];
    if (fnt == nil)
    {
        fnt = [UIFont fontWithName:fontName size:fontSize];
        if (fnt)
            [self.fonts setObject:fnt forKey:encodedFontName];
        else
            DLog(@"Failed to instatiate font '%@' %.1f pt", fontName, fontSize);
    }
    
    return fnt;
}

@end
