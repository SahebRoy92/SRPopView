

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)
#define MAXHeight [UIScreen mainScreen].bounds.size.height * 0.75
#define WIDTH [UIScreen mainScreen].bounds.size.width * 0.70
#define CELLHEIGHT (IS_IPAD ? 60:44)
#define MINHeight(label) label.frame.size.height + CELLHEIGHT
#define KEYBOARD_BUFFER 10

#import "SRPopView.h"


@implementation SRPopView{
    SRPopOptionView *popView;
}

+(void)showWithButton:(id)view andArray:(NSArray *)array andHeading:(NSString *)headingText andCallback:(itemPickedBlock)completionBlock{
    
    [[SRPopView sharedManager]importPopViewAndRunWithValues:array andHeadingText:headingText ];
    [SRPopView sharedManager].viewToChangeText = view;
    [SRPopView sharedManager].completionBlockValuePicked = completionBlock;
}

+(instancetype)sharedManager{
    static SRPopView *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SRPopView alloc] init];
        [manager loadDefaultValues];
        // Do any other initialisation stuff here
    });
    return manager;
}

+(void)dismiss{
    [[SRPopView sharedManager] dismissPopView];
    [[SRPopView sharedManager]cleanup];
    
}

+(void)reloadValues{
    [[SRPopView sharedManager]reloadPopViewTblView];
}



-(void)loadDefaultValues{
    self.shouldShowAutoSearchBar    = NO;
    self.shouldHaveBlurView         = NO;
    self.supportOrientation         = NO;
}

-(void)dismissPopView{
    
    
    if([self.viewToChangeText isKindOfClass:[UITextField class]]){
        UITextField *txtF = (UITextField *)self.viewToChangeText;
        [txtF setText:self.selectedItem];
    }
    else if ([self.viewToChangeText isKindOfClass:[UIButton class]]){
        UIButton *btn = (UIButton *)self.viewToChangeText;
        [btn setSelected:NO];
        [btn setTitle:self.selectedItem forState:UIControlStateNormal];
        NSLog(@"%@",btn.titleLabel.text);
    }
    else if ([self.viewToChangeText isKindOfClass:[UILabel class]]){
        UILabel *lbl = (UILabel *)self.viewToChangeText;
        lbl.text = self.selectedItem;
    }
    
     [popView dismissView];
}

-(void)cleanup{
    popView = nil;
    self.items = nil;
    self.selectedItem = @"";
    self.headingText = @"";
    self.viewToChangeText = nil;
}
              
