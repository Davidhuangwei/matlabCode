/*
 * $Revision: 1.1.2.1 $ $State: Exp $
 * $Date: 2005/08/05 16:35:43 $
 */
#ifndef MEXIO_H
#define MEXIO_H

#include <mex.h>
#include <matrix.h>
#include <matio.h>

#ifdef __cplusplus
#   define EXTERN extern "C"
#else
#   define EXTERN extern
#endif

/** @defgroup libmexio MEX function I/O library */

/*  mexio.c  */
EXTERN int  Mex_SetVerbose( int verb, int s );
EXTERN void Mex_Critical( const char *format, ... );
EXTERN void Mex_Error( const char *format, ... );
EXTERN int  Mex_LogInit ( const char *mex_name );
EXTERN int  Mex_Message( const char *format, ... );
EXTERN int  Mex_VerbMessage( int level, const char *format, ... );
EXTERN void Mex_Warning( const char *format, ... );
EXTERN void Mex_Flush( void );

/* mex.c */
EXTERN mxClassID scats_t_to_mxclass(int data_type);
EXTERN mxArray  *MatVarToMxArray( matvar_t *matvar);
EXTERN int       isNumeric(int class_type);
EXTERN int get_vector_size(const mxArray *array);

#endif
