//
//  CZFlowLayout.m
//  自定义流水布局
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 cz.cn. All rights reserved.
//

#import "CZFlowLayout.h"
#define  KtotalH 4 *  smallViewH  * totalGroupCount  + marginH * (totalGroupCount * 4)
@interface CZFlowLayout ()


@property (nonatomic , assign)CGFloat  Height;


@end

@implementation CZFlowLayout


//懒加载数组
- (NSArray<UICollectionViewLayoutAttributes *> *)attributes
{
    if (_attributes == nil) {
        
        _attributes = [NSArray array];
    }

    return _attributes;
}

- (void)prepareLayout{

    [super prepareLayout];
    self.minimumInteritemSpacing = 5;
    self.minimumLineSpacing =  self.minimumInteritemSpacing;
    
    CGFloat marginW = self.minimumInteritemSpacing;
    CGFloat marginH = self.minimumLineSpacing;
    

    
    //获取cell的总数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
//    NSLog(@"%ld",count);
    
    
    //设置尺寸
    
    //大视图宽度
    
    CGFloat contentW = self.collectionView.frame.size.width - marginW*4;
//    CGFloat contentH = Kheight - 20 - 44 - 44 - 40 - marginH*4;

    
    
    
    //小视图的宽度 及高度
    CGFloat smallViewW = contentW/3.0;
    CGFloat smallViewH = smallViewW;
    //大视图的宽度 及高度
    CGFloat bigViewW = smallViewW;
    CGFloat bigViewH = smallViewH*2.0 + marginH;

    
    //中视图的宽度 及高度
    CGFloat midViewW = bigViewH;
    CGFloat midViewH = bigViewW;
    
    //中2视图的宽度及高度
    CGFloat midTwoViewW = (contentW + marginW)/2.0;
    CGFloat midTwoViewH = smallViewH;
    
    //创建临时数组 盛放布局属性
    
    NSMutableArray *tempAtt = [NSMutableArray array];
    //计算一共的组数
    int totalGroupCount = (int)count / 9; //有时会有多余的

    
    //计算组的总高度
    
    CGFloat groupH = 4 * marginH + smallViewH*4;
    
    
    //进行for  次数为 cell的个数  创建 att对象  并且放在对应的数组里面
    for (int i = 0; i < count; i ++) {
   
        //计算对应的组数
        
        int groupIndex = i / 9.0;
        
    
        //得到对应cell在这一组中的标号
        int index = i % 9;
        
        //计算每一个cell的布局
        
        CGFloat itemW;
        CGFloat itemH;
        CGFloat itemX;
        CGFloat itemY;
        
        switch (index) {
            case 0:
                itemX = marginW;
                itemY = marginH + groupIndex * groupH;
                itemW = midTwoViewW;
                itemH = midTwoViewH;

                break;
            case 1:
                itemX = midTwoViewW  + marginW*2;
                itemY =  marginH + groupIndex * groupH ;
                itemW = midTwoViewW;
                itemH = midTwoViewH;
                break;
            case 2:
                itemX = marginW;
                itemY = midTwoViewH + marginH*2 + groupIndex * groupH ;
                itemW = smallViewW;
                itemH = smallViewH;
                
                break;
            case 3:
                itemX = smallViewW + marginW*2;
                itemY = midTwoViewH + marginH*2 + groupIndex * groupH ;
                itemW = smallViewW;
                itemH = smallViewH;
                break;
            case 4:
                itemX = smallViewW*2  + marginW* 3;
                itemY = midTwoViewH + marginH*2 + groupIndex * groupH ;
                itemW = smallViewW;
                itemH = smallViewH;
                break;
                
            case 5:
                itemX = marginW;
                itemY = smallViewH*2 + marginH*3 +  + groupIndex * groupH;
                itemW = bigViewW;
                itemH = bigViewH;
                break;
            case 6:
                itemX = marginW*2 + bigViewW;
                itemY = smallViewH*2 + marginH*3 +  + groupIndex * groupH;
                itemW = midViewW;
                itemH = midViewH;
                break;
            case 7:
                itemX = marginW*2 + bigViewW;
                itemY = smallViewH*2 + marginH*4 + midTwoViewH +  + groupIndex * groupH;
                itemW = smallViewW;
                itemH = smallViewH;
                break;
            case 8:
                itemX = marginW*3 + bigViewW + smallViewW;
                itemY = smallViewH*2 + marginH*4 + midTwoViewH +  + groupIndex * groupH;
                itemW = smallViewW;
                itemH = smallViewH;
                break;
            default:
                break;
        }
        
        
        
        //创建布局属性 设置对应cell的frame
        UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        att.frame = CGRectMake(itemX , itemY , itemW, itemH);
    
        
        [tempAtt addObject:att];
        
    }
    
    self.attributes = [tempAtt copy];
    
    
    //计算itemsize
    //目的:让collectionView正好能滚动到最底部  比较不好理解
    CGFloat itemSizeW;
    CGFloat itemSizeH;
    
    //计算除去整租剩几个
    
    int yushu = count % 9;
    
    if (yushu == 0) {
        
        //总高度 =   groupH * totalGroupCount
        //有效高度  内容的高度为 4 * smallViewH * totalGroupCount
         _Height = KtotalH;
    
    }else if (yushu == 1 || yushu == 2){
        //33
        //2组         8个间隙
        //13
        itemSizeW = midTwoViewW;
        itemSizeH = midTwoViewH;
        _Height =KtotalH + marginH + itemSizeH;

        
    }else if (yushu == 3 || yushu == 4  || yushu == 5){
        

        itemSizeW = smallViewW;
        itemSizeH = smallViewH;
        _Height = KtotalH + marginH*2+ midTwoViewH + itemSizeH;

        
    }else if(yushu == 6  ){
        
       
        itemSizeW = bigViewW;
        itemSizeH = bigViewH;
        _Height = KtotalH + bigViewH + marginH * 3 + smallViewH + midTwoViewH;
        

    
    }else if(yushu == 7 ){
     
        itemSizeW = midViewW;
        itemSizeH = midViewH;
        _Height = KtotalH + itemSizeH + marginH * 3 + smallViewH + midTwoViewH;
        

    }else if(yushu == 8 ){
        itemSizeW = smallViewW;
        itemSizeH = smallViewH;
        _Height = KtotalH + itemSizeH + marginH * 3 + smallViewH + midTwoViewH;
        

    }
    
    self.itemSize =CGSizeMake(itemSizeW, itemSizeH);


}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{

    return self.attributes;
}
- (CGSize)collectionViewContentSize
{

    CGSize contentSize = CGSizeMake(Kwidth,_Height + 50);
    return contentSize;
}



@end
