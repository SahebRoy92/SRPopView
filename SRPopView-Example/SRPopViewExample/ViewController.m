//
//  ViewController.m
//  SRPopViewExample
//
//  Created by Saheb Roy on 28/02/17.
//  Copyright © 2017 Saheb Roy. All rights reserved.
//

#import "ViewController.h"
#import "SRPopView.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *lc_btmPicker;
@property (nonatomic,weak) IBOutlet UIPickerView *pickerView;

@end

@implementation ViewController{
    NSMutableArray *totalItems;
    BOOL autoSearch;
    int pickerCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureController];
}


-(void)configureController{
    self.lc_btmPicker.constant = -250;
    [self.view layoutIfNeeded];
    
    
    
    // FIRST TIME
    totalItems = [@[]mutableCopy];
    for (int i=0; i<5; i++) {
        [totalItems addObject:[NSString stringWithFormat:@"Item %i",i]];
    }
    
   
    [SRPopView sharedManager].currentColorScheme = kSRColorSchemeDark;
    autoSearch = NO;
}

-(void)addItemsFromPicker{
    [totalItems removeAllObjects];
    for (int i=0; i<pickerCount; i++) {
        [totalItems addObject:[NSString stringWithFormat:@"Item %i",i]];
    }
}

-(void)animatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)showAlert:(NSString *)desc{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SRPopView" message:[NSString stringWithFormat:@"This is the item that you have picked -- %@",desc] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - Action Methods

-(IBAction)openPopView:(id)sender{
   [SRPopView showWithButton:sender andArray:totalItems andHeading:@"SRPopView Custom Heading" andCallback:^(NSString *itemPicked) {
        [self showAlert:itemPicked];
   }];
}

-(IBAction)openPicker:(id)sender{
    self.lc_btmPicker.constant = 0;
    [self animatePicker];
}

-(IBAction)pickerDoneAction:(id)sender{
    self.lc_btmPicker.constant = -250;
    [self animatePicker];
    [self addItemsFromPicker];
}

#pragma mark - Picker Methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 30;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    pickerCount = (int)row;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%li",(long)row];
}



@end
