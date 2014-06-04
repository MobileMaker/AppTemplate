//
//  EALoginView.h
//  Template
//
//  Created by Maker
//  Copyright 2014. All rights reserved.
//

#import "EALoginView.h"
#import "Controllers/Cells/EATitleValueCell.h"
#import "Utils/EAUtils.h"


typedef enum
{
    ViewTagEmailTextField = 1000,
    ViewTagPasswordTextField
} ViewTag;



@interface EALoginView() <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSArray* arrayOfTextFields;
@property (nonatomic, strong) LoginCompletionBlock loginCompletion;

@end

@implementation EALoginView

+(CGSize)viewSize
{
    return CGSizeMake(380.0, 50.0 + 2*[EATitleValueCell cellHeight] + 50.0 + 2*10.0);
}

-(instancetype)initWithEmail:(NSString*)email password:(NSString*)password completion:(LoginCompletionBlock)completion
{
    CGRect loginFrame = CGRectMake(0.0, 0.0, [EALoginView viewSize].width, [EALoginView viewSize].height);
    
    self = [super initWithFrame:loginFrame];
    if (self)
    {
        self.loginCompletion = [completion copy];
        
        // Create text fields
        UITextField* txtEmail = [[UITextField alloc] init];
        [txtEmail setTag:ViewTagEmailTextField];
        [txtEmail setPlaceholder:NSLocalizedString(@"User email", @"Login email cell value placeholder")];
        [txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
        [txtEmail setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [txtEmail setAutocorrectionType:UITextAutocorrectionTypeNo]; // NUD-427
        [txtEmail setReturnKeyType:UIReturnKeyNext];
        [txtEmail setDelegate:self];
        [txtEmail setText:email];
        
        UITextField* txtPassword = [[UITextField alloc] init];
        [txtPassword setTag:ViewTagPasswordTextField];
        [txtPassword setPlaceholder:NSLocalizedString(@"User password", @"Login password cell value placeholder")];
        [txtPassword setKeyboardType:UIKeyboardTypeDefault];
        [txtPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [txtPassword setReturnKeyType:UIReturnKeyDone];
        [txtPassword setSecureTextEntry:YES];
        [txtPassword setDelegate:self];
        [txtPassword setText:password];
        
        self.arrayOfTextFields = [NSMutableArray arrayWithObjects:txtEmail, txtPassword, nil];
        
        // Create table for text field cells
        UITableView* tblView = [[UITableView alloc] initWithFrame:loginFrame
                                                            style:UITableViewStyleGrouped];
        [tblView setDelegate:self];
        [tblView setDataSource:self];
        [tblView setClipsToBounds:YES];
        [tblView setBounces:NO];
        [tblView setShowsHorizontalScrollIndicator:NO];
        [tblView setShowsVerticalScrollIndicator:NO];
        [tblView setBackgroundColor:[UIColor clearColor]];
        [tblView.layer setCornerRadius:5.0];
        [self addSubview:tblView];
        [tblView constrainWidthToView:self predicate:nil];
        [tblView constrainHeightToView:self predicate:nil];
        [tblView alignLeadingEdgeWithView:self predicate:nil];
        [tblView alignTopEdgeWithView:self predicate:nil];
        
        [self createHeaderFor:tblView];
        [self createFooterFor:tblView];
    }
    return self;
}

-(void)createHeaderFor:(UITableView*)tblView
{
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 50.0)];
    [header setBackgroundColor:[UIColor clearColor]];
    
    UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 30.0)];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setFont:[[EAFontManager shared] fontWithName:kFontHelveticaNeueLTStdRoman andSize:28.0]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setText:NSLocalizedString(@"Template login", @"Login view table header title")];
    [header addSubview:lblTitle];
    
    [tblView setTableHeaderView:header];
}

