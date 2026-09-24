/*
  GEOS printer driver functions
*/

#ifndef _GPRINT_H
#define _GPRINT_H

/* Check for errors */
#if !defined(__GEOS_CBM__)
#  error This module may only be used when compiling for a GEOS-CBM target!
#endif

void InitForPrint(void);
char StartPrint(void);
void __fastcall__ PrintBuffer(char *buffer, char *scratchBuf, char color);
void __fastcall__ StopPrint(char *buffer, char *scratchBuf);
void __fastcall__ GetDimensions(char *width, char *height);
char StartASCII(void);
void __fastcall__ PrintASCII(const char *str, char *scratchBuf);
void SetNLQ(void);

#endif
