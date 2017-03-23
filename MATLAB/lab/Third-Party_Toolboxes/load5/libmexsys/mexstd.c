/*
 * $Revision: 1.1.2.1 $ $State: Exp $
 * $Date: 2005/08/05 16:27:01 $
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif
#include <matrix.h>
#include <mex.h>
#include "mexio.h"
#include "mexstd.h"

int mexmexoptind = 0;
mxArray *mxArrayoptarg;

/*
 * The code below is modified from the University of California.  Please see
 * the copyright below.
 */
/*
 * Copyright (c) 1987, 1993, 1994, 1996
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

int	  mexopterr = 1;	/* if error message should be printed */
int	  mexoptind = 0;	/* index into parent argv vector */
int	  mexoptopt;	/* character checked for validity */
int	  optreset;	/* reset getopt */
char 	  *mexoptarg;	/* argument associated with option */

static char  mxarray_string_internal[512] = {0,};
static char *mxarray_string = &(mxarray_string_internal[0]);

int mexgetopt_internal (int, const mxArray **, const char *);

#define	BADCH	(int)'?'
#define	BADARG	(int)':'
#define	EMSG	""

char *
get_mxarray_string(array)
        const mxArray *array;
{
    int N = 0;

    if ( NULL == array ) {
        *mxarray_string = BADCH;
        return mxarray_string;
    } else if( mxCHAR_CLASS != mxGetClassID(array) ) {
        *mxarray_string = BADCH;
    } else {
        N = mxGetM(array)*mxGetN(array);
        if ( N < 512 ) {
            mxGetString(array,mxarray_string,512);
        } else {
            *mxarray_string = BADCH;
        }
    }
    return mxarray_string;
}

/*
 * getopt --
 *	Parse argc/argv argument vector.
 */
int
mexgetopt_internal(nargc, nargv, ostr)
	int nargc;
	const mxArray **nargv;
	const char *ostr;
{
	static const char *place = EMSG;	/* option letter processing */
	char *oli;				/* option letter list index */

	if (optreset || !*place) {		/* update scanning pointer */
		optreset = 0;
		if (mexoptind > nargc ) {
                    place = EMSG;
                    return (-1);
                } else { 
                    place = get_mxarray_string(nargv[mexoptind]);
                    if ( *place != '-' ) { 
			place = EMSG;
			return (-1);
                    }
		}
		if (place[1] && *++place == '-') {	/* found "--" */
			/* ++mexoptind; */
			place = EMSG;
			return (-2);
		}
	}					/* option letter okay? */
	if ((mexoptopt = (int)*place++) == (int)':' ||
	    !(oli = strchr(ostr, mexoptopt))) {
		/*
		 * if the user didn't specify '-' as an option,
		 * assume it means -1.
		 */
		if (mexoptopt == (int)'-')
			return (-1);
		if (!*place)
			++mexoptind;
		if (mexopterr && *ostr != ':')
			Mex_Critical(
			    "illegal option -- %c\n", mexoptopt);
		return (BADCH);
	}
	if (*++oli != ':') {			/* don't need argument */
		mexoptarg = NULL;
		if (!*place)
			++mexoptind;
	} else {				/* need an argument */
		if (*place)			/* no white space */
			mexoptarg = (char *)place;
		else if (nargc <= ++mexoptind) {	/* no arg */
			place = EMSG;
			if ((mexopterr) && (*ostr != ':'))
				Mex_Critical(
				    "option requires an argument -- %c\n",
				    mexoptopt);
			return (BADARG);
		} else				/* white space */
			mxArrayoptarg = nargv[mexoptind];
		place = EMSG;
		++mexoptind;
	}
	return (mexoptopt);			/* dump back option letter */
}

/*
 * getopt --
 *	Parse argc/argv argument vector.
 */
int
mexgetopt(nargc, nargv, ostr)
	int nargc;
	const mxArray **nargv;
	const char *ostr;
{
	int retval;

	if ((retval = mexgetopt_internal(nargc, nargv, ostr)) == -2) {
		retval = -1;
		++mexoptind;
	}
	return(retval);
}

/*
 * getopt_long --
 *	Parse argc/argv argument vector.
 */
int
mexgetopt_long(nargc, nargv, options, long_options, index)
     int nargc;
     const mxArray ** nargv;
     const char * options;
     const struct option * long_options;
     int * index;
{
	int retval;

        mexoptarg = NULL;
        mxArrayoptarg  = NULL;
        retval = mexgetopt_internal(nargc, nargv, options);
	if (retval == -2) {
		char *current_argv, *has_equal;
		int i, match = -1;
		size_t current_argv_len;

                current_argv = get_mxarray_string(nargv[mexoptind++]);
                current_argv += 2;
		if (*current_argv == '\0') {
			return(-1);
		}
		if ((has_equal = strchr(current_argv, '='))) {
			current_argv_len = has_equal - current_argv;
			has_equal++;
		} else
			current_argv_len = strlen(current_argv);

		for (i = 0; long_options[i].name; i++) {
			if (strncmp(current_argv, long_options[i].name, current_argv_len))
				continue;

			if (strlen(long_options[i].name) == current_argv_len) {
				match = i;
				break;
			}
			if (match == -1)
				match = i;
		}
		if (match != -1) {
			if (long_options[match].has_arg) {
				if (has_equal)
					mexoptarg = has_equal;
				else if ( mexoptind < nargc )
					mxArrayoptarg = nargv[mexoptind++];
			}
			if ((long_options[match].has_arg == 1) && (mexoptarg == NULL) && (mxArrayoptarg == NULL)) {
				/* Missing option, leading : indecates no error */
				if ((mexopterr) && (*options != ':'))
					Mex_Critical(
				      "option requires an argument -- %s\n",
				      current_argv);
				return (BADARG);
			}
		} else { /* No matching argument */
			if ((mexopterr) && (*options != ':'))
				Mex_Critical(
				    "illegal option -- %s\n", current_argv);
			return (BADCH);
		}
		if (long_options[match].flag) {
			*long_options[match].flag = long_options[match].val;
			retval = 0;
		} else
			retval = long_options[match].val;
		if (index)
			*index = match;
	}
	return(retval);
}
