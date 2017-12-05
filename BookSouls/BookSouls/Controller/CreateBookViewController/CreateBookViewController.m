//
//  CreateBookViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/14/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "CreateBookViewController.h"
#import "TextFieldView.h"
#import "PreviewBarcodeViewController.h"
#import "TBXML.h"
#import "Book.h"
#import "Image.h"
#import "BookSearchViewController.h"
#import "CategoriesViewController.h"
#import "StatusBookViewController.h"
#import "Categories.h"
#import "ImageBookCell.h"
#import "Image.h"
#import "ImagePickerViewController.h"
#import "PreviewImageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Categories.h"
#import "BookImageViewController.h"
#import "MainViewController.h"

#define WIDTH_ITEM_IMAGE 90
#define HEIGHT_ITEM_IMAGE 62

@interface CreateBookViewController ()<CLLocationManagerDelegate>{
    
    TBXML *tbXML;
    
    Book *bookCurr;
     
     CLLocationManager *localManager;
    
    ImagePickerViewController *vcImagePicker;
    
   NSString *categoryID;
    
    BOOL isAddImageDefault;
    
    float lat;
    float lng;
}

@property (weak, nonatomic) IBOutlet TextFieldView *tfViewQuality;

@property (weak, nonatomic) IBOutlet TextFieldView *tfViewNXB;
@property (weak, nonatomic) IBOutlet TextFieldView *tfViewBookName;
@property (weak, nonatomic) IBOutlet TextFieldView *tfViewAuthor;
@property (weak, nonatomic) IBOutlet TextFieldView *tfViewCategories;
@property (weak, nonatomic) IBOutlet TextFieldView *tfViewBarcode;
@property (weak, nonatomic) IBOutlet TextFieldView *tfViewStatusBook;
@property (weak, nonatomic) IBOutlet TextFieldView *tfPrice;
@property (weak, nonatomic) IBOutlet TextFieldView *tfDescription;
@property (nonatomic, strong) NSMutableArray *arrImages;
@property (nonatomic, strong) NSMutableArray *arrBooks;
@property (weak, nonatomic) IBOutlet UICollectionView *cllImages;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;

@end

@implementation CreateBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!localManager){
        
        localManager = [[CLLocationManager alloc] init];
        
        localManager.delegate = self;
        localManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    
    
    if([localManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        
        [localManager requestWhenInUseAuthorization];
        
        [localManager startUpdatingLocation];
    }
    
    
    [self configUI];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    vcImagePicker = [[ImagePickerViewController alloc] init];
    vcImagePicker.delegateImg = self;
    vcImagePicker.vcParent = self;
    
    [self loadDataEditing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnCreateBook:(id)sender {
    
    [self.view endEditing:YES];
    
    if(self.isEdit){
        
        [self updateBook];
    }
    else{
        
        [self createBook];
    }
}

- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)touchBtnStatus:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StatusBookViewController *vcStatus = [storyboard instantiateViewControllerWithIdentifier:@"StatusBookViewController"];
    vcStatus.delegate = self;
    [vcStatus presentInParentViewController:self];
}


- (IBAction)touchBtnCategories:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoriesViewController *vcCategories = [storyboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
    vcCategories.delegate = self;
    [vcCategories presentInParentViewController:self];
    
}
- (IBAction)touchBtnBarcode:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreviewBarcodeViewController *vcPreviewBarcode = [storyboard instantiateViewControllerWithIdentifier:@"PreviewBarcodeViewController"];
    vcPreviewBarcode.delegate = self;
    [self.navigationController pushViewController:vcPreviewBarcode animated:YES];
}

#pragma mark - Call API

- (void)updateBook{
    
    NSString *error = [self checkValidate];
    
    if(error.length > 0 ){
        
        [Common showAlert:self title:@"Thông báo" message:error buttonClick:nil];
    }
    else{
        
        NSDictionary *dic = @{@"description":self.tfDescription.tfContent.text, @"lat":(lat!= 0)?@(lat):@"", @"lng":(lng != 0)?@(lng):@"",@"images":[self getlListIdImageStr], @"categoryId":categoryID, @"price":[self getValueFromPrice], @"name":self.tfViewBookName.tfContent.text, @"author":self.tfViewAuthor.tfContent.text,@"nxb":self.tfViewNXB.tfContent.text, @"subStatus":self.tfViewStatusBook.tfContent.text, @"qty":self.tfViewQuality.tfContent.text,@"isbn":(self.tfViewBarcode.tfContent.text)?self.tfViewBarcode.tfContent.text:@""};
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@posts/%@/update",URL_DEFAULT,self.bookEdit.id.stringValue] withHttpMethod:kHTTP_METHOD_PUT withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(isError){
                
                [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
            }
            else{
                
                [Common showAlert:self title:@"Thông báo" message:@"Cập nhật sách thành công" buttonClick:^(UIAlertAction *alertAction) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                NSError *error;
                
                Book *book = [[Book alloc] initWithDictionary:responseDataObject error:&error];
                book.descriptionStr = [dic objectForKey:@"description"];
                if([[self delegate] respondsToSelector:@selector(finishEditing:bookEdit:)]){
                    
                    [[self delegate] finishEditing:book bookEdit:self.bookEdit];
                }
                
            }
        }];
    }
    
}

