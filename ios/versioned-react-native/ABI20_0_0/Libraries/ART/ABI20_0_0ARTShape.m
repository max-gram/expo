/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ABI20_0_0ARTShape.h"

@implementation ABI20_0_0ARTShape

- (void)setD:(CGPathRef)d
{
  if (d == _d) {
    return;
  }
  [self invalidate];
  CGPathRelease(_d);
  _d = CGPathRetain(d);
}

- (void)dealloc
{
  CGPathRelease(_d);
}

- (void)renderLayerTo:(CGContextRef)context
{
  if ((!self.fill && !self.stroke) || !self.d) {
    return;
  }

  CGPathDrawingMode mode = kCGPathStroke;
  if (self.fill) {
    if ([self.fill applyFillColor:context]) {
      mode = kCGPathFill;
    } else {
      CGContextSaveGState(context);
      CGContextAddPath(context, self.d);
      CGContextClip(context);
      [self.fill paint:context];
      CGContextRestoreGState(context);
      if (!self.stroke) {
        return;
      }
    }
  }
  if (self.stroke) {
    CGContextSetStrokeColorWithColor(context, self.stroke);
    CGContextSetLineWidth(context, self.strokeWidth);
    CGContextSetLineCap(context, self.strokeCap);
    CGContextSetLineJoin(context, self.strokeJoin);
    ABI20_0_0ARTCGFloatArray dash = self.strokeDash;
    if (dash.count) {
      CGContextSetLineDash(context, 0, dash.array, dash.count);
    }
    if (mode == kCGPathFill) {
      mode = kCGPathFillStroke;
    }
  }

  CGContextAddPath(context, self.d);
  CGContextDrawPath(context, mode);
}

@end