-(void)importPopViewAndRunWithValues:(NSArray *)items andHeadingText:(NSString *)headingText{
    
    self.items = items;
    self.headingText = headingText;
    
    
    
    if(!self.currentColorScheme){
        self.currentColorScheme = kSRColorSchemeDark;
    }
    
    
    
    popView                         = [[SRPopOptionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    popView.colorPallette           = self.currentColorScheme;
    popView.hasSearchBar            = self.shouldShowAutoSearchBar;
    popView.shouldShowBlurView      = self.shouldHaveBlurView;
    
    
    popView.headingText             = self.headingText;
    
    [popView setupView];
    popView.delegate                = (id)self;
    popView.items                   = self.items;
    
    [popView showViewAnimated];
}


-(void)didSelectItem:(NSString *)item{
    self.selectedItem = item;
    self.completionBlockValuePicked(item);
    [self dismissPopView];
}

-(void)didRemoveSelfWithoutPicking{
    [self cleanup];
}

-(void)reloadPopViewTblView{
    [popView.tblView reloadData];
}



@end



@interface SRPopOptionView()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UIView                 *tblSuperView;
@property (nonatomic,strong) UILabel                *lblHeader;
@property (nonatomic,strong) UITextField            *searchBar;
@property (nonatomic,strong) UIView                 *searchView;
@property (nonatomic,strong) UIVisualEffectView     *blurView;
@property (nonatomic,strong) UIBlurEffect           *blurEffect;

/*------ COLOR SCHEME COLORS --------*/

@property (nonatomic,strong) UIColor *headerTextCol;
@property (nonatomic,strong) UIColor *optionTextCol;
@property (nonatomic,strong) UIColor *headerBackgroundColor;
@property (nonatomic,strong) UIColor *searchTextColor;
@property (nonatomic,strong) UIColor *tblbackgroundColor;
@property (nonatomic,strong) UIColor *selfBackgroundColor;
@property (nonatomic,strong) UIColor *tableviewSeparatorColor;
@end

@implementation SRPopOptionView{
    BOOL isKeyboardUp;
    CGRect originalSize;
    BOOL shouldShowSearch;
    BOOL shouldSupportOrientation;
    NSPredicate *predicate;
    NSArray *tempArray;
}

-(instancetype)init{
    if([super init]){
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if([super initWithCoder:aDecoder]){
    }
    return self;
}


-(void)dealloc{
    NSLog(@"This view is being deallocated ---- >>>>>>");
}

#pragma mark - Setup view


-(void)cleanupView{
    
    [self.lblHeader removeFromSuperview];
    [self.searchView removeFromSuperview];
    [self.searchBar removeFromSuperview];
    [self.tblView removeFromSuperview];
    [self.tblSuperView removeFromSuperview];

    
    self.tblView        = nil;
    self.lblHeader      = nil;
    self.searchBar      = nil;
    self.searchView     = nil;
    self.tblSuperView   = nil;
    
    
    
    self.headerTextCol          = nil;
    self.optionTextCol          = nil;
    self.headerBackgroundColor  = nil;
    self.searchTextColor        = nil;
    self.tblbackgroundColor     = nil;
    self.selfBackgroundColor    = nil;
 
    tempArray                   = nil;
    

    [[NSNotificationCenter defaultCenter]removeObserver:self];

}


-(void)setupView{
    [self paintColorScheme];
    [self addBlurViewToBackground];
    self.backgroundColor = self.selfBackgroundColor;
    
    [self.tblSuperView addSubview:self.lblHeader];
    [self.tblSuperView addSubview:self.tblView];
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    
    
    [self addSubview:self.tblSuperView];
    [self rearrangeViews];
    self.alpha = 0;
    self.hidden = YES;
    
    [self addKeyboardNotifications];
    [self addOrientationChangeNotifications];
}


-(void)addBlurViewToBackground{
    if(self.shouldShowBlurView){
        self.blurEffect = nil;
        self.selfBackgroundColor = [UIColor clearColor];
        UIBlurEffectStyle style;
        if(self.colorPallette == kSRColorSchemeLight){
            style = UIBlurEffectStyleLight;
        }
        else {
            style = UIBlurEffectStyleDark;
        }
        
        self.blurEffect = [UIBlurEffect effectWithStyle:style];
        [self addSubview:self.blurView];
    }
}

-(void)modifyViewAndAddSearchbar{
    if(shouldShowSearch && self.hasSearchBar){
        [self configureForSearchBar];
    }
    [self rearrangeViews];
}

-(void)configureForSearchBar{
    [self.searchView addSubview:self.searchBar];
    [self.tblSuperView addSubview:self.searchView];
    
    self.searchBar.placeholder = @"Search";
    [self.searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}


-(void)showViewAnimated{
    self.lblHeader.text = self.headingText;
    tempArray = self.items;
    [self addSubviewToWindow];
    [self recalculateHeightOfPopView];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self.hidden = NO;
        [self.tblView reloadData];
    }];
}

-(void)addSubviewToWindow{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            [window addSubview:self];
            break;
        }
    }
}

#pragma mark - Views Re-Arranging

-(void)rearrangeViews{
    
    float maxHeight = MAXHeight;
    if(!shouldShowSearch){
        maxHeight = MAXHeight - (IS_IPAD?55:30);
    }
    
    self.tblSuperView.frame = CGRectMake(0, IS_IPAD?65:30, WIDTH, maxHeight);
    self.tblSuperView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, _tblSuperView.center.y);
    
    CGFloat height = [self getSizeOfLabel:self.headingText].height;
    
    self.lblHeader.frame = CGRectMake(0, 0, self.tblSuperView.bounds.size.width, height>35?height:35);
    self.lblHeader.numberOfLines = 0;
    self.lblHeader.lineBreakMode = NSLineBreakByWordWrapping;
    
    if(shouldShowSearch && self.hasSearchBar){
        self.searchView.frame = CGRectMake(0, self.lblHeader.frame.size.height, self.tblSuperView.frame.size.width, IS_IPAD?55:30);
        self.searchBar.frame = CGRectMake(IS_IPAD?15:5, IS_IPAD?10:4, self.searchView.bounds.size.width-(IS_IPAD?30:10), self.searchView.bounds.size.height - (IS_IPAD?20:8));
        self.searchView.hidden = NO;
        self.searchBar.hidden = NO;
    }else {
        self.searchView.frame = CGRectZero;
        self.searchBar.frame = CGRectZero;
        self.searchView.hidden = YES;
        self.searchBar.hidden = YES;
    }
    
    self.tblView.frame = CGRectMake(0, self.searchView.frame.size.height+self.lblHeader.frame.size.height, self.tblSuperView.bounds.size.width,self.tblSuperView.bounds.size.height - (self.searchView.frame.size.height + self.lblHeader.frame.size.height));
    originalSize = self.tblSuperView.frame;
}


#pragma mark - Orientation Change Notifications

