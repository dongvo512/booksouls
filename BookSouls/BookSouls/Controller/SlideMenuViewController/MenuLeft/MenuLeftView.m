//
//  MenuLeftView.m
//  hairista
//
//  Created by Dong Vo on 1/26/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "MenuLeftView.h"
#import "MenuCell.h"
#import "ItemMenu.h"
#import "SlideMenuViewController.h"
#import "UIColor+Method.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"

#define HEIGHT_CELL_MENU 60


@interface MenuLeftView ()
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UITableView *tblViewMenu;
@property (nonatomic, strong) NSMutableArray *arrMenus;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateUserInfo;


@end

@implementation MenuLeftView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame isUserManager:(BOOL)isUserManager isAdmin:(BOOL)isAdmin{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.isUserManager = isUserManager;
        self.isAdmin = isAdmin;
        [self setup];
    }
    
    return self;
}
- (id) init:(BOOL)isUserManager isAdmin:(BOOL)isAdmin{

    self = [super init];
    
    if(self){
        
        self.isUserManager = isUserManager;
        self.isAdmin = isAdmin;
        [self setup];
    }
    
    return self;
}
- (void)setup{
    
     self.view = [[NSBundle mainBundle] loadNibNamed:@"MenuLeftView" owner:self options:nil].firstObject;
    self.clipsToBounds = YES;
    
    self.view.frame = self.bounds;
    
    [self addSubview:self.view];
    
    [self.tblViewMenu registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
   
    if(self.isAdmin){
    
        [self.btnUpdateUserInfo setUserInteractionEnabled:NO];
    }
    
    [self loadUserInfo];
    
    [self createListMenu];
    
}

#pragma mark - Action
//- (IBAction)touchLogout:(id)sender {
//
//    Appdelegate_hairista.sessionUser = nil;
//
//    LoginViewController *vcLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:nil forKey:@"FirstRun"];
//    [defaults synchronize];
//
//
//    [[SlideMenuViewController sharedInstance] presentViewController:vcLogin animated:YES completion:^{
//
//        [SlideMenuViewController resetSharedInstance];
//    }];
//}

- (IBAction)touchBtnUpdateUserInfo:(id)sender {
    
    if(self.isUserManager){
    
        [[SlideMenuViewController sharedInstance] selectedItemInMenu:Item_InFoUserManger];
    }
    else{
    
        [[SlideMenuViewController sharedInstance] selectedItemInMenu:Item_InfoUser];
    }
    
    
}

#pragma mark - Method

- (IBAction)touchAvatar:(id)sender {
    
     [[SlideMenuViewController sharedInstance] selectedItemInMenu:4];
}

-(void)loadUserInfo{

    self.lblPhone.text = @"0932188608";
    
    //NSLog(@"%@",Appdelegate_hairista.sessionUser.phone);
    
    self.lblFullName.text = @"Võ Nguyên Đông";
    // NSLog(@"%@",Appdelegate_hairista.sessionUser.name);
    
    self.lblEmail.text = @"dongvo512@gmail.com";
    // NSLog(@"%@",Appdelegate_hairista.sessionUser.email);
    
    [self.imgAvatar sd_setImageWithURL:@"" placeholderImage:IMG_USER_DEFAULT];
}

- (void)createListMenu{

    self.arrMenus = [NSMutableArray array];
    
    if(self.isUserManager){
    
        ItemMenu *item_1 = [[ItemMenu alloc] init];
        item_1.itemName = @"Lịch hẹn";
        item_1.itemIconName = @"ic_booking";
        
        [self.arrMenus addObject:item_1];
        
        ItemMenu *item_2 = [[ItemMenu alloc] init];
        item_2.itemName = @"Khách hàng";
        item_2.itemIconName = @"Ic_user";
        
        [self.arrMenus addObject:item_2];
        
        
        ItemMenu *item_3 = [[ItemMenu alloc] init];
        item_3.itemName = @"Dịch vụ";
        item_3.itemIconName = @"ic_salon";
        [self.arrMenus addObject:item_3];

        
        ItemMenu *item_4 = [[ItemMenu alloc] init];
        item_4.itemName = @"Hình ảnh";
        item_4.itemIconName = @"ic_gallery";
        [self.arrMenus addObject:item_4];
        
        ItemMenu *item_5 = [[ItemMenu alloc] init];
        item_5.itemName = @"Bình luận";
        item_5.itemIconName = @"ic_comment";
        [self.arrMenus addObject:item_5];
        
    }
    else if (self.isAdmin){
    
        ItemMenu *item_1 = [[ItemMenu alloc] init];
        item_1.itemName = @"Salons";
        item_1.itemIconName = @"ic_salon";
        
        [self.arrMenus addObject:item_1];
        
        ItemMenu *item_2 = [[ItemMenu alloc] init];
        item_2.itemName = @"Người dùng";
        item_2.itemIconName = @"Ic_user";
        
        [self.arrMenus addObject:item_2];
    }
    else{
    
        
        ItemMenu *item_1 = [[ItemMenu alloc] init];
        item_1.itemName = @"Salon tóc";
        item_1.itemIconName = @"ic_salon";
        
        [self.arrMenus addObject:item_1];
        
        ItemMenu *item_2 = [[ItemMenu alloc] init];
        item_2.itemName = @"Hình ảnh";
        item_2.itemIconName = @"ic_hair";
        
        [self.arrMenus addObject:item_2];
        
        
        ItemMenu *item_3 = [[ItemMenu alloc] init];
        item_3.itemName = @"Salon yêu thích";
        item_3.itemIconName = @"ic_favorite";
        
        [self.arrMenus addObject:item_3];
        
        ItemMenu *item_4 = [[ItemMenu alloc] init];
        item_4.itemName = @"Lịch hẹn";
        item_4.itemIconName = @"ic_booking";
        
        [self.arrMenus addObject:item_4];
    }
}

#pragma mark - Table view DataSource - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrMenus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    ItemMenu *item = [self.arrMenus objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   /* cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorFromHexString:@"BF0A6A"];
    [cell setSelectedBackgroundView:bgColorView];*/
    [cell setDataForCell:item];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HEIGHT_CELL_MENU;
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[SlideMenuViewController sharedInstance] selectedItemInMenu:indexPath.row];
    
}

@end
