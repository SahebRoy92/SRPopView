//
//  SettingsViewController.m
//  SRPopViewExample
//
//  Created by Saheb Roy on 28/02/17.
//  Copyright © 2017 Saheb Roy. All rights reserved.
//

#import "SettingsViewController.h"
#import "SRPopView.h"

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SettingsViewController{
    NSArray *settingsData;
    NSMutableArray *currentSettings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    settingsData = @[@{@"secname":@"Color Theme",@"rowdata":@[@"Dark",@"Light",@"Matte",@"Bright",@"Black"]},
                     @{@"secname":@"Other Settings",@"rowdata":@[@"Blurview background",@"Auto Search"]}];
    
    currentSettings = [@[]mutableCopy];
    if([SRPopView sharedManager].shouldShowAutoSearchBar){
        [currentSettings addObject:@"Auto Search"];
    }
    if([SRPopView sharedManager].shouldHaveBlurView){
         [currentSettings addObject:@"Blurview background"];
    }




    switch ([SRPopView sharedManager].currentColorScheme) {
        case kSRColorSchemeDark:{
            [currentSettings addObject:@"Dark"];
            break;
        }
            
        case kSRColorSchemeLight:{
            [currentSettings addObject:@"Light"];
            break;
        }
        case kSRColorSchemeBright:{
            [currentSettings addObject:@"Bright"];
            break;
        }
        case kSRColorSchemeMatte:{
            [currentSettings addObject:@"Matte"];
            break;
        }
        case kSRColorSchemeBlack:{
            [currentSettings addObject:@"Black"];
            break;
        }
        default:
            break;
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return settingsData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[settingsData objectAtIndex:section]objectForKey:@"rowdata"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"reuse";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    NSDictionary *dictData = settingsData[indexPath.section];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = dictData[@"rowdata"][indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if([currentSettings containsObject:dictData[@"rowdata"][indexPath.row]]){
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *current = settingsData[section];
    return current[@"secname"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0){
        [currentSettings removeAllObjects];
        [currentSettings addObject:cell.textLabel.text];
        [tableView reloadData];
    }
    else {
        if([currentSettings containsObject:cell.textLabel.text]){
            cell.accessoryType = UITableViewCellAccessoryNone;
            [currentSettings removeObjectIdenticalTo:cell.textLabel.text];
        }
        else {
            [currentSettings addObject:cell.textLabel.text];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}



-(IBAction)doneBtnAction:(id)sender{
    NSLog(@"%@",currentSettings);
    
    if([currentSettings containsObject:@"Dark"]){
        [SRPopView sharedManager].currentColorScheme = kSRColorSchemeDark;
    }
    
    if([currentSettings containsObject:@"Light"]){
         [SRPopView sharedManager].currentColorScheme = kSRColorSchemeLight;
    }

    if([currentSettings containsObject:@"Bright"]){
        [SRPopView sharedManager].currentColorScheme = kSRColorSchemeBright;
    }

    if([currentSettings containsObject:@"Matte"]){
        [SRPopView sharedManager].currentColorScheme = kSRColorSchemeMatte;
    }

    if([currentSettings containsObject:@"Black"]){
        [SRPopView sharedManager].currentColorScheme = kSRColorSchemeBlack;
    }

    if([currentSettings containsObject:@"Blurview background"]){
        [SRPopView sharedManager].shouldHaveBlurView = YES;
    }
    
    if([currentSettings containsObject:@"Auto Search"]){
        [SRPopView sharedManager].shouldShowAutoSearchBar = YES;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
