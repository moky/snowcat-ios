//
//  SCParticleView+Designer.m
//  SnowCat
//
//  Created by Moky on 15-1-2.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "scMacros.h"
#import "SCUIKit.h"
#import "SCImage.h"
#import "SCEmitterCell.h"
#import "SCEmitterLayer.h"
#import "SCParticleView.h"

/**
 *
 *  Particle Designer:
 *
 *      https://71squared.com/
 *
 *      http://onebyonedesign.com/flash/particleeditor/ (online)
 *
 */

@implementation SCParticleView (Designer)

// name                   : 粒子的名字
// enabled                : 粒子是否被渲染
// birthRate              : 每秒钟产生的粒子数量，默认是0
// lifetime               : 每一个粒子的生存周期多少秒
// lifetimeRange          : 生命周期变化范围 lifetime = lifetime(+/-)lifetimeRange
// emissionLatitude       : 发射的z轴方向的角度
// emissionLongitude      : x-y平面的发射方向
// emissionRange          : 周围发射角度
// velocity               : 每个粒子的速度
// velocityRange          : 每个粒子的速度变化范围
// xAcceleration          : 粒子x方向的加速度分量
// yAcceleration          : 粒子y方向的加速度分量
// zAcceleration          : 粒子z方向的加速度分量
// scale                  : 整体缩放比例（0.0~1.0）
// scaleRange             : 缩放比例变化范围
// scaleSpeed             : 缩放比例变化速度
// spin                   : 每个粒子的旋转角度，默认为0
// spinRange              : 每个粒子的旋转角度变化范围
// color                  : 每个粒子的颜色
// redRange               : 一个粒子的颜色red 能改变的范围
// greenRange             : 一个粒子的颜色green 能改变的范围
// blueRange              : 一个粒子的颜色blue 能改变的范围
// alphaRange             : 一个粒子的颜色alpha能改变的范围
// redSpeed               : 粒子red在生命周期内的改变速度
// greenSpeed             : 粒子green在生命周期内的改变速度
// blueSpeed              : 粒子blue在生命周期内的改变速度
// alphaSpeed             : 粒子透明度在生命周期内的改变速度
// contents               : 是个CGImageRef的对象,既粒子要展现的图片
// contentsRect           : 应该画在contents里的子rectangle
// minificationFilter     : 减小自己的大小
// magnificationFilter    : 增加自己的大小
// minificationFilterBias : 减小大小的因子
// emitterCells           : 粒子发射的粒子
// style
+ (BOOL) setParticleAttributes:(NSDictionary *)dict toEmitterCell:(CAEmitterCell *)cell
{
	NSUInteger maxParticles = [[dict objectForKey:@"maxParticles"] unsignedIntegerValue];
	float angle = [[dict objectForKey:@"angle"] floatValue];
	float angleVariance = [[dict objectForKey:@"angleVariance"] floatValue];
	
	float startColorRed = [[dict objectForKey:@"startColorRed"] floatValue];
	float startColorGreen = [[dict objectForKey:@"startColorGreen"] floatValue];
	float startColorBlue = [[dict objectForKey:@"startColorBlue"] floatValue];
	float startColorAlpha = [[dict objectForKey:@"startColorAlpha"] floatValue];
	
	float startColorVarianceRed = [[dict objectForKey:@"startColorVarianceRed"] floatValue];
	float startColorVarianceGreen = [[dict objectForKey:@"startColorVarianceGreen"] floatValue];
	float startColorVarianceBlue = [[dict objectForKey:@"startColorVarianceBlue"] floatValue];
	float startColorVarianceAlpha = [[dict objectForKey:@"startColorVarianceAlpha"] floatValue];
	
	float finishColorRed = [[dict objectForKey:@"finishColorRed"] floatValue];
	float finishColorGreen = [[dict objectForKey:@"finishColorGreen"] floatValue];
	float finishColorBlue = [[dict objectForKey:@"finishColorBlue"] floatValue];
	float finishColorAlpha = [[dict objectForKey:@"finishColorAlpha"] floatValue];
	
	float startParticleSize = [[dict objectForKey:@"startParticleSize"] floatValue];
	float startParticleSizeVariance = [[dict objectForKey:@"startParticleSizeVariance"] floatValue];
	float finishParticleSize = [[dict objectForKey:@"finishParticleSize"] floatValue];
	
	float rotationStart = [[dict objectForKey:@"rotationStart"] floatValue];
	float rotationStartVariance = [[dict objectForKey:@"rotationStartVariance"] floatValue];
	float rotationEnd = [[dict objectForKey:@"rotationEnd"] floatValue];
	
	float gravityx = [[dict objectForKey:@"gravityx"] floatValue];
	float gravityy = [[dict objectForKey:@"gravityy"] floatValue];
	
	float speed = [[dict objectForKey:@"speed"] floatValue];
	float speedVariance = [[dict objectForKey:@"speedVariance"] floatValue];
	float radialAcceleration = [[dict objectForKey:@"radialAcceleration"] floatValue];
	float radialAccelVariance = [[dict objectForKey:@"radialAccelVariance"] floatValue];
	
	float particleLifespan = [[dict objectForKey:@"particleLifespan"] floatValue];
	float particleLifespanVariance = [[dict objectForKey:@"particleLifespanVariance"] floatValue];
	
	id textureFileName = [dict objectForKey:@"textureFileName"];
	
	// coordinate system transformation
	angle = -angle;
	
	rotationStart = -rotationStart;
	rotationEnd = -rotationEnd;
	
	gravityy = -gravityy;
	
	//...
	if (particleLifespan <= 0.0f) {
		particleLifespan = 1.0f;
	}
	
	float birthRate = maxParticles / particleLifespan;
	
	float emissionLongitude = DegreeToRadian(angle);
	float emissionRange = DegreeToRadian(angleVariance);
	
	float velocity = speed + radialAcceleration * particleLifespan * 0.5f;
	float velocityRange = speedVariance + radialAccelVariance * particleLifespan * 0.5f;
	
	float scale = 1.0f;
	float scaleRange = startParticleSize < 1.0f ? 0.0f : startParticleSizeVariance / startParticleSize;
	float scaleSpeed = startParticleSize < 1.0f ? 0.0f : (finishParticleSize - startParticleSize) / startParticleSize / particleLifespan;
	
	float spin = DegreeToRadian(rotationEnd - rotationStart) / particleLifespan;
	float spinRange = DegreeToRadian(rotationStartVariance);
	
	float red = startColorRed;
	float green = startColorGreen;
	float blue = startColorBlue;
	float alpha = startColorAlpha;
	
	float redRange = startColorVarianceRed;
	float greenRange = startColorVarianceGreen;
	float blueRange = startColorVarianceBlue;
	float alphaRange = startColorVarianceAlpha;
	
	float redSpeed = (finishColorRed - startColorRed) / particleLifespan;
	float greenSpeed = (finishColorGreen - startColorGreen) / particleLifespan;
	float blueSpeed = (finishColorBlue - startColorBlue) / particleLifespan;
	float alphaSpeed = (finishColorAlpha - startColorAlpha) / particleLifespan;
	
	//-------------------------------------------- emitter cell attributes begin
	
	cell.name = @"ccp";
	cell.enabled = textureFileName != nil;
	cell.birthRate = birthRate;
	cell.lifetime = particleLifespan;
	cell.lifetimeRange = particleLifespanVariance;
	// emissionLatitude       : 发射的z轴方向的角度
	cell.emissionLongitude = emissionLongitude;
	cell.emissionRange = emissionRange;
	cell.velocity = velocity;
	cell.velocityRange = velocityRange;
	cell.xAcceleration = gravityx;
	cell.yAcceleration = gravityy;
	// zAcceleration          : 粒子z方向的加速度分量
	cell.scale = scale;
	cell.scaleRange = scaleRange;
	cell.scaleSpeed = scaleSpeed;
	cell.spin = spin;
	cell.spinRange = spinRange;
	cell.color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
	cell.redRange = redRange;
	cell.greenRange = greenRange;
	cell.blueRange = blueRange;
	cell.alphaRange = alphaRange;
	cell.redSpeed = redSpeed;
	cell.greenSpeed = greenSpeed;
	cell.blueSpeed = blueSpeed;
	cell.alphaSpeed = alphaSpeed;
	
	if (textureFileName) {
		UIImage * image = [SCImage create:textureFileName autorelease:NO];
		cell.contents = (id)[image CGImage];
		[image release];
	}
	
	// contentsRect           : 应该画在contents里的子rectangle
	// minificationFilter     : 减小自己的大小
	// magnificationFilter    : 增加自己的大小
	// minificationFilterBias : 减小大小的因子
	// emitterCells           : 粒子发射的粒子
	// style
	
	//---------------------------------------------- emitter cell attributes end
	
	return YES;
}

