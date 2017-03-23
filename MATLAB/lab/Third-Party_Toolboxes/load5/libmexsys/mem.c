/*
 * $Revision: 1.1.2.1 $ $State: Exp $
 * $Date: 2005/08/05 16:24:32 $
 */
/*
 * Copyright (C) 2005   Christopher C. Hulbert
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
#include <mex.h>

static int ncalloc = 0;
static int nmalloc = 0;
static int nfree = 0;
static int persistent = 1;

void SetPersistent(int p)
{
    persistent = p;
}

void *
__wrap_malloc(size_t size)
{
    void *ptr = NULL;
    nmalloc++;
    ptr = mxMalloc(size);
    if ( ptr != NULL && persistent )
        mexMakeMemoryPersistent(ptr);
    return ptr;
}

void *
__wrap_calloc(size_t nmemb, size_t size)
{
    void *ptr = NULL;
    ncalloc++;
    ptr = mxCalloc(nmemb,size);
    if ( ptr != NULL )
        mexMakeMemoryPersistent(ptr);
    return ptr;
}

void *
__wrap_realloc(void *ptr, size_t size)
{
    void *ptr2 = NULL;
    nmalloc++;
    ptr2 = mxRealloc(ptr,size);
    if ( ptr2 != NULL )
        mexMakeMemoryPersistent(ptr2);
    return ptr;
}

void
__wrap_free(void *ptr)
{
    nfree++;
    mxFree(ptr);
    ptr = NULL;
    return;
}

void __wrap_assert(int expression)
{
    return mxAssert(expression,NULL);
}

void *
__wrap_zcalloc(void *opaque, unsigned nmemb, unsigned size)
{
    ncalloc++;
    return mxCalloc(nmemb,size);
}

void
__wrap_zcfree(void *opaque, void *ptr)
{
    nfree++;
    return mxFree(ptr);
}

void
MexMemProfile( int *m, int *c, int *f )
{
    *m = nmalloc;
    *c = ncalloc;
    *f = nfree;
    return;
}

void
MexMemReset( )
{
    nmalloc = 0;
    ncalloc = 0;
    nfree = 0;
    return;
}
