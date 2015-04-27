//
//  SCAffineTransform.h
//  SnowCat
//
//  Created by Moky on 14-7-9.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

CA_EXTERN CATransform3D CATransform3DMakePerspective(CGPoint center, CGFloat disZ);
CA_EXTERN CATransform3D CATransform3DPerspect(const CATransform3D t, CGPoint center, CGFloat disZ);

/*
CG_INLINE void SCAffineTransformSetTransform3D(CATransform3D * t, const CGAffineTransform m) {
	t->m11 = m.a; t->m12 = m.b;
	t->m21 = m.c; t->m22 = m.d;
	t->m41 = m.tx; t->m42 = m.ty;
}

#pragma mark - get value

// get scaleX
CG_INLINE CGFloat SCScaleXFromTransform3D(const CATransform3D t) {
	CGAffineTransform m = CATransform3DGetAffineTransform(t);
	return sqrtf(m.a * m.a + m.b * m.b);
}

// get scaleY
CG_INLINE CGFloat SCScaleYFromTransform3D(const CATransform3D t) {
	CGAffineTransform m = CATransform3DGetAffineTransform(t);
	return sqrtf(m.c * m.c + m.d * m.d);
}

// get scale
CG_INLINE CGFloat SCScaleFromTransform3D(const CATransform3D t) {
//	CGFloat scaleX = SCScaleXFromTransform3D(t);
//	CGFloat scaleY = SCScaleYFromTransform3D(t);
//	return (fabsf(scaleX - scaleY) <= 0.0001) ? scaleY : 1;
	return SCScaleXFromTransform3D(t);
}

// get skewX in radians
CG_INLINE CGFloat SCSkewXFromTransform3D(const CATransform3D t) {
	CGAffineTransform m = CATransform3DGetAffineTransform(t);
	return atan2f(-m.c, m.d);
}

// get skewY in radians
CG_INLINE CGFloat SCSkewYFromTransform3D(const CATransform3D t) {
	CGAffineTransform m = CATransform3DGetAffineTransform(t);
	return atan2f(m.b, m.a);
}

// get rotation in radians
CG_INLINE CGFloat SCRotationFromTransform3D(const CATransform3D t) {
	CGFloat skewX = SCSkewXFromTransform3D(t);
	CGFloat skewY = SCSkewYFromTransform3D(t);
	return (fabsf(skewX - skewY) <= 0.0001) ? skewY : 0;
}

#pragma mark - set value

// set scaleX
CG_INLINE void SCTransform3DScaleX(CATransform3D * t, CGFloat scaleX) {
	CGFloat oldValue = SCScaleXFromTransform3D(*t);
	if (oldValue) { // avoid devision by zero
		CGFloat ratio = scaleX / oldValue;
		t->m11 *= ratio; // m.a
		t->m12 *= ratio; // m.b
	} else {
		CGFloat skewY = SCSkewYFromTransform3D(*t);
		t->m11 = cosf(skewY) * scaleX; // m.a
		t->m12 = sinf(skewY) * scaleX; // m.b
	}
}

// set scaleY
CG_INLINE void SCTransform3DScaleY(CATransform3D * t, CGFloat scaleY) {
	CGFloat oldValue = SCScaleYFromTransform3D(*t);
	if (oldValue) { // avoid devision by zero
		CGFloat ratio = scaleY / oldValue;
		t->m21 *= ratio; // m.c
		t->m22 *= ratio; // m.d
	} else {
		CGFloat skewX = SCSkewXFromTransform3D(*t);
		t->m21 = -sinf(skewX) * scaleY; // m.c
		t->m22 =  cosf(skewX) * scaleY; // m.d
	}
}

// set scale
CG_INLINE void SCTransform3DScale(CATransform3D * t, CGFloat scale) {
	SCTransform3DScaleX(t, scale);
	SCTransform3DScaleY(t, scale);
}

// set skewX in radians
CG_INLINE void SCTransform3DSkewX(CATransform3D * t, CGFloat skewX) {
	CGFloat scaleY = SCScaleYFromTransform3D(*t);
	t->m21 = -sinf(skewX) * scaleY; // m.c
	t->m22 =  cosf(skewX) * scaleY; // m.d
}

// set skewY in radians
CG_INLINE void SCTransform3DSkewY(CATransform3D * t, CGFloat skewY) {
	CGFloat scaleX = SCScaleXFromTransform3D(*t);
	t->m11 = cosf(skewY) * scaleX; // m.a
	t->m12 = sinf(skewY) * scaleX; // m.b
}

// set rotation in radians
CG_INLINE void SCTransform3DRotate(CATransform3D * t, CGFloat rotation) {
	SCTransform3DSkewX(t, rotation);
	SCTransform3DSkewY(t, rotation);
}
*/