// emitterCells
// birthRate        : 发射源的个数，默认1.0。当前每秒产生的真实粒子数 = CAEmitterLayer的birthRate * 子粒子的birthRate
// lifetime         : 粒子生命周期
// emitterPosition  : 发射位置
// emitterZPosition : 发射源的z坐标位置
// emitterSize      : 发射源的尺寸
// emitterDepth     : 决定粒子形状的深度联系
// emitterShape     : 发射源的形状
// emitterMode      : 发射模式
// renderMode       : 渲染模式
// preservesDepth   : 粒子是平展在层上
// velocity         : 粒子速度
// scale            : 粒子的缩放比例
// spin             : 自旋转速度
// seed             : 用于初始化随机数产生的种子
+ (BOOL) setParticleAttributes:(NSDictionary *)dict toEmitterLayer:(CAEmitterLayer *)layer
{
//	float duration = [[dict objectForKey:@"duration"] floatValue];
	float sourcePositionx = [[dict objectForKey:@"sourcePositionx"] floatValue];
	float sourcePositiony = [[dict objectForKey:@"sourcePositiony"] floatValue];
	float sourcePositionVariancex = [[dict objectForKey:@"sourcePositionVariancex"] floatValue];
	float sourcePositionVariancey = [[dict objectForKey:@"sourcePositionVariancey"] floatValue];
	
	// coordinate system transformation
	CGRect bounds = layer.bounds;
	
	sourcePositionx = bounds.origin.x + sourcePositionx;
	sourcePositiony = bounds.origin.y + bounds.size.height - sourcePositiony;
	
	//...
	CGPoint emitterPosition = CGPointMake(sourcePositionx, sourcePositiony);
	CGSize emitterSize = CGSizeMake(sourcePositionVariancex * 2.0f, sourcePositionVariancey * 2.0f);
	
	//------------------------------------------- emitter layer attributes begin
	
	// emitterCells
	// birthRate        : 发射源的个数，默认1.0。当前每秒产生的真实粒子数 = CAEmitterLayer的birthRate * 子粒子的birthRate
	// lifetime         : 粒子生命周期
	layer.emitterPosition = emitterPosition;
	// emitterZPosition : 发射源的z坐标位置
	layer.emitterSize = emitterSize;
	// emitterDepth     : 决定粒子形状的深度联系
	layer.emitterShape = (emitterSize.width > 1.0f) ? (emitterSize.height > 1.0f ? kCAEmitterLayerRectangle : kCAEmitterLayerLine) : (emitterSize.height > 1.0f ? kCAEmitterLayerLine : kCAEmitterLayerPoint);
	// emitterMode      : 发射模式
	layer.renderMode = kCAEmitterLayerAdditive;
	// preservesDepth   : 粒子是平展在层上
	// velocity         : 粒子速度
	// scale            : 粒子的缩放比例
	// spin             : 自旋转速度
	layer.seed = (unsigned int)time(NULL);
	
	//--------------------------------------------- emitter layer attributes end
	
	// cell attributes
	CAEmitterCell * cell = [CAEmitterCell emitterCell];
	[self setParticleAttributes:dict toEmitterCell:cell];
	layer.emitterCells = @[cell];
	
	return YES;
}

