//
//  CCUIViewWrapper.m
//  SingAlong
//
//  Created by Manna01 on 11年3月2日.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCUIViewWrapper.h"

void printFrame(CGRect rect){
    printf("printFrame: origin: %f, %f; size: %f, %f\n", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

#pragma mark CCUIViewWrapper (super class)

@implementation CCUIViewWrapper

@synthesize uiView;


+ (CCUIViewWrapper*)wrapperWithUIView:(UIView*)view{
    return [[[CCUIViewWrapper alloc] initWithUIView:view] autorelease];
}

- (CCUIViewWrapper*)initWithUIView:(UIView*)view{
    if (self = [super init]) {
        uiView = [view retain];
        
        contentSize_ = CGSizeZero;
    }
    return self;
}

- (void)dealloc{
    [uiView release];
    
    [super dealloc];
}

- (void)visit{
    //NSLog(@"[%@ visit]", [self class]);
    uiView.opaque = visible_;
    [super visit];
}

- (void)transform{
    [super transform];
    uiView.frame = [self uiKitFrame];
}

- (CGPoint)uiKitPosition{
    CGPoint topLeftCornerAR = ccp(-self.contentSize.width*self.anchorPoint.x, -self.contentSize.height*self.anchorPoint.y+self.contentSize.height);
    return [[CCDirector sharedDirector] convertToGL:[self convertToWorldSpaceAR:topLeftCornerAR]];
}

- (CGRect)uiKitFrame{
    CGPoint uiKitPosition = [self uiKitPosition];
    return CGRectMake((CGFloat)uiKitPosition.x, (CGFloat)uiKitPosition.y, (CGFloat)contentSize_.width, (CGFloat)contentSize_.height);
    uiView.frame = CGRectMake(100.0f, 100.0f, 200.0f, 31.0f);
}

- (void)onEnter{
    [super onEnter];
    [[[CCDirector sharedDirector] openGLView] addSubview:uiView];
}

- (void)onExit{
    [super onExit];
    [uiView removeFromSuperview];
}
@end


/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark CCUITextFieldWrapper

@implementation CCUITextFieldWrapper
@synthesize delegate, uiTextField;

+ (CCUITextFieldWrapper*)wrapper{
    return [[[CCUITextFieldWrapper alloc] init] autorelease];
}

- (CCUITextFieldWrapper*)init{
    if (self = [super initWithUIView:((UIView*)[[[UITextField alloc] initWithFrame:[self uiKitFrame]] autorelease])]) {
        contentSize_ = CGSizeMake(97.0f, 31.0f); // default size in interface builder
        uiTextField = ((UITextField*)uiView);
        uiTextField.backgroundColor = [UIColor whiteColor];
        uiTextField.borderStyle = UITextBorderStyleRoundedRect;
        uiTextField.delegate = self;
    }
    return self;
}

- (void)dealloc{
    ((uiTextField.delegate == self) && (uiTextField.delegate = nil));
    
    [super dealloc];
}


- (void)onEnter{
    [super onEnter];
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-100 swallowsTouches:YES];
}

- (void)onExit{
    [super onExit];
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

- (BOOL)stopEditing{
    if ([uiTextField isFirstResponder]) {
        [uiTextField resignFirstResponder];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark CCTouchDispatcher

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    //NSLog(@"[%@ ccTouchBegan", [self class]);
    return [self stopEditing];
}

#pragma mark UITextFieldDelegate

/*
 * – textFieldShouldBeginEditing:
 * – textFieldDidBeginEditing:
 * – textFieldShouldEndEditing:
 * – textFieldDidEndEditing:
 
 Editing the Text Field’s Text
 
 * – textField:shouldChangeCharactersInRange:replacementString:
 * – textFieldShouldClear:
 * – textFieldShouldReturn:
 */

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (delegate && [((NSObject*)delegate) respondsToSelector:@selector(ccUIViewWrapperStartedEditing:)]) {
        [delegate ccUIViewWrapperStartedEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (delegate && [((NSObject*)delegate) respondsToSelector:@selector(ccUIViewWrapperFinishedEditing:)]) {
        [delegate ccUIViewWrapperFinishedEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self stopEditing];
    return YES;
}


@end


/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark CCUITextViewWrapper

@implementation CCUITextViewWrapper
@synthesize delegate, uiTextView;

+ (CCUITextViewWrapper*)wrapper{
    return [[[CCUITextViewWrapper alloc] init] autorelease];
}

- (CCUITextViewWrapper*)init{
    if (self = [super initWithUIView:((UIView*)[[[UITextView alloc] initWithFrame:[self uiKitFrame]] autorelease])]) {
        uiTextView = ((UITextView*)uiView);
        uiTextView.backgroundColor = [UIColor whiteColor];
        uiTextView.delegate = self;
    }
    return self;
}

- (void)dealloc{
    ((uiTextView.delegate == self) && (uiTextView.delegate = nil));
    
    [super dealloc];
}


- (void)onEnter{
    [super onEnter];
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-100 swallowsTouches:YES];
}

- (void)onExit{
    [super onExit];
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

- (BOOL)stopEditing{
    if ([uiTextView isFirstResponder]) {
        [uiTextView resignFirstResponder];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark CCTouchDispatcher

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    //NSLog(@"[%@ ccTouchBegan", [self class]);
    return [self stopEditing];
}

#pragma mark UITextViewDelegate

/*
 Responding to Editing Notifications
 
 * – textViewShouldBeginEditing:
 * – textViewDidBeginEditing:
 * – textViewShouldEndEditing:
 * – textViewDidEndEditing:
 
 Responding to Text Changes
 
 * – textView:shouldChangeTextInRange:replacementText:
 * – textViewDidChange:
 
 Responding to Selection Changes
 
 * – textViewDidChangeSelection:
 */

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (delegate && [((NSObject*)delegate) respondsToSelector:@selector(ccUIViewWrapperStartedEditing:)]) {
        [delegate ccUIViewWrapperStartedEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView*)textView{
    if (delegate && [((NSObject*)delegate) respondsToSelector:@selector(ccUIViewWrapperFinishedEditing:)]) {
        [delegate ccUIViewWrapperFinishedEditing:self];
    }
}

@end