- (void)addOrientationChangeNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged{
    CGRect newFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.frame = newFrame;
    [self rearrangeViews];
}


#pragma mark - Keyboard Notification Methods

-(void)addKeyboardNotifications{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)keyboardDidAppear:(NSNotification *)notfication{
    isKeyboardUp = YES;
    CGSize keyboardSize = [[[notfication userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float resizeMetrics = [self calculateHowMuchViewNeedsToMoveUp:keyboardSize.height];
    
    CGRect f = self.tblSuperView.frame;
    f.size.height -= resizeMetrics + KEYBOARD_BUFFER;
    f.origin.y -= KEYBOARD_BUFFER;
    
    originalSize = self.tblSuperView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.tblSuperView.frame = f;
    }];
}


-(void)keyboardDidDisappear:(NSNotification *)notification{
    isKeyboardUp = NO;

    CGRect f = originalSize;
    [UIView animateWithDuration:0.3 animations:^{
        self.tblSuperView.frame = f;
    }];

}





-(float)calculateHowMuchViewNeedsToMoveUp:(float) keyboardHeight{
    float pointY = self.tblSuperView.frame.size.height + self.tblSuperView.frame.origin.y;
    float pointYfromBottom = self.bounds.size.height - pointY;
    
    return keyboardHeight - pointYfromBottom;
}





#pragma mark - ReCalculate Height

-(void)recalculateHeightOfPopView{
    CGFloat heightOfTableView = self.items.count * CELLHEIGHT;
    if(heightOfTableView >= MAXHeight){
        shouldShowSearch = YES;
        CGRect frame = self.tblSuperView.frame;
        frame.size.height = MAXHeight;
        self.tblSuperView.frame = frame;
        self.tblView.alwaysBounceVertical = YES;
        [self modifyViewAndAddSearchbar];
    }
    else {
        shouldShowSearch = NO;
        CGRect frame = self.tblSuperView.frame;
        frame.size.height = self.lblHeader.frame.size.height + heightOfTableView ;
        self.tblSuperView.frame = frame;
        
        CGRect frameTbl = self.tblView.frame;
        frameTbl.size.height = heightOfTableView;
        self.tblView.frame = frameTbl;
        
        self.tblView.alwaysBounceVertical = NO;
    }
    
    self.tblSuperView.center = self.center;
}


- (CGSize )getSizeOfLabel:(NSString *)str{
    CGRect r = [str boundingRectWithSize:CGSizeMake(self.tblSuperView.bounds.size.width - 50, 0)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IS_IPAD?24.0:15.0]}
                                  context:nil];
    return r.size;
}


#pragma mark - Tableview Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:IS_IPAD?18.0f:14.0f];
    cell.textLabel.textColor = self.optionTextCol;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissView];
    [self.delegate didSelectItem:self.items[indexPath.row]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHEIGHT;
}


#pragma mark - Touch events

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([touches anyObject].view != self.tblSuperView){
        if(!isKeyboardUp){
            [self dismissView];
            [self.delegate didRemoveSelfWithoutPicking];
        }
        else {
            isKeyboardUp = NO;
            [self endEditing:YES];
        }
    }
}


#pragma mark - TextField Methods

-(void)textFieldDidChange:(UITextField *)textfield{

    if([textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0){
        predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",textfield.text];
        self.items = [self.items filteredArrayUsingPredicate:predicate];
        [self.tblView reloadData];
    }else {
        self.items = tempArray;
    }
    [self.tblView reloadData];
}


#pragma mark - Closing Methods

-(void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.hidden = YES;
    } completion:^(BOOL finished) {
        [self cleanupView];
        [self removeFromSuperview];
    }];
}




#pragma mark - Getter - 

-(UITableView *)tblView{
    if(_tblView == nil){
        _tblView = [[UITableView alloc]init];
        _tblView.backgroundColor = [UIColor clearColor];
        _tblView.separatorColor = self.tableviewSeparatorColor;
        _tblView.separatorInset = UIEdgeInsetsZero;
        _tblView.allowsMultipleSelection = NO;
        _tblView.showsVerticalScrollIndicator = NO;
        _tblView.clipsToBounds = YES;

    }
    return _tblView;
}

-(UIView *)tblSuperView{
    if(_tblSuperView == nil){
        _tblSuperView = [[UIView alloc]init];
        _tblSuperView.backgroundColor = self.tblbackgroundColor;
        _tblSuperView.clipsToBounds = YES;
    }
    return _tblSuperView;
}

-(UILabel *)lblHeader{
    if(_lblHeader == nil){
        _lblHeader = [[UILabel alloc]init];
        _lblHeader.font = [UIFont systemFontOfSize:IS_IPAD?24.0:15.0];
        _lblHeader.textColor = self.headerTextCol;
        _lblHeader.textAlignment = NSTextAlignmentCenter;
        _lblHeader.backgroundColor = self.headerBackgroundColor;
    }
    return _lblHeader;
}