- (void)createBook{
    
    NSString *error = [self checkValidate];
    
    if(error.length > 0 ){
        
        [Common showAlert:self title:@"Thông báo" message:error buttonClick:nil];
    }
    else{
        
        NSDictionary *dic = @{@"description":self.tfDescription.tfContent.text, @"lat":(lat!= 0)?@(lat):@"", @"lng":(lng != 0)?@(lng):@"",@"images":[self getlListIdImageStr], @"categoryId":categoryID, @"price":[self getValueFromPrice], @"name":self.tfViewBookName.tfContent.text, @"author":self.tfViewAuthor.tfContent.text,@"nxb":self.tfViewNXB.tfContent.text, @"subStatus":self.tfViewStatusBook.tfContent.text, @"qty":self.tfViewQuality.tfContent.text,@"isbn":self.tfViewBarcode.tfContent.text};
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,POST_CREATE_BOOK] withHttpMethod:kHTTP_METHOD_POST withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(isError){
                
                [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
            }
            else{
                
                [Common showAlert:self title:@"Thông báo" message:@"Đăng sách thành công" buttonClick:^(UIAlertAction *alertAction) {
                    
                    MainViewController *vcMain = [self.navigationController.viewControllers firstObject];
                    vcMain.isReloadData = YES;
                    [vcMain.navigationController popViewControllerAnimated:YES];
                }];
                
               // [self clearAllDataInput];
               
            }
        }];
    }
    
}



- (void)uploadImage:(NSData *)data{
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DEFAULT,UPLOAD_IMAGE];
 
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Vui lòng chờ trong giây lát..";
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"newfile.jpg"];
    
    // Save image.
    [data writeToFile:filePath atomically:YES];

    [APIRequestHandler uploadImageWithURLString:url filePath:filePath withHttpMethod:kHTTP_METHOD_POST uploadAPIResult:^(BOOL isError, NSString *stringError, id responseDataObject, NSProgress *progress) {
        
        NSError *error;
        hud.progressObject = progress;
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        
        if(isError){
            
            [hud hideAnimated:YES];
            [Common showAlert:self title:@"Thông báo" message:@"Lỗi upload hình ảnh" buttonClick:nil];
        }
        else{
            
            if(responseDataObject && !isError){
                
                [hud hideAnimated:YES];
                NSError *error;
                NSDictionary *data = [responseDataObject objectForKey:@"data"];
                
                Image *img = [[Image alloc] initWithDictionary:data error:&error];
                img.url = [NSString stringWithFormat:@"http://203.162.76.2/book/public/%@",img.url];
                
                if(img && self.arrImages.count > 0){
                    
                    [self.arrImages insertObject:img atIndex:self.arrImages.count - 1];
                    
                    [self.cllImages insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.arrImages indexOfObject:img] inSection:0]]];
                }
                
            }
            
        }
        
    }];
    
    
}

