

#import <UIKit/UIKit.h>



typedef enum {
    kSRColorSchemeDark,
    kSRColorSchemeLight,
    kSRColorSchemePowerRanger,
    kSRColorSchemeMatte,
    kSRColorSchemeBright,
    kSRColorSchemeBlack,

}SRColorScheme;

@interface SRPopView : NSObject
typedef void (^itemPickedBlock)(NSString *itemPicked);


+(void)showWithButton:(id)view andArray:(NSArray *)array andHeading:(NSString *)headingText andCallback:(itemPickedBlock)completionBlock;
+(instancetype)sharedManager;
+(void)dismiss;
+(void)reloadValues;

@property (nonatomic,strong) NSString *headingText;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSString *selectedItem;
@property (nonatomic,weak) id viewToChangeText;
@property (copy, nonatomic) itemPickedBlock completionBlockValuePicked;
@property (nonatomic,assign) SRColorScheme currentColorScheme;
@property BOOL shouldShowAutoSearchBar;
@property BOOL supportOrientation;
@property BOOL shouldHaveBlurView;
@end


@protocol SRPopOptionViewDelegate <NSObject>

-(void)didSelectItem:(NSString *)item;
-(void)didRemoveSelfWithoutPicking;

@end

@interface SRPopOptionView : UIView

@property (nonatomic,weak) id <SRPopOptionViewDelegate>delegate;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSString *headingText;
@property (nonatomic,strong) UITableView *tblView;
@property (nonatomic,assign) SRColorScheme colorPallette;
@property BOOL hasSearchBar;
@property BOOL shouldShowBlurView;


-(void)setupView;
-(void)dismissView;
-(void)showViewAnimated;

@end
