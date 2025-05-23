/* Copyright (c) 2019  SiFive Inc. All rights reserved.

   This copyrighted material is made available to anyone wishing to use,
   modify, copy, or redistribute it subject to the terms and conditions
   of the FreeBSD License.   This program is distributed in the hope that
   it will be useful, but WITHOUT ANY WARRANTY expressed or implied,
   including the implied warranties of MERCHANTABILITY or FITNESS FOR
   A PARTICULAR PURPOSE.  A copy of this license is available at
   http://www.opensource.org/licenses.
*/

#if defined(PREFER_SIZE_OVER_SPEED) || defined(__OPTIMIZE_SIZE__)
.text
.global memmove
.type	memmove, @function
memmove:
  beqz a2, .Ldone		/* in case there are 0 bytes to be copied, return immediately */

  mv a4, a0			/* copy the destination address over to a4, since memmove should return that address in a0 at the end */
  li a3, 1
  bgtu  a1, a0, .Lcopy		/* in case of source address > destination address, copy from start to end of the specified memory area */

  li a3, -1			/* otherwhise, start copying from the end of the specified memory area in order to prevent data loss in case of overlapping memory areas.*/
  add   a4, a4, a2		/* add the number of bytes to be copied to both addresses. this gives us the address one byte past the end of the memory area we want to copy, */
  add   a1, a1, a2		/* therefore we need to subtract 1 from both addresses in the next step before starting the copying process. */

.Lincrement:
  add   a4, a4, a3 		/* in case of source address < destination address, increment both addresses by -1 before copying any data to obtain the correct start addresses */
  add   a1, a1, a3
.Lcopy:
  lbu a5, 0(a1)
  addi   a2, a2, -1		/* copy bytes as long as a2 (= the number of bytes to be copied) > 0. the increment is done here to relax the RAW dependency between load and store */
  sb a5, 0(a4)
  bnez a2, .Lincrement

.Ldone:
  ret

  .size	memmove, .-memmove
#endif
