/*
 * $Revision: 1.1 $ $State: Exp $
 * $Date: 2005/06/24 13:45:32 $
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
#include <string.h>
#include <mex.h>

void *
__wrap_strdup(char *s)
{
    char *s2 = NULL;
    int n;

    if ( !s )    return NULL;
    n = strlen(s);
    s2 = mxCalloc(1,n+1);
    memcpy(s2,s,n);
    return s2;
}
