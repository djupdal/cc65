/*
** Minimal GEOS printer driver example.
**
** 2026, Asbjørn Djupdal (asbjoern@djupdal.org)
*/

#include <geos.h>
#include <geos/gprintdrv.h>

void InitForPrint (void)
{
}

char StartPrint (void)
{
    return 0;
}

void PrintBuffer (void)
{
}

void StopPrint (void)
{
}

void GetDimensions (void)
{
    r3L = 80;
    r4L = 105;
}

void PrintASCII (void)
{
}

char StartASCII (void)
{
    return 0;
}

void SetNLQ (void)
{
}
