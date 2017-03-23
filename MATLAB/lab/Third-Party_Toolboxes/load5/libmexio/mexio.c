/*
 * $Revision: 1.1.2.3 $ $State: Exp $
 * $Date: 2005/08/05 16:34:18 $
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
#include <stdlib.h>
#include <mex.h>
#include <mexio.h>
#include <matio.h>

#define LOG_LEVEL_ERROR    1
#define LOG_LEVEL_CRITICAL 1 << 1
#define LOG_LEVEL_WARNING  1 << 2
#define LOG_LEVEL_MESSAGE  1 << 3

static void (*logfunc)(int log_level, char *message ) = NULL;


static void mex_error_func(int log_level, char *message )
{
     char *msg = NULL;

    if ( log_level & LOG_LEVEL_CRITICAL) {
        msg = strdup_printf("-C- : %s\n", message);
        mexWarnMsgTxt(msg);
    } else if ( log_level & LOG_LEVEL_ERROR ) {
        msg = strdup_printf("-E- : %s\n", message);
        mexErrMsgTxt(msg);
    } else if ( log_level & LOG_LEVEL_WARNING ) {
        msg = strdup_printf("-W- : %s\n", message);
        mexWarnMsgTxt(msg);
    } else if ( log_level & LOG_LEVEL_MESSAGE ) {
        mexPrintf("%s\n",  message);
    }

    return;
}

static void
mex_log(int loglevel, const char *format, va_list ap)
{
    char* buffer;
    buffer = strdup_vprintf(format, ap);
    mex_error_func(loglevel,buffer);
    free(buffer);

    return;
}

/** @var verbose
 *  @brief holds the verbose level set in @ref SetVerbose
 *  This variable is used to determine if information should be printed to
 *  the screen
 *  @ingroup libmexio
 */
static int verbose = 0;
/** @var silent
 *  @brief holds the silent level set in @ref SetVerbose
 *  If set, all output which is not an error is not displayed regardless
 *  of verbose level
 *  @ingroup libmexio
 */
static int silent = 0;

/** @brief Sets verbose parameters
 *
 *  Sets the verbose level and silent level.  These values are used by
 *  programs to determine what information should be printed to the screen
 *  @ingroup libmexio
 *  @param verb sets logging verbosity level
 *  @param s sets logging silent level
 */
int Mex_SetVerbose( int verb, int s )
{

    verbose = verb;
    silent  = s;
    Mat_SetVerbose(verb,s);
    return 0;
}

int Mex_LogInit( const char *mex_name )
{
    mxArray *lhs[2];

    logfunc = &mex_error_func;
    Mat_LogInitFunc(mex_name,logfunc);

    verbose = 0;
    silent  = 0;
    Mat_SetVerbose(verbose,silent);

    return 0;
}

/** @brief Log a message unless silent
 *
 * Logs the message unless the silent option is set (See @ref Mex_LogVerbose).
 * To log a message based on the verbose level, use @ref Mex_VerbMessage
 *  @ingroup libmexio
 *  @param level verbose level
 *  @param format message format
 */
int Mex_Message( const char *format, ... )
{ 
    va_list ap;

    if ( silent ) return 0;
    else if (!logfunc) return 0;
  
    va_start(ap, format );
    mex_log(LOG_LEVEL_MESSAGE, format, ap );
    va_end(ap);
    return 0;
}

/** @brief Log a message based on verbose level
 * 
 *  If @e level is less than or equal to the set verbose level, the message
 *  is printed.  If the level is higher than the set verbose level nothing
 *  is displayed.
 *  @ingroup libmexio
 *  @param level verbose level
 *  @param format message format
 */
int Mex_VerbMessage( int level, const char *format, ... )
{ 
    va_list ap;
  
    if ( silent ) return 0;
    else if (!logfunc) return 0;
    if ( level > verbose ) return 0;

    va_start(ap, format );
    mex_log( LOG_LEVEL_MESSAGE, format, ap );
    va_end(ap);
    Mex_Flush();
    return 0;
}

/** @brief Logs a Critical message and returns to the user
 *
 * Logs a Critical message and returns to the user.  If the program should
 * stop running, use @ref Mex_Error
 * @ingroup libmexio
 * @param format format string identical to printf format
 * @param ... arguments to the format string
 */
void Mex_Critical( const char *format, ... )
{
    va_list ap;

    if (!logfunc) return;
    va_start(ap, format );
    mex_log( LOG_LEVEL_CRITICAL, format, ap );
    va_end(ap);
}
/** @brief Logs a Critical message and aborts the program
 *
 * Logs an Error message and aborts
 * @ingroup libmexio
 * @param format format string identical to printf format
 * @param ... arguments to the format string
 */
void Mex_Error( const char *format, ... )
{
    va_list ap;

    if (!logfunc) return;

    va_start(ap, format );
    mex_log( LOG_LEVEL_ERROR , format, ap );
    va_end(ap);
}

/** @brief Flushes any output to the matlab terminal
 *
 * Flushes output by calling the drawnow function in Matlab.
 * @ingroup libmexio
 */
void Mex_Flush(void)
{
    mexCallMATLAB(0,NULL,0,NULL,"drawnow");
    return;
}

/** @brief Prints a warning message to stdout
 *
 * Logs a warning message then returns
 * @ingroup libmexio
 * @param format format string identical to printf format
 * @param ... arguments to the format string
 */
void Mex_Warning( const char *format, ... )
{
    va_list ap;

    if (!logfunc) return;
    va_start(ap, format );
    mex_log( LOG_LEVEL_WARNING, format, ap );
    va_end(ap);
}
