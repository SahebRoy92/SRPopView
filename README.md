# SRPopView



SRPopview is a small and simple yet powerfull drag and drop complete solution for showing popview for lists and dropdown solution for iOS.

![Alt text](http://i.imgur.com/QZ1jxmB.jpg "Optional title")


### Installation and Usage 

1. Drag and drop the SRPopView Folder into your project and thats it. Your good to go.
2. `#import "SRPopView.h"`

To open SRPopview we just call 
`+(void)showWithButton:(id)view andArray:(NSArray *)array andHeading:(NSString *)headingText andCallback:(itemPickedBlock)completionBlock` 



 - We Pass the array of lists we want to see in the array parameter and give it a custom heading. 
 - The completion block is called as soon as we tap on any selected item.
 - Tapping anywhere except SRPopView will automatically make the popview disappear.
 - There are certain in build Color themes for SRPopview.
 

### Auto Search Option

SRPopview has a very intelligent auto search feature which when enabled, if the list is too long then it automatically enables its search box, which filters the list of items.
This feature is also takes in context about keyboard. 
When keyboard is up, SRPopView will show as much of the list as possible.
During Keyboard is up Tapping on anywhere will just hide the keyboard.


### Reference 
Refer to the example project for more customisation.