- (void)searchBook:(NSString *)keyword{
    
    if(keyword.length > 0){
        
        NSString *url = [NSString stringWithFormat:@"%@%@",URL_GOODREADS_SEARCH,[keyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [APIRequestHandler initWithUrlStringXML:url withHttpMethod:kHTTP_METHOD_GET callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(isError){
                
                [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
            }
            else{
                
                tbXML = [[TBXML alloc] initWithXMLData:responseDataObject];
                
                self.arrBooks = [NSMutableArray array];
                
                if (tbXML.rootXMLElement) {
                    
                    [self traverseElementCallWebService:tbXML.rootXMLElement];
                    
                }
                
                if(self.arrBooks.count > 0 ){
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    BookSearchViewController *vcBookSearch = [storyboard instantiateViewControllerWithIdentifier:@"BookSearchViewController"];
                    vcBookSearch.arrSearch = self.arrBooks;
                    vcBookSearch.delegate = self;
                    [vcBookSearch presentInParentViewController:self];
                }
                else{
                    
                    [Common showAlert:self title:@"Thông báo" message:@"Không tìm thấy dữ liệu" buttonClick:nil];
                }
                
                
            }
        }];
    }
}

#pragma mark Parse - XML
- (void)traverseElementCallWebService:(TBXMLElement *)element{
    
    do {
        
        NSString *elementName = [TBXML elementName:element];
        
        if ([elementName isEqualToString:@"results"]) {
            tbXML.isHaveDataResponse = TRUE;
            
        }
        
        if (tbXML.isHaveDataResponse) {
            
            if ([elementName isEqualToString:@"work"]) {
                
                bookCurr = [[Book alloc] init];
                [self.arrBooks addObject:bookCurr];
            }
            
            if ([elementName isEqualToString:@"title"]) {
              
                NSString *title = [TBXML textForElement:element];
                NSLog(@"%@",title);
                bookCurr.name = title;
            }
            
            if ([elementName isEqualToString:@"name"] ) {
               
                NSString *author = [TBXML textForElement:element];
                NSLog(@"%@",author);
                bookCurr.author = author;
            }
            
            if ([elementName isEqualToString:@"image_url"]) {
                
                NSString *imgUrl = [TBXML textForElement:element];
                //NSLog(@"%@",imgUrl);
                Image *img = [[Image alloc] init];
                img.url = imgUrl;
                bookCurr.images = [NSMutableArray arrayWithObject:img];
            }
            
        }
        
        if (element->firstChild)
            [self traverseElementCallWebService:element->firstChild];
        
    } while ((element = element->nextSibling));
}

#pragma mark - Method
- (void)configUI{
    
    self.tfViewBarcode.strSubTile = @"Mã barcode";
    self.tfViewBarcode.strIcon = @"";
    self.tfViewBarcode.isDisable = YES;
   // self.tfViewBarcode.tfContent.placeholder = @"Lấy mã barcode";
    [self.tfViewBarcode setDataForTextView];
    
    self.tfViewBookName.strSubTile = @"Tên sách";
    self.tfViewBookName.strIcon = @"";
    [self.tfViewBookName setDataForTextView];
    self.tfViewBookName.delegate = self;
    
    self.tfViewAuthor.strSubTile = @"Tên tác giả";
    //self.tfViewAuthor.strIcon = @"";
    [self.tfViewAuthor setDataForTextView];
    
    self.tfViewCategories.strSubTile = @"Thể loại";
    self.tfViewCategories.strIcon = @"";
    self.tfViewCategories.isDisable = YES;
    //self.tfViewCategories.tfContent.placeholder = @"Chọn thể loại";
    [self.tfViewCategories setDataForTextView];
    
    self.tfViewStatusBook.strSubTile = @"Tình trạng";
    self.tfViewStatusBook.strIcon = @"";
    self.tfViewStatusBook.isDisable = YES;
   // self.tfViewStatusBook.tfContent.placeholder = @"Chọn tình trạng sách";
    [self.tfViewStatusBook setDataForTextView];
    
    self.tfPrice.strSubTile = @"Giá sách";
    self.tfPrice.tfContent.keyboardType = UIKeyboardTypeNumberPad;
    self.tfPrice.isPrice = YES;
   // self.tfPrice.strIcon = @"";
    [self.tfPrice setDataForTextView];
    
    self.tfDescription.strSubTile = @"Mô tả";
    self.tfDescription.tfContent.autocapitalizationType = UITextAutocapitalizationTypeSentences;
   // self.tfDescription.strIcon = @"";
    [self.tfDescription setDataForTextView];
    
    self.tfViewNXB.strSubTile = @"Nhà xuất bản";
   // self.tfViewNXB.strIcon = @"";
    [self.tfViewNXB setDataForTextView];
    
    self.tfViewQuality.strSubTile = @"Số lượng";
    self.tfViewQuality.tfContent.keyboardType = UIKeyboardTypeNumberPad;
    //self.tfViewQuality.strIcon = @"";
    [self.tfViewQuality setDataForTextView];
    
    self.lblTitle.text = self.strTitle;
    
    [self.btnCreate setTitle:self.btnTitle forState:UIControlStateNormal];
    
    self.arrImages = [NSMutableArray array];
    
    Image *img = [[Image alloc] init];
    img.isDefaultIMG = @(1);
    [self.arrImages addObject:img];
    
    [self.cllImages registerNib:[UINib nibWithNibName:@"ImageBookCell" bundle:nil] forCellWithReuseIdentifier:@"ImageBookCell"];
    
    
}

- (void)loadDataEditing{
    
    if(self.isEdit && self.bookEdit && !isAddImageDefault){
        
        isAddImageDefault = YES;
        
        [self.tfViewQuality setDataEditing:self.bookEdit.qty.stringValue];
        
        [self.tfViewBarcode setDataEditing:self.bookEdit.isbn];
        
        [self.tfViewBookName setDataEditing:self.bookEdit.name];
        
        [self.tfViewAuthor setDataEditing:self.bookEdit.author];
        
        NSString *catName = [self getCatNameFromID:self.bookEdit.categoryId];
        
        categoryID = self.bookEdit.categoryId;
        
        if(catName.length > 0 ){
            
            [self.tfViewCategories setDataEditing:catName];
        }
        
        [self.tfViewStatusBook setDataEditing:self.bookEdit.subStatus];
        
        [self.tfPrice setDataEditing:[Common getString3DigitsDot:self.bookEdit.price.integerValue]];
        
        [self.tfDescription setDataEditing:self.bookEdit.descriptionStr];
        
        [self.tfViewNXB setDataEditing:self.bookEdit.nxb];
        
        [self.tfViewQuality setDataEditing:self.bookEdit.qty.stringValue];
        
        self.arrImages = [NSMutableArray arrayWithArray:self.bookEdit.images];
        
        Image *img = [[Image alloc] init];
        img.isDefaultIMG = @(1);
        [self.arrImages addObject:img];
        
        
    }
    
    [self.cllImages reloadData];
}

- (void)clearAllDataInput{
    
    [self.tfViewStatusBook clearData];
    [self.tfViewNXB clearData];
    [self.tfPrice clearData];
    [self.tfViewAuthor clearData];
    [self.tfDescription clearData];
    [self.tfViewBarcode clearData];
    [self.tfViewBookName clearData];
    [self.tfViewCategories clearData];
}

- (NSString *)getValueFromPrice{
    
    NSString *valueTemp = self.tfPrice.tfContent.text;
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *resultString = [[valueTemp componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    return resultString;
}
- (NSString *)checkValidate{
    
    NSString *stringError= @"";
    
    if(self.tfViewBookName.tfContent.text.length == 0){
        
        stringError = @"Tên sách không được để trống";
        
    }
    else if (self.tfViewAuthor.tfContent.text.length == 0){
        
        stringError = @"Tên tác giả không được để trống";
        
    }
    else if (self.tfViewQuality.tfContent.text.length == 0){
        
        stringError = @"Số lượng không được để trống";
        
    }
    else if(self.tfViewCategories.tfContent.text == 0){
        
        stringError = @"Bạn chưa chọn thể loại";
    }
    else if(self.tfViewStatusBook.tfContent.text == 0){
        
        stringError = @"Bạn chưa chọn tình trạng sách";
    }
    else if(self.tfViewNXB.tfContent.text == 0){
        
        stringError = @"Nhà sản xuất không được để trống";
    }
    else if(self.tfDescription.tfContent.text == 0){
        
        stringError = @"Mô tả sách không được để trống";
    }
    else if(self.tfDescription.tfContent.text.length > 200){
        
        stringError = @"Mô tả sách vượt quá giới hạn cho phép";
    }
    else if(self.arrImages.count <= 1){
        
        stringError = @"Bạn chưa chọn hình ảnh cho sách";
    }
    
    return stringError;
}

- (NSMutableString *)getlListIdImageStr{
    
    NSMutableString *strImages = [NSMutableString string];
    
    for(Image *img in self.arrImages){
        
        if(!img.isDefaultIMG){
            
            [strImages appendFormat:@"%@,",img.id.stringValue];
        }
    }
    
    if(strImages.length > 0){
        
        [strImages deleteCharactersInRange:NSMakeRange(strImages.length - 1, 1)];
    }
    
    return strImages;
}

- (NSString *)getCatNameFromID:(NSString *)idCat{
    
    NSString *catName = @"";
   
    NSPredicate *preID = [NSPredicate predicateWithFormat:@"id == %@",[NSNumber numberWithInt:idCat.integerValue]];
    
    if(Appdelegate_BookSouls.arrCategories.count > 0 ){
        
        NSArray *arrResult = [Appdelegate_BookSouls.arrCategories filteredArrayUsingPredicate:preID];
        
        if(arrResult.count > 0 ){
            
            Categories *cat = [arrResult firstObject];
            
            catName = cat.name;
        }
    }
    return catName;
}

#pragma mark - ImagePickerViewControllerDelegate
- (void)finishGetImage:(NSString *)fileName
                 image:(UIImage *)image{
    
    [self performSelector:@selector(showPreviewImage:) withObject:image afterDelay:0.5];
    
}

#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageBookCell" forIndexPath:indexPath];
    cell.delegate = self;
    Image *img = [self.arrImages objectAtIndex:indexPath.row];
    [cell setDataForCell:img];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(90, 62);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Image *img = [self.arrImages objectAtIndex:indexPath.row];
    
    if([img.isDefaultIMG boolValue]){
        
        UIAlertController *vcAlert = [UIAlertController alertControllerWithTitle:@"Hình ảnh" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [vcImagePicker takeAPickture:self];
            
        }];
        
        UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [vcImagePicker cameraRoll:self];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Bỏ qua" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [vcAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [vcAlert addAction:camera];
        [vcAlert addAction:photoLibrary];
        [vcAlert addAction:cancel];
        
        [self presentViewController:vcAlert animated:YES completion:nil];
    }
    else{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BookImageViewController *vcBookImage = [storyboard instantiateViewControllerWithIdentifier:@"BookImageViewController"];
        vcBookImage.arrImages = [self arrReview];
        vcBookImage.indexCurr = indexPath.row;
        vcBookImage.bookName = @"Hình sản phẩm";
        [self presentViewController:vcBookImage animated:YES completion:nil];
        
    }
}

- (NSMutableArray *)arrReview{
    
    NSMutableArray *arrReview = [NSMutableArray array];
    
    for(Image *img in self.arrImages){
        
        if(!img.isDefaultIMG){
            
            [arrReview addObject:img];
        }
    }
    
    return arrReview;
}


- (void)showPreviewImage:(UIImage *)img{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreviewImageViewController *vcPreviewImage = [storyboard instantiateViewControllerWithIdentifier:@"PreviewImageViewController"];
    vcPreviewImage.delegate = self;
    vcPreviewImage.imagePreview = img;
    [self presentViewController:vcPreviewImage animated:YES completion:nil];
}

#pragma mark - PreviewImageViewControllerDelegate

- (void)touchBtnAcept:(UIImage *)img{
    
    NSData *data= nil;
    
    float imgValue = MAX(img.size.width, img.size.height);
    
    if(imgValue > 3000){
        
        data = UIImageJPEGRepresentation(img, 0.1);
        
    }
    else if(imgValue > 2000){
        
        data = UIImageJPEGRepresentation(img, 0.3);
    }
    else{
        
        data = UIImageJPEGRepresentation(img, 0.8);
    }
    
    
    [self uploadImage:data];
}


#pragma mark - PreviewBarcodeViewControllerDelegate
- (void)finishGetBarcode:(NSString *)barcode{
    
    [self.tfViewBarcode setDataEditing:barcode];
    
    [self searchBook:barcode];
}

#pragma mark - TextFieldViewDelegate

- (void)touchIconButton:(TextFieldView *)textField{
    
    if([textField isEqual:self.tfViewBookName]){
        
        [self.view endEditing:YES];
        [self searchBook:self.tfViewBookName.tfContent.text];
    }
}

#pragma mark - BookSearchViewControllerDelegate

- (void)selectedBook:(Book *)book{
    
    if(book){
        
        [self.tfViewBookName setDataEditing:book.name];
        [self.tfViewAuthor setDataEditing:book.author];
    }
}

#pragma mark - CategoriesViewControllerDelegate

- (void)selectedCategories:(Categories *)cat{
    
    if(cat){
        
        [self.tfViewCategories setDataEditing:cat.name];
        categoryID = cat.id.stringValue;
    }
}

#pragma mark - StatusBookViewControllerDelegate
- (void)selectedStatusBook:(NSString *)status{
    
    if(status){
        
        [self.tfViewStatusBook setDataEditing:status];
        
    }
}

#pragma mark - ImageBookCellDelegate
- (void)touchButtonDelete:(Image *)img{
    
    NSInteger indexDelete = [self.arrImages indexOfObject:img];
    
    [self.arrImages removeObject:img];
    
    [self.cllImages deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexDelete inSection:0]]];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        lat = currentLocation.coordinate.latitude;
        lng = currentLocation.coordinate.longitude;
    }
    
    // Stop Location Manager
    [localManager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    // NSLog(@"%@",error.userInfo);
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied){
            
            
            [Common showAlert:self title:@"Thông báo" message:@"Bạn chưa mở định vị toạ độ" buttonClick:nil];
        }
    }
}
@end
