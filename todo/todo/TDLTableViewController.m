//
//  TDLTableViewController.m
//  todo
//
//  Created by Jeffery Moulds on 4/2/14.
//  Copyright (c) 2014 Jeffery Moulds. All rights reserved.
//

#import "TDLTableViewController.h"

#import "TDLTableViewCell.h"

#import "TDLGitHubRequest.h"

#import "TDLSingleton.h"

@implementation TDLTableViewController

{
 
    UITextField * nameField;

}

- (void)toggleEdit

{


}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
        self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
        self.tableView.rowHeight = 100;

                
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        
        self.tableView.tableHeaderView = header;

        nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 160, 30)];
        nameField.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];
        nameField.layer.cornerRadius = 6;
        
        nameField.delegate = self;
        
        [header addSubview:nameField];

        
        UIButton * submitButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 100, 30)];
        [submitButton setTitle:@"New User" forState:UIControlStateNormal];
        submitButton.titleLabel.font = [UIFont systemFontOfSize:12];
        submitButton.backgroundColor = [UIColor darkGrayColor];
        submitButton.layer.cornerRadius = 6;
        [submitButton addTarget:self action:@selector(newUser) forControlEvents:UIControlEventTouchUpInside];
        
        [header addSubview:submitButton];
        
        
        
        UILabel * titleHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 280, 30)];
        titleHeader.text = @"GitHub Users";
        titleHeader.textColor = [UIColor lightGrayColor];
        titleHeader.font = [UIFont systemFontOfSize:26];

        [header addSubview:titleHeader];
        
        
 
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        footer.backgroundColor = [UIColor grayColor];

        UILabel * titlefooter = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
        titlefooter.text = @"End of List";
        titlefooter.textColor = [UIColor whiteColor];

        [footer addSubview:titlefooter];
        self.tableView.tableFooterView = footer;
        
        
}
    return self;
}



- (void)newUser
{
    NSString * username = nameField.text;
    nameField.text = @"";

//    NSLog(@"clicking");

    
    NSDictionary * userInfo = [TDLGitHubRequest getUserWithUsername:username];
    
    if([[userInfo allKeys] count] ==3)
    {
        [[TDLSingleton sharedCollection] addListItem:userInfo];

} else {

    NSLog(@"Not Enough Data");
    
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Bad Information" message:@"Unable to Add User" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
 
        [alertView show];
    
    }
    
    [nameField resignFirstResponder];

    [self.tableView reloadData];
    
//    NSLog(@"listItems Count : %d",[listItems count]);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
//    NSLog(@"return key");
    [self newUser];
    return YES;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    UIBarButtonItem * addGitHubUser = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openNewUser)];
    
    self.navigationItem.leftBarButtonItem = addGitHubUser;


    
    
}

-(void)openNewUser
{



}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[[TDLSingleton sharedCollection]allListItems] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{

    TDLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];


    if (cell == nil) cell = [[TDLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.index = indexPath.row;
    
    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSDictionary * listItem = [[TDLSingleton sharedCollection] allListItems] [indexPath.row];
    
    NSLog(@"%@", listItem);

    UIViewController * webController =[[UIViewController alloc] init];
    
    UIWebView * webView = [[UIWebView alloc] init];

    webController.view = webView;
    

    
    [self.navigationController pushViewController:webController animated:YES];
    
    NSURL * url = [NSURL URLWithString:listItem[@"github"]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

    {
    return YES;
    };


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{


    [[TDLSingleton sharedCollection] removeListItemAtIndex:indexPath.row];

    TDLTableViewCell *cell = (TDLTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.alpha = .0;
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];



}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




@end
