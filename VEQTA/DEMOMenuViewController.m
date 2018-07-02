//
//  DEMOMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DEMONavigationController.h"




@interface DEMOMenuViewController ()
{
    int expandedSection;
    NSMutableIndexSet *expandedSections;
    NSMutableArray *imageData;
    NSMutableArray *arraySub;
    NSMutableArray *arrayExpand;
    NSString *strID;
    NSDictionary *sportsDict;
}

@end

@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    expandedSection = -1;
    [super viewDidLoad];
    strID = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginData"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectToHome:) name:@"redirectToHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSideMenu:) name:@"sideMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadTable" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToSignIn:) name:@"goToSignIn" object:nil];
    self.tableView.separatorColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20.0f)];
        UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0,340, 40.0f)];
        view.backgroundColor  = [UIColor blackColor];
        viewHeader.backgroundColor  = [UIColor blackColor];
        
        UIImageView *image0 =[[UIImageView alloc] initWithFrame:CGRectMake(70,20,100,23)];
        image0.image=[UIImage imageNamed:@"vqeta-logo"];
        
        [view addSubview:viewHeader];
        
       // [view addSubview:image0];
        view;
    });
}
#pragma mark -
#pragma mark UITableView Delegate
- (void) reloadSideMenu:(NSNotification *) notification
{
    imageData = [[NSMutableArray alloc] init];
    arraySub = notification.object;
    
    NSLog(@"imageData >>>%@",imageData);
    [self reloadForTableview];
}
-(void)goToSignIn:(NSNotification *) notification
{
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    DEMOHomeViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    navigationController.viewControllers = @[loginViewController];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
- (void) reloadTable:(NSNotification *) notification
{
    [self reloadForTableview];
}

-(void)reloadForTableview
{
    
      strID = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginData"];
    
     arrayExpand = arraySub;
    NSMutableArray *arrayKeys = [[NSUserDefaults standardUserDefaults] valueForKey:@"sideKeys"];
    NSLog(@"id login %@",strID);
    if (strID != nil)
    {
        if (strID.length > 0)
        {
            NSMutableArray *arrayKeys = [[NSUserDefaults standardUserDefaults] valueForKey:@"sideKeys"];
            if ((arrayKeys.count > 0) && (arrayKeys.count < 2))
            {
                imageData =  [[NSMutableArray  alloc]initWithObjects:@"",@"HOME",[arrayKeys objectAtIndex:0],@"SUBSCRIPTION",@"MY FAVORITES",@"MY ACCOUNT",@"CONTACT US",@"TERMS OF USE",@"PRIVACY POLICY",@"SIGN OUT",nil];
            }
            if ((arrayKeys.count > 1) && (arrayKeys.count < 3))
            {//Subscription
                imageData =  [[NSMutableArray  alloc]initWithObjects:@"",@"HOME",[arrayKeys objectAtIndex:0],[arrayKeys objectAtIndex:1],@"SUBSCRIPTION",@"MY FAVORITES",@"MY ACCOUNT",@"CONTACT US",@"TERMS OF USE",@"PRIVACY POLICY",@"SIGN OUT",nil];
            }
        }
        else
        {
            NSMutableArray *arrayKeys = [[NSUserDefaults standardUserDefaults] valueForKey:@"sideKeys"];
            if ((arrayKeys.count > 0) && (arrayKeys.count < 2))
            {
                imageData =  [[NSMutableArray  alloc]initWithObjects:@"",@"HOME",[arrayKeys objectAtIndex:0],@"SUBSCRIPTION",@"CONTACT US",@"TERMS OF USE",@"PRIVACY POLICY",@"SIGN IN",nil];
            }
            if ((arrayKeys.count > 1) && (arrayKeys.count < 3))
            {
                imageData =  [[NSMutableArray  alloc]initWithObjects:@"",@"HOME",[arrayKeys objectAtIndex:0],[arrayKeys objectAtIndex:1],@"SUBSCRIPTION",@"CONTACT US",@"TERMS OF USE",@"PRIVACY POLICY",@"SIGN IN",nil];
            }
        }
    }
    else
    {
        NSMutableArray *arrayKeys = [[NSUserDefaults standardUserDefaults] valueForKey:@"sideKeys"];
        if ((arrayKeys.count > 0) && (arrayKeys.count < 2))
        {
            imageData =  [[NSMutableArray  alloc]initWithObjects:@"",@"HOME",[arrayKeys objectAtIndex:0],@"SUBSCRIPTION",@"CONTACT US",@"TERMS OF USE",@"PRIVACY POLICY",@"SIGN IN",nil];
        }
        if ((arrayKeys.count > 1) && (arrayKeys.count < 3))
        {
            imageData =  [[NSMutableArray  alloc]initWithObjects:@"",@"HOME",[arrayKeys objectAtIndex:0],[arrayKeys objectAtIndex:1],@"SUBSCRIPTION",@"CONTACT US",@"TERMS OF USE",@"PRIVACY POLICY",@"SIGN IN",nil];
        }
        
    }
    [self.menuTblView reloadData];
}
- (void) redirectToHome:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    DEMOHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    navigationController.viewControllers = @[homeViewController];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    //cell.textLabel.textColor = [UIColor whiteColor];
   // cell.textLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:15];
   // cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15];
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
 {
 //if (sectionIndex == 0)
 //     return 0;
 return 0;
 // return 34;
 }
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
   // UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:0.0/255.0 blue:20.0/255.0 alpha:1.0];
    [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"lastSelectedSide"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
    //AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    //appDel.lastSelectedMenu = cell.textLabel.text;
   // NSLog(@"text>>>>%@",cell.textLabel.text);
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2)
    {
        if ( expandedSection!=-1)
        {
            if (indexPath.section==2&&indexPath.row == 0)
            {
                //SportsListViewController
            }
            else
            {
                NSMutableArray *arrayKeys = [[NSUserDefaults standardUserDefaults] valueForKey:@"sideKeys"];
               
                NSString *strKey = [arrayKeys objectAtIndex:0];
                sportsDict = [[[arrayExpand objectAtIndex:0] objectForKey:strKey] objectAtIndex:indexPath.row-1];
                NSLog(@"arraySports >> %@",sportsDict);
                 [[NSUserDefaults standardUserDefaults] setObject:@"sidemenu" forKey:@"sportsButton"];
                DEMOHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SportsListViewController"];
                navigationController.viewControllers = @[homeViewController];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sportsDict];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"sportsDict"];
                [[NSUserDefaults standardUserDefaults] setObject:[sportsDict objectForKey:@"id"] forKey:@"sportsID"];
                self.frostedViewController.contentViewController = navigationController;
                [self.frostedViewController hideMenuViewController];
                NSLog(@"indexPath.section %ld",(long)indexPath.section);
            }
           
            
//            }
//            else
//            {
                expandedSection =-1;
//            }
        }
        else
        {
            expandedSection = (int)indexPath.section;
            
        }
        
        [self.menuTblView reloadData];
        
        [tableView endUpdates];
    }
    else if (indexPath.section == 0)
    {
    }
    else if (indexPath.section == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"slider" forKey:@"screenFrom"];
        DEMOHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        navigationController.viewControllers = @[homeViewController];
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    }
    else if (indexPath.section == 3)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"slider" forKey:@"screenFrom"];
        // UserDefaults.standard.set("subscribe", forKey: "screenFrom")
        DEMOSecondViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubscriptionPlanVC"];
        navigationController.viewControllers = @[secondViewController];
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    }
    else
    {
        if (strID != nil)
        {
            NSLog(@"indexPath.section  >>>>>dssdds>>%d",indexPath.section);
            if ([strID  isEqualToString:@""]) {
                NSLog(@"indexPath.section >>>%ld",(long)indexPath.section);
                if (indexPath.section == 4) {
                    DEMOHomeViewController *contactViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
                    navigationController.viewControllers = @[contactViewController];
                    self.frostedViewController.contentViewController = navigationController;
                    [self.frostedViewController hideMenuViewController];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"slider" forKey:@"screenFrom"];
                    DEMOHomeViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    navigationController.viewControllers = @[loginViewController];
                    self.frostedViewController.contentViewController = navigationController;
                    [self.frostedViewController hideMenuViewController];
                }
            }
           else
           {
               if (indexPath.section == 5)
               {
                   DEMOHomeViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                   navigationController.viewControllers = @[profileViewController];
                   self.frostedViewController.contentViewController = navigationController;
                   [self.frostedViewController hideMenuViewController];
               }
               else if (indexPath.section == 6)
               {
                   DEMOHomeViewController *contactViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
                   navigationController.viewControllers = @[contactViewController];
                   self.frostedViewController.contentViewController = navigationController;
                   [self.frostedViewController hideMenuViewController];
               }
               else if (indexPath.section == 4)
               {
                   DEMOHomeViewController *favViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FavViewController"];
                   navigationController.viewControllers = @[favViewController];
                   self.frostedViewController.contentViewController = navigationController;
                   [self.frostedViewController hideMenuViewController];
               }
               else if (indexPath.section == 7)
               {
                   
                   DEMOHomeViewController *tCViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"T&CViewController"];
                   navigationController.viewControllers = @[tCViewController];
                   self.frostedViewController.contentViewController = navigationController;
                   [self.frostedViewController hideMenuViewController];
               }
               else if (indexPath.section == 8)
               {
                   DEMOHomeViewController *privacyPolocyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolocyViewController"];
                   navigationController.viewControllers = @[privacyPolocyViewController];
                   self.frostedViewController.contentViewController = navigationController;
                   [self.frostedViewController hideMenuViewController];
               }
               
               else
               {
                   
                   if ([[NSUserDefaults standardUserDefaults] valueForKey:@"loginData"] != nil)
                   {
                       if (strID.length > 0 )
                       {
                           UIAlertController * alert=[UIAlertController
                                                      
                                                      alertControllerWithTitle:@"Message" message:@"Are you sure you want to Sign out?"preferredStyle:UIAlertControllerStyleAlert];
                           
                           UIAlertAction* yesButton = [UIAlertAction
                                                       actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                                       {
                                                           
                                                           
                                                           NSLog(@"you pressed Yes, please button");
                                                           // call method whatever u need
                                                       }];
                           UIAlertAction* noButton = [UIAlertAction
                                                      actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                                      {
                                                         
                                                          [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sessionID"];
                                                          [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"loginData"];
                                                          [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserID"];
                                                          //  [self dismissViewControllerAnimated:YES completion:nil];
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"loginScreen" object:nil];
                                                          //[self reloadForTableview];
                                                          [[NSUserDefaults standardUserDefaults] setObject:@"slider" forKey:@"screenFrom"];
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"signOutRemove" object:nil];
                                                          DEMOHomeViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                                          navigationController.viewControllers = @[loginViewController];
                                                          self.frostedViewController.contentViewController = navigationController;
                                                          [self.frostedViewController hideMenuViewController];
                                                          //signOutRemove
                                                          NSLog(@"you pressed No, thanks button");
                                                          // call method whatever u need
                                                          
                                                      }];
                           
                           [alert addAction:yesButton];
                           [alert addAction:noButton];
                           
                           [self presentViewController:alert animated:YES completion:nil];
                       }
                       else
                       {
                           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please login first" preferredStyle:UIAlertControllerStyleAlert];
                           [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                           [self presentViewController:alertController animated:YES completion:nil];
                       }
                   }
                   else
                   {
                       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please login first" preferredStyle:UIAlertControllerStyleAlert];
                       [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                       [self presentViewController:alertController animated:YES completion:nil];
                   }
               }
           }
        }
        else
        {
            NSLog(@"indexPath.section >>>%ld",(long)indexPath.section);
            if (indexPath.section == 4) {
                DEMOHomeViewController *contactViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
                navigationController.viewControllers = @[contactViewController];
                self.frostedViewController.contentViewController = navigationController;
                [self.frostedViewController hideMenuViewController];
            }
            else if(indexPath.section == 5)
            {
                DEMOHomeViewController *tCViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"T&CViewController"];
                navigationController.viewControllers = @[tCViewController];
                self.frostedViewController.contentViewController = navigationController;
                [self.frostedViewController hideMenuViewController];
 
            }
            else if(indexPath.section == 6)
            {
                DEMOHomeViewController *privacyPolocyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolocyViewController"];
                navigationController.viewControllers = @[privacyPolocyViewController];
                self.frostedViewController.contentViewController = navigationController;
                [self.frostedViewController hideMenuViewController];
   
            }

            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"slider" forKey:@"screenFrom"];
                DEMOHomeViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                navigationController.viewControllers = @[loginViewController];
                self.frostedViewController.contentViewController = navigationController;
                [self.frostedViewController hideMenuViewController];
            }
            
        }
       
       
    }
  // [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:0.0/255.0 blue:20.0/255.0 alpha:1.0];
    
}

