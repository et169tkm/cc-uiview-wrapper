//
//  CCUIViewWrapper.h
//  SingAlong
//
//  Created by Manna01 on 11年3月2日.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class CCUIViewWrapper;

@protocol CCUIViewWrapperTextEditingDelegate
@optional
- (void)ccUIViewWrapperFinishedEditing:(CCUIViewWrapper*)wrapper;
@end

#pragma mark superclass

@interface CCUIViewWrapper : CCNode <CCTargetedTouchDelegate> {
    UIView *uiView;
}

- (CCUIViewWrapper*)initWithUIView:(UIView*)view;
+ (CCUIViewWrapper*)wrapperWithUIView:(UIView*)view;
- (void)dealloc;

- (CGPoint)uiKitPosition;
- (CGRect)uiKitFrame;

@property (readonly) UIView *uiView;

@end

#pragma mark Text field

@interface CCUITextFieldWrapper : CCUIViewWrapper <UITextFieldDelegate>
{
    UITextField *uiTextField;
    id<CCUIViewWrapperTextEditingDelegate> delegate;
}

+ (CCUITextFieldWrapper*)wrapper;
- (CCUITextFieldWrapper*)init;
- (void)dealloc;

- (BOOL)stopEditing;

@property (readonly) UITextField *uiTextField;
@property (assign) id<CCUIViewWrapperTextEditingDelegate> delegate;

@end

#pragma mark Text View

@interface CCUITextViewWrapper : CCUIViewWrapper <UITextViewDelegate>
{
    UITextView *uiTextView;
    id<CCUIViewWrapperTextEditingDelegate> delegate;
}

+ (CCUITextViewWrapper*)wrapper;
- (CCUITextViewWrapper*)init;
- (void)dealloc;

- (BOOL)stopEditing;


@property (readonly) UITextView *uiTextView;
@property (assign) id<CCUIViewWrapperTextEditingDelegate> delegate;

@end

