//
//  EAFontManager.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Font manager, manages fonr cache pool */
@interface EAFontManager : NSObject

/** Singleton instance */
+(EAFontManager*)shared;

/** Cleanup resources before terminating application. Save cached data, etc */
-(void)cleanup;

/** Request font instance from manager 
 @param fontName        Font name as mentioned in font file
 @param fontSize        Font size
 @return Font instance or nil
 */
-(UIFont*)fontWithName:(NSString*)fontName andSize:(CGFloat)fontSize;

@end