#pragma mark -
#pragma mark UITableView Datasource
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return imageData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (expandedSection>-1)
    {
        NSMutableArray *arrayKeys = [[NSUserDefaults standardUserDefaults] valueForKey:@"sideKeys"];
        if ((arrayKeys.count > 0) && (arrayKeys.count < 2))
        {
            if (expandedSection==2&&sectionIndex==2)
            {
                NSString *strKey = [arrayKeys objectAtIndex:0];
                return [[[arrayExpand objectAtIndex:0] objectForKey:strKey] count] + 1;
            }
            else
            {
                
                return 1;
            }
        }
        else
        {
            if (expandedSection==3&&sectionIndex==3)
            {
                NSString *strKey = [arrayKeys objectAtIndex:1];
                return [[[arrayExpand objectAtIndex:1] objectForKey:strKey] count];
            }
            else
            {
                return 1;
            }
        }
    }
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellMenu";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.imageView.frame = CGRectMake(10, 20, 15,15 );
    cell.textLabel.frame = CGRectMake(30, 20,120,30 );
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imgArrow = (UIImageView *) [cell viewWithTag:101];
    imgArrow.hidden = true;
    UIImageView *imgIcon = (UIImageView *) [cell viewWithTag:112];
    imgIcon.hidden = true;
    if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            imgArrow.hidden = false;
            cell.textLabel.text = [[imageData objectAtIndex:indexPath.section] uppercaseString];
            NSString *strTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastSelectedSide"];
            NSLog(@"cell.textLabel.text >>>%@  %@",cell.textLabel.text,strTitle);
            if ([strTitle isEqualToString:cell.textLabel.text]) {
                cell.textLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:0.0/255.0 blue:20.0/255.0 alpha:1.0];
            }
            else
            {
                cell.textLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:16];
                cell.textLabel.textColor = [UIColor whiteColor];
            }
            cell.textLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:16];
           // cell.textLabel.backgroundColor = [UIColor redColor];
            NSLog(@"cell >>>%f",cell.textLabel.frame.size.width);
          //  self.imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            //cell.imageView.image  =  [UIImage imageNamed:@"play"];
           // cell.imageView.frame = CGRectMake(140, 5, 10, 10);
            //arrow-down
            imgArrow.frame = CGRectMake(cell.textLabel.frame.size.width-20, 11, 10, 10);
            if ( expandedSection!=-1)
            {
                imgArrow.image = [UIImage imageNamed:@"up_Img.png"];
            }
            else
            {
                imgArrow.image = [UIImage imageNamed:@"down_Img.png"];
            }
        }
        else
        {
            
            NSMutableArray *arrayKeys = [[NSUserDefaults standardUserDefaults] valueForKey:@"sideKeys"];
            NSString *strKey = [arrayKeys objectAtIndex:0];
            imgIcon.hidden = false;
            NSLog(@"expand >>>>%@",[[arrayExpand objectAtIndex:0] objectForKey:strKey]);
            NSString *strName = [[[[arrayExpand objectAtIndex:0] objectForKey:strKey] objectAtIndex:indexPath.row-1] objectForKey:@"name"];
            if ([strName isEqualToString:@"Football"]) {
                imgIcon.image = [UIImage imageNamed:@"Football.png"];
            }
            else if ([strName isEqualToString:@"Basketball"]) {
                imgIcon.image = [UIImage imageNamed:@"Basketball.png"];
            }
            else if ([strName isEqualToString:@"Motorsport"]) {
                imgIcon.image = [UIImage imageNamed:@"Motorsport.png"];
            }
            else if ([strName isEqualToString:@"Baseball"]) {
                imgIcon.image = [UIImage imageNamed:@"Baseball.png"];
            }
            else if ([strName isEqualToString:@"Fight"]) {
                imgIcon.image = [UIImage imageNamed:@"Fight.png"];
            }
            else if ([strName isEqualToString:@"Golf"]) {
                imgIcon.image = [UIImage imageNamed:@"Golf.png"];
            }
            else if ([strName isEqualToString:@"Table Tennis"]) {
                imgIcon.image = [UIImage imageNamed:@"TableTennisicon.png"];
            }
            else if ([strName isEqualToString:@"Tennis"]) {
                imgIcon.image = [UIImage imageNamed:@"Tennis.png"];
            }
            else if ([strName isEqualToString:@"Cricket"]) {
                imgIcon.image = [UIImage imageNamed:@"Cricket_Icon.png"];
            }
            else if ([strName isEqualToString:@"Rugby"]) {
                imgIcon.image = [UIImage imageNamed:@"Rugby.png"];
            }
            else if ([strName isEqualToString:@"Cycling"]) {
                imgIcon.image = [UIImage imageNamed:@"Cycling.png"];
            }
            cell.textLabel.text = [[NSString stringWithFormat:@"        %@",[[[[arrayExpand objectAtIndex:0] objectForKey:strKey] objectAtIndex:indexPath.row-1] objectForKey:@"name"]] uppercaseString];//[NSString stringWithFormat:@"  -%@",[[arrayExpand objectAtIndex:indexPath.row-1] objectForKey:@"name"] ];
            cell.textLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:13];
             NSLog(@"cell expand>>>%f",cell.textLabel.frame.size.width);
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        
    }
    else
    {
        cell.textLabel.text = [imageData objectAtIndex:indexPath.section] ;
        
        NSString *strTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastSelectedSide"];
        NSLog(@"cell.textLabel.text >>>%@  %@",cell.textLabel.text,strTitle);
        if ([strTitle isEqualToString:cell.textLabel.text]) {
            cell.textLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:0.0/255.0 blue:20.0/255.0 alpha:1.0];
        }
        else
        {
            cell.textLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:16];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        
        NSLog(@"cell new>>>%f",cell.textLabel.frame.size.width);
    }
    
    
    
    
    
    //cell.imageView.image  =  [UIImage imageNamed:[imageData objectAtIndex:indexPath.row]];
    //    }
    return cell;
}

@end
