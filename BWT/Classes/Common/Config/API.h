
//
//  API.h
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#ifndef API_h
#define API_h



#define Host_url_test @"http://test.yunloan.net:9303/"
#define Host_url_Product @"https://lease.lianlianloan.com/"

// 用户协议
#define User_xieyi @"user-service-agreement.html"
// 隐私政策
#define User_yinsi @"privacy-policy.html"


#pragma mark - 商品
// 类目列表
#define Goods_category_list @"/services/goodsFrontCategoryServer/listGoodsFrontCategory.do"
// 推荐品牌
#define Goods_recommand_brand_list @"/services/goodsFrontCategoryServer/listRecommandAttribute.do"
// 商品列表
#define Goods_list @"/services/goodsServer/pageGoods.do"
// 商品详情
#define Good_detail @"/services/goodsServer/queryGoodsDetail.do"
// 商品SKU
#define Good_SKU @"/services/goodsServer/queryGoodsDetailByGoodsSkuId.do"

#pragma mark - 购物车
// 购物车商品列表
#define ShoppingCart_good_list @"/services/shoppingcart/getShoppingCartList.do"
// 购物车商品数
#define ShoppingCart_good_num @"/services/shoppingcart/getShoppingCartCount.do"
// 添加到购物车
#define ShoppingCart_good_add @"/services/shoppingcart/addShoppingCart.do"
// 移除购物车
#define ShoppingCart_good_remove @"/services/shoppingcart/deleteShoppingCart.do"
// 添加到购物车
#define ShoppingCart_creat_order @"/services/leaseordershoes/createLeaseOrderMultiV2.do"
// 购物车结算信息查询
#define ShoppingCart_final_info @"/services/shoppingcart/selectCleanShoppingCart.do"
// 购物车数量变更
#define ShoppingCart_good_num_change @"/services/shoppingcart/changeItemCount.do"

#pragma mark - 收藏夹
// 商品是否收藏
#define Goods_is_collect @"/services/shoppingcart/isGoodsFavor.do"
// 添加到收藏夹
#define Goods_add_favor @"/services/shoppingcart/addGoodsFavor.do"
// 收藏夹商品列表
#define Goods_favor_list @"/services/shoppingcart/favorList.do"
// 移除收藏夹
#define Good_remove_favor @"/services/shoppingcart/cancelGoodsFavor.do"



#pragma mark - 收货地址
// 收货地址列表
#define Address_list @"/services/shippingaddress/shippingAddressList.do"
// 更新收货地址
#define Address_update @"/services/shippingaddress/updateShippingAddressV1.do"
// 删除收货地址
#define Address_delete @"/services/shippingaddress/deleteShippingAddress.do"
// 创建收货地址
#define Address_create @"/services/shippingaddress/createShippingAddressV1.do"
// 收货地址详情
#define Address_detail @"/services/shippingaddress/selShippingAddressByIdV1.do"
// 查询默认收货地址
#define Address_default @"/services/shippingaddress/defaultShippingAddressV1.do"


#pragma mark - 我的订单
// 我的订单列表
#define Order_list @"/services/leaseordershoes/queryLeaseOrderList.do"
// 订单详情
#define Order_detail @"/services/leaseordershoes/queryLeaseOrderDetail.do"
// 删除订单
#define Order_delete @"/services/leaseordershoes/deleteLeaseOrder.do"
// 取消订单
#define Order_cancel @"/services/leaseordershoes/cancelOrder.do"
// 提交订单
#define Order_create @"/services/leaseordershoes/createLeaseOrder.do"
// 确认收货
#define Order_sure @"/services/leaseordershoes/confirmReceived.do"

#pragma mark - 优惠劵
// 优惠劵列表
#define Coupon_list @"/services/user/queryMyCouponShoes.do"
// 领取优惠劵
#define Coupon_get @"/services/user/receiveShoesCoupon.do"
// 是否展示新人领取优惠劵
#define Coupon_get_show_newpeople @"/services/user/showAppCouponPop.do"
// 可用优惠劵列表
#define Coupon_canuse_list @"/services/leaseordershoes/queryUserCouponShoes.do"
// 可用优惠劵数量
#define Coupon_canuse_num @"/services/leaseordershoes/queryUseableCouponShoes.do"

#pragma mark - 用户登录相关
// 获取验证码
#define User_get_vertifi @"/services/leaseadmin/sendBwtdOtp.do"
// 用户登录注册（注册即登录）
#define User_register_and_login @"/services/user/registerAndLoginAppUser.do"
// 微信登录
#define User_login_weixin @"/services/user/thirdPlatformLogin.do"
// 获取用户信息
#define User_info_get @"/services/user/queryCommonUserInfo.do"
// 绑定手机号
#define User_bound_phone @"/services/leaseback/bundBwtdMobile.do"
// APP版本信息s，升级监测
#define Version_info @"/services/commonServer/checkAppVersion.do"

#pragma mark - 支付相关
// 微信支付
#define Pay_weixin @"/services/wxpay/unifiedOrderShoesApp.do"
// 支付宝支付
#define Pay_ali @"/services/alipay/createOrderAppTrade.do"

#endif /* API_h */
