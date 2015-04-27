//
//  SCMath.h
//  SnowCat
//
//  Created by Moky on 14-4-10.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#ifndef __sc_math__
#define __sc_math__

//
//  The Four Arithmetic Operations
//
// "200 * 73 / (543 - 178) - (2 + 2) / 2 * (((4 - 1) * 2 + (3 - 1)) + 1)" => 22
double calculate(const char * str);

//
//  MOD(x, y)
//
//  3 % 10 => 3
// -3 % 10 => 7
#define circulate(index, count) (                                              \
          ((count) <= 0) ?                                                     \
          (index) :                                                            \
          ({for (; (index) < 0; (index) += (count) << 8); (index) % (count);}) \
        )                                                                      \
                                                           /* EOF 'circulate' */

#endif
