/*
  GEOS printer driver authoring functions
*/

#ifndef _GPRINTDRV_H
#define _GPRINTDRV_H

/* Check for errors */
#if !defined(__GEOS_CBM__)
#  error This module may only be used when compiling for a GEOS-CBM target!
#endif

/* Perform printer dependent initialization. */
void InitForPrint(void);

/* Set up to receive graphics data. Return 0 on success, or a Kernal
** I/O error code (see the "InitForIO" family in geos/gsys.h).
*/
char StartPrint(void);

/* Print one line */
void PrintBuffer(void);

/* Flush the print buffer and form feed */
void StopPrint(void);

/* Set r3L/r4L to the dimensions, in cards, of the printable area:
** width (number of calls to PrintBuffer needed per row) in r3L, height
** (number of rows per page) in r4L.
*/
void GetDimensions(void);

/* Print the null terminated ASCII string */
void PrintASCII(void);

/* Set up to receive ASCII data. Return 0 on success, or a Kernal I/O
** error code.
*/
char StartASCII(void);

/* Send whatever initialization string the printer needs for near letter quality
** mode.
*/
void SetNLQ(void);

#endif
