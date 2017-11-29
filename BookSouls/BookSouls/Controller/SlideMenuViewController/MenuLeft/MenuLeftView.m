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
#import "UIColor+HexString.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"

#define HEIGHT_CELL_MENU 60


@interface MenuLeftView ()
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
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

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self){
        
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
    
    [self loadUserInfo];
    
    [self createListMenu];
    
}

#pragma mark - Action

- (IBAction)touchBtnSignOut:(id)sender {
    
    Appdelegate_BookSouls.sesstionUser = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"FirstRun"];
    [defaults synchronize];
    
    [Common showAlertCancel:[SlideMenuViewController sharedInstance] title:@"Thông báo" message:@"Bạn có chắc muốn đăng xuất" buttonClick:^(UIAlertAction *alertAction) {
  
        SlideMenuViewController *vcSlideMenu = [SlideMenuViewController sharedInstance];
       
       
        if(vcSlideMenu.navigationController.viewControllers.count > 1){
            
             [vcSlideMenu.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *vcLogin = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            [Appdelegate_BookSouls.navigation setViewControllers:@[vcLogin] animated:YES];
        }
        
        [[SlideMenuViewController sharedInstance] performSelector:@selector(toggle) withObject:nil afterDelay:1.0];
        
        [SlideMenuViewController performSelector:@selector(resetSharedInstance) withObject:nil afterDelay:1.0];
        Appdelegate_BookSouls.sesstionUser = nil;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:@"FirstRun"];
        [defaults synchronize];
        
        
        
    } buttonClickCancel:^(UIAlertAction *alertAction) {
        
    }];
    
}



- (IBAction)touchBtnUpdateUserInfo:(id)sender {
    
    
}

#pragma mark - Method

- (IBAction)touchAvatar:(id)sender {
    
     [[SlideMenuViewController sharedInstance] selectedItemInMenu:4];
}

-(void)loadUserInfo{

    self.lblPhone.text = Appdelegate_BookSouls.sesstionUser.profile.phone;
    
    self.lblFullName.text = Appdelegate_BookSouls.sesstionUser.profile.name;
    
    self.lblAddress.text = Appdelegate_BookSouls.sesstionUser.profile.homeAddress;
    
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:Appdelegate_BookSouls.sesstionUser.profile.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
}

- (void)createListMenu{

    self.arrMenus = [NSMutableArray array];
    
    ItemMenu *item_1 = [[ItemMenu alloc] init];
    item_1.itemName = @"Trang chủ";
    item_1.itemIconName = @"";
    [self.arrMenus addObject:item_1];
    
    ItemMenu *item_2 = [[ItemMenu alloc] init];
    item_2.itemName = @"Thông báo";
    item_2.itemIconName = @"";
    [self.arrMenus addObject:item_2];
    
    ItemMenu *item_3 = [[ItemMenu alloc] init];
    item_3.itemName = @"Sách của tôi";
    item_3.itemIconName = @"";
    [self.arrMenus addObject:item_3];
    
    ItemMenu *item_4 = [[ItemMenu alloc] init];
    item_4.itemName = @"Đơn hàng";
    item_4.itemIconName = @"";
    [self.arrMenus addObject:item_4];
    
    ItemMenu *item_5 = [[ItemMenu alloc] init];
    item_5.itemName = @"Hồ sơ";
    item_5.itemIconName = @"";
    [self.arrMenus addObject:item_5];
    
    ItemMenu *item_6 = [[ItemMenu alloc] init];
    item_6.itemName = @"Hỗ trợ";
    item_6.itemIconName = @"";
    [self.arrMenus addObject:item_6];
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
