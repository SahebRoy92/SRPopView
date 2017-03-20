# SRPopView



***SRPopview is a small and simple yet powerfull drag and drop complete solution for showing popview for lists and dropdown solution for iOS.***
SRpopview supports both ***Portrait*** and ***Landscape*** orientation

![](https://j.gifs.com/760NxB.gif)


### Installation and Usage 

1. Drag and drop the SRPopView Folder into your project and thats it. Your good to go.
2. `#import "SRPopView.h"`

To open SRPopview we just call -

`+(void)showWithButton:(id)view andArray:(NSArray *)array andHeading:(NSString *)headingText andCallback:(itemPickedBlock)completionBlock` 

To Customise SRPopView for Different Themes - 

 `[SRPopView sharedManager].currentColorScheme = kSRColorSchemeDark;`
 
### There are 4 In build themes currently - 

  - `kSRColorSchemeDark`
  - `kSRColorSchemeLight`
  - `kSRColorSchemePowerRanger`
  - `kSRColorSchemeMatte`
  - `kSRColorSchemeBright`
  - `kSRColorSchemeBlack`

 

### Auto Search Option

SRPopview has a very intelligent auto search feature which when enabled, if the list is too long then it automatically enables its search box, which filters the list of items.
This feature is also takes in context about keyboard. 
When keyboard is up, SRPopView will show as much of the list as possible.
During Keyboard is up Tapping on anywhere will just hide the keyboard.

Too turn on ***Auto Search Option*** - 

  `[SRPopView sharedManager].shouldShowAutoSearchBar = YES;`


### SRPopView Methods Glossary 

  * `+(void)showWithButton:(id)view andArray:(NSArray *)array andHeading:(NSString *)headingText andCallback:(itemPickedBlock)completionBlock`

   - ***view*** - Sender on which SRPopview should open
   - ***array*** - List of items as NSStrings
   - ***headingText*** - Heading of SRPopview
   - ***completiobBlock*** - Fires when user taps on any item, along with the selected Text.

  * `+(void)dismiss`
    ***To dismiss SRPopview***

  * `+(void)reloadValues`
    ***To explicitly reload values***

  * `currentColorScheme` 
     ***Assigning Color Scheme to SRPopview***
 
  * `shouldShowAutoSearchBar` 
    ***Toggle autosearch feature*** 


### Reference 
Refer to the example project for more customisation.