-(UITextField *)searchBar{
    if(_searchBar == nil){
        _searchBar = [[UITextField alloc]init];
        _searchBar.textColor = self.searchTextColor;
        _searchBar.font = [UIFont systemFontOfSize:IS_IPAD?17:14];
        _searchBar.backgroundColor = [UIColor whiteColor];

        _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = 8;
        _searchBar.clipsToBounds = YES;

        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.searchView.bounds.size.height)];
        _searchBar.leftView = paddingView;
        _searchBar.leftViewMode = UITextFieldViewModeAlways;
        
        
        _searchBar.placeholder = @"Search";
        [_searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _searchBar;
}


-(UIView *)searchView{
    if(_searchView == nil){
        _searchView = [[UIView alloc]init];
        _searchView.backgroundColor = self.headerBackgroundColor;
    }
    return _searchView;
}

-(UIVisualEffectView *)blurView{
    if(_blurView == nil){
     
        _blurView = [[UIVisualEffectView alloc]initWithEffect:self.blurEffect];
        _blurView.frame = self.bounds;
        _blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

      
    }
    return _blurView;
}


#pragma mark - Color Scheme


-(void)paintColorScheme{
    switch (self.colorPallette) {
        case kSRColorSchemeDark:
            [self SR_ColorSchemeDark];
            break;
        case kSRColorSchemeLight:
            [self SR_ColorSchemeLight];
            break;
        case kSRColorSchemeMatte:
            [self SR_ColorSchemeMatte];
            break;
        case kSRColorSchemeBright:
            [self SR_ColorSchemeBright];
            break;
        case kSRColorSchemePowerRanger:
            [self SR_ColorSchemePowerRanger];
            break;
        case kSRColorSchemeBlack:
            [self SR_ColorScehemeBlack];
            break;
        default:
            break;
    }
}


-(void)SR_ColorSchemeDark{
    
    self.headerTextCol          = [UIColor blackColor];
    self.optionTextCol          = [UIColor whiteColor];
    self.headerBackgroundColor  = [UIColor colorWithRed:231/255.0f green:46.0f/255 blue:72.0f/255 alpha:1.0];
    self.searchTextColor        = [UIColor blackColor];
    self.tblbackgroundColor     = [UIColor blackColor];
    self.selfBackgroundColor    = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    
    
}

-(void)SR_ColorSchemeLight{
    self.headerTextCol          = [UIColor whiteColor];
    self.optionTextCol          = [UIColor blackColor];
    self.headerBackgroundColor  = [UIColor colorWithRed:92.0f/255 green:76.0f/255 blue:70.0f/255 alpha:1.0];
    self.searchTextColor        = [UIColor blackColor];
    self.tblbackgroundColor     = [UIColor whiteColor];
    self.selfBackgroundColor    = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
}

-(void)SR_ColorSchemePowerRanger{
    self.headerTextCol          = [UIColor redColor];
    self.optionTextCol          = [UIColor whiteColor];
    self.headerBackgroundColor  = [UIColor blackColor];
    self.searchTextColor        = [UIColor blackColor];
    self.tblbackgroundColor     = [UIColor blackColor];
    self.selfBackgroundColor    = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    
}

-(void)SR_ColorSchemeBright{
    self.headerTextCol          = [UIColor redColor];
    self.optionTextCol          = [UIColor whiteColor];
    self.headerBackgroundColor  = [UIColor blackColor];
    self.searchTextColor        = [UIColor blackColor];
    self.tblbackgroundColor     = [UIColor blackColor];
    self.selfBackgroundColor    = [[UIColor blackColor]colorWithAlphaComponent:0.6];
}

-(void)SR_ColorSchemeMatte{
    self.headerTextCol          = [UIColor blackColor];
    self.optionTextCol          = [UIColor whiteColor];
    self.headerBackgroundColor  = [UIColor grayColor];
    self.searchTextColor        = [UIColor blackColor];
    self.tblbackgroundColor     = [UIColor darkGrayColor];
    self.selfBackgroundColor    = [[UIColor blackColor]colorWithAlphaComponent:0.6];
}

-(void)SR_ColorScehemeBlack{
    
    self.headerTextCol          = [UIColor whiteColor];
    self.optionTextCol          = [UIColor blackColor];
    self.headerBackgroundColor  = [UIColor blackColor];
    self.searchTextColor        = [UIColor blackColor];
    self.tblbackgroundColor     = [UIColor whiteColor];
    self.selfBackgroundColor    = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.tableviewSeparatorColor = [UIColor blackColor];
}


@end