-(void)createFooterFor:(UITableView*)tblView
{
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 50.0)];
    [footer setBackgroundColor:[UIColor clearColor]];
    
    // Create 'Login' button
    UIButton* btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setFrame:CGRectMake(0.0, 10.0, 120.0, 31.0)];
    [btnLogin setTitle:NSLocalizedString(@"Login", @"Login button title") forState:UIControlStateNormal];
    [btnLogin.titleLabel setFont:[[EAFontManager shared] fontWithName:kFontHelveticaNeueLTStdRoman andSize:20.0]];
    [btnLogin addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    [btnLogin setCenter:CGPointMake(tblView.bounds.size.width/2.0, 10.0 + btnLogin.bounds.size.height/2.0)];
    [btnLogin.layer setBorderWidth:1.0];
    [btnLogin.layer setBorderColor:[UIColor whiteColor].CGColor];
    [footer addSubview:btnLogin];
    
    [tblView setTableFooterView:footer];
}

-(NSString*)enteredEmail
{
    UITextField* txtEmail = [self textFieldByViewTag:ViewTagEmailTextField];
    return txtEmail.text;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfTextFields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kTableCellIdentifier = @"LoginCell";
    
    EATitleValueCell* cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier];
    if (cell == nil)
    {
        cell = [[EATitleValueCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:kTableCellIdentifier];
    }
    
    // Configure text field
    UITextField* txtField = (UITextField*)[self.arrayOfTextFields objectAtIndex:indexPath.row];
    [cell setTextField:txtField];
    
    switch(txtField.tag)
    {
        case ViewTagEmailTextField:
            [cell.lblTitle setText:NSLocalizedString(@"Email", @"Login email cell title")];
            break;
            
        case ViewTagPasswordTextField:
            [cell.lblTitle setText:NSLocalizedString(@"Password", @"Login passwordcell title")];
            break;
            
        default:
            NSAssert(NO, @"Invalid view tag");
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EATitleValueCell cellHeight];
}

#pragma mark - UItextFieldDelegate

-(UITextField*)textFieldByViewTag:(NSInteger)viewTag
{
    for (UITextField* txtField in self.arrayOfTextFields)
        if (txtField.tag == viewTag)
            return txtField;
            
    return nil;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    return;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length)
    {
        switch(textField.tag)
        {
            case ViewTagEmailTextField:
            {
                UITextField* passTxtField = [self textFieldByViewTag:ViewTagPasswordTextField];
                [passTxtField becomeFirstResponder];
            }
            break;
            
            case ViewTagPasswordTextField:
            {
                UITextField* emailTxtField = [self textFieldByViewTag:ViewTagEmailTextField];
                if (emailTxtField.text.length == 0)
                {
                    [emailTxtField becomeFirstResponder];
                }
                else
                    [self onLogin];
            }
            break;
        }
    }
    
    // We do not want UITextField to insert line-breaks
    return NO;
}

#pragma mark - Actions

-(void)onLogin
{
    UITextField* txtEmail = [self textFieldByViewTag:ViewTagEmailTextField];
    UITextField* txtPassword = [self textFieldByViewTag:ViewTagPasswordTextField];
    
    if (![EAUtils validateEmail:txtEmail.text])
    {
        [UIAlertView showWithTitle:NSLocalizedString(@"Template Login", @"Login alert view title")
                           message:NSLocalizedString(@"Invalid email. Please enter valid email for account", nil)
                 cancelButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"OK", nil)]
                      clickedBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
         {
             [txtEmail becomeFirstResponder];
         }];
    }
    else if (txtPassword.text == nil || txtPassword.text.length == 0)
    {
        [UIAlertView showWithTitle:NSLocalizedString(@"Template Login", @"Login alert view title")
                           message:NSLocalizedString(@"Empty password. Please enter password for account", nil)
                 cancelButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"OK", nil)]
                      clickedBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
        {
            [txtPassword becomeFirstResponder];
        }];
    }
    else
    {
        // Iterate over text field and resign responder
        for (UITextField* txtField in self.arrayOfTextFields)
        {
            if ([txtField isFirstResponder])
            {
                [txtField resignFirstResponder];
                break;
            }
        }
        
        if (self.loginCompletion)
            self.loginCompletion(txtEmail.text, txtPassword.text);
    }
}

@end