/*
 
 ---- Keys for particle system of Cocos2D ----
 
 maxParticles               : 全部粒子的总数量，也就是同时能够显示的最大粒子数量
 angle                      : 发射角度
 angleVariance              : 发射角度浮动值
 duration                   : 粒子系统的持续时间
 blendFuncSource            : 纹理混合
 blendFuncDestination
 startColorRed              : 粒子开始时颜色
 startColorGreen
 startColorBlue
 startColorAlpha
 startColorVarianceRed
 startColorVarianceGreen
 startColorVarianceBlue
 startColorVarianceAlpha
 finishColorRed             : 粒子结束时颜色
 finishColorGreen
 finishColorBlue
 finishColorAlpha
 finishColorVarianceRed
 finishColorVarianceGreen
 finishColorVarianceBlue
 finishColorVarianceAlpha
 startParticleSize          : 起始大小，使用像素作为单位，粒子最终大小需要与浮动值一同计算得出
 startParticleSizeVariance  : 起始大小浮动值
 finishParticleSize         : 结束大小，同样使用像素作为单位，粒子最终大小还需要与浮动值一同计算得出
 finishParticleSizeVariance : 结束大小浮动值
 sourcePositionx            : 发射器x坐标
 sourcePositiony            : 发射器y坐标
 sourcePositionVariancex    : 发射器x坐标浮动值
 sourcePositionVariancey    : 发射器y坐标浮动值
 rotationStart              : 起始旋转角度
 rotationStartVariance      : 起始旋转角度浮动值
 rotationEnd                : 结束旋转角度
 rotationEndVariance        : 结束旋转角度浮动值
 emitterType                : 发射器类型，包括两种发射器：重力(Gravity)和放射(又叫半径发射器Radius)
 //----------------- mode A : 重力模式
 gravityx                   : 粒子X轴加速度大小
 gravityy                   : 粒子Y轴加速度大小
 speed                      : 粒子移动的速度
 speedVariance              : 速度浮动值
 radialAcceleration         : 径向加速度，此值为正数，粒子离发射器越远速度就越快；此值为负数，粒子离发射器越远，速度就越慢
 radialAccelVariance        : 径向加速度浮动值
 tangentialAcceleration     : 切向加速度，它可以让粒子围着发射器旋转，粒子旋转离开发射器越远，速度越快。此属性值为正数，粒子逆时针旋转；此属性为负数，粒子顺时针旋转
 tangentialAccelVariance    : 切向加速度浮动值
 //----------------- mode B : 半径模式
 maxRadius                  : 最大半径，是粒子效果的节点位置和发射粒子的位置之间的距离
 maxRadiusVariance          : 最大半径浮动值
 minRadius                  : 最小半径，是粒子效果和粒子最终要到达的位置之间的距离
 rotatePerSecond            : 每秒旋转，使用此值来影响粒子移动的方向和速度
 rotatePerSecondVariance    : 每秒旋转浮动值
 //-----------------
 particleLifespan           : 粒子的生命值，此属性决定粒子会在多长时间内从生成到消失，此属性为单个粒子设置生命期
 particleLifespanVariance   : 生命值浮动值，每个粒子的具体生命时间由生命值和其浮动值一起计算，比如生命值是5秒，浮动值为1秒，则最终的生命值就是4~6秒之间的随机数值
 textureFileName            : 纹理源文件
 
 */

@end
