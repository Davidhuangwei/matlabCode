/** @file load5.c
 * @brief Loads a Matlab MAT level 5 file
 *
 * Loads in a Matlab MAT level 5 file
 * @synopsis
 *    load5 [OPTIONS] MAT_FILE [VAR1 VAR2 ...]
 * @options
 * @opt --prefix    prepends PREFIX to variables loaded from MAT file",
 *                  except variable names explicitly set using '=' @endopt
 * @opt --suffix    appends SUFFIX to variables loaded from MAT file",
 *                  except variable names explicitly set using '=' @endopt
 * @opt --help      Print help string and exit @endopt
 * @opt --version   Print version number and exit @endopt
 *
 * @examples
 * @code
 *    >> load5 --prefix pre_ --suffix _suf dem dLat dLon TerrainHeight=th
 *    >> whos
 *      Name               Size                   Bytes  Class
 * 
 *      pre_dLat_suf       1x1                        8  double array
 *      pre_dLon_suf       1x1                        8  double array
 *      th              1440x1441               2075040  uint8 array
 *
 *    Grand total is 2075042 elements using 2075056 bytes
 *
 *    >>"
 * @endcode
 *
 * @code
 *    >> load5('--prefix','pre_','--suffix','_suf','dem.mat');
 *    >> whos
 *      Name                            Size                   Bytes  Class
 *
 *      pre_SouthmostLatitude_suf       1x1                        8  double array
 *      pre_TerrainHeight_suf        1440x1441               2075040  uint8 array
 *      pre_WestmostLongitude_suf       1x1                        8  double array
 *      pre_dLat_suf                    1x1                        8  double array
 *      pre_dLon_suf                    1x1                        8  double array
 *
 *    Grand total is 2075044 elements using 2075072 bytes",
 *
 *    >>
 * @endcode
 *
 * @code
 *    >> load5 test.mat
 *    >>
 * @endcode
 */
/*
 * $Revision: 1.1.2.2 $ $State: Exp $
 * $Date: 2005/08/05 16:38:31 $
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
#include <string.h>
#include <math.h>
#include <matrix.h>
#include <mex.h>
#include <mexstd.h>
#include <mexio.h>
#include <matio.h>

#ifdef WINNT
#define PATHSEP '\\'
#else
#define PATHSEP '/'
#endif

static char *prefix = NULL;
static char *suffix = NULL;
int nmalloc,ncalloc,nfree;
int list,recursive;

extern int      mexoptind;
extern char    *mexoptarg;
extern mxArray *mxArrayoptarg;

static char *helpstr[] = {
    "",
    "Usage: load5([OPTIONS],filename,var1,var2,...)",
    "       load5 [OPTIONS] filename var1 var2 ...",
    "       load5 [OPTIONS] filename var1as=var1 var2as=var2",
    "",
    "  DESCRIPTION",
    "    Loads a Matlab MAT version 5 compatible file",
    "",
    "    Loading structure fields:",
    "      Individual fields of a structure may be loaded using the '.'",
    "      separator such as: structure.substruct.field.",
    "",
    "    Loading cells of a cell array:",
    "      Cells of a cell array can be selected using {}. For example, to",
    "      load every other cell of cell array x, use x{1:2:end}. Another",
    "      example would be to load the first 5 cells in each dimension by ",
    "      using x{1:5,1:5,1:5}",
    "",
    "    Partial I/O",
    "      Partial I/O can be used by using ().  The same type of selections",
    "      as used in Cell Arrays are supproted here, so to load every other",
    "      element of a dataset, use x(1:2:end,1:2:end). To load the first row",
    "      of a data set x in the structure s, you would use s.x(1,1:end).",
    "",
    "    Notes about selections:",
    "      At this time, use of only the : to denote all is not supported;",
    "      instead use 1:end.  Also, Partial I/O only works on numeric",
    "      non-sparse types and must be the last in the expression.",
    "",
    "  OPTIONS",
    "     -h",
    "    --help          - This output",
    "     -l",
    "    --list          - List the contents of the file, but do not load",
    "     -p",
    "    --prefix PREFIX - prepends PREFIX to variables loaded from MAT file",
    "                      except variable names explicitly set using '='",
    "     -r",
    "    --recursive     - Used with --list, recurses through structures to",
    "                      list fields of structures as well as the structure",
    "                      itself",
    "     -s",
    "    --suffix SUFFIX - appends SUFFIX to variables loaded from MAT file",
    "                      except variable names explicitly set using '='",
    "     -v",
    "    --version       - version information",
    "",
    "  INPUT:",
    "    filename - MAT filename",
    "  OPTIONAL INPUT:",
    "    var1     - Name of variable to load",
    "    :",
    "    var#     - Name of variable to load",
    "",
    NULL
};

static struct option long_options[] =
{
    {"help",   no_argument,       NULL, 'h'},
    {"list",   no_argument,       NULL, 'l'},
    {"prefix", required_argument, NULL, 'p'},
    {"recursive", no_argument,    NULL, 'r'},
    {"suffix", required_argument, NULL, 's'},
    {"version", no_argument,      NULL, 'v'},
    {0, 0, 0, 0}
};

static const char *class_type_desc[16] = {"Empty Matlab Array","cell array",
       "struct array","object","char array","sparse array","double array",
       "single array", "int8 array", "uint8 array","int16 array",
       "uint16 array","int32 array","uint32 array",
       "Matlab Array","Compressed Data"};

static void help( )
{
    int i;
    for (i = 0; helpstr[i] != NULL; i++)
        mexPrintf("%s\n",helpstr[i]);
}

static void usage( )
{
    int i;
    for (i = 0; helpstr[i] != NULL; i++)
        mexPrintf("%s\n",helpstr[i]);
    mexErrMsgTxt("");
}

static char *
get_next_token(char *str)
{
    char *tok, *tokens = "(){}.";
    char *next_tok;

    next_tok = str;
    while (*tokens != '\0') {
        tok   = strchr(str,*tokens);
        if ( tok != NULL ) {
            if ( next_tok == str )
                next_tok = tok;
            else if (tok < next_tok)
                next_tok = tok;
        }
        tokens++;
    }
    return next_tok;
}

static void
print_matvar_info(matvar_t *matvar, const char *parent)
{
    char *name;
    char dims[64] = {0}, dim[16] = {0};
    int  nmemb = 1, j;
    size_t bytes;

    if ( (matvar->rank == 0) || (matvar->dims == NULL) ) {
        mat_snprintf(dims,64,"0x0");
    } else {
        mat_snprintf(dims,64,"%d",matvar->dims[0]);
        for (j = 1; j < matvar->rank; j++ ) {
            mat_snprintf(dim,16,"x%d",matvar->dims[j]);
            strncat(dims,dim,64);
            nmemb *= matvar->dims[j];
        }
    }
    if ( parent != NULL )
        name = strdup_printf("%s.%s",parent,matvar->name);
    else
        name = strdup_printf("%s",matvar->name);

    bytes = Mat_VarGetSize(matvar);
    Mex_Message("%-32s %-15s %-8u %-20s",name,dims,bytes,
                class_type_desc[matvar->class_type]);
    if ( recursive && matvar->class_type == mxSTRUCT_CLASS ) {
        int nfields;
        matvar_t **fields;

        nfields = matvar->nbytes / (nmemb*matvar->data_size);
        fields  = matvar->data;
        for ( j = 0; j < nfields; j++ )
            print_matvar_info(fields[j],name);
    }
    return;
}

static int
slab_get_rank(char *open,char *close)
{
    int rank = 0;
    char *ptr = open+1;
    rank = 1;
    while ( ptr != close ) {
        if ( *ptr++ == ',' )
            rank++;
    }
    return rank;
}

static void
slab_get_select(char *open, char *close, int rank, int *start, int *stride, int *edge)
{
    char *ptr, *valptr;
    int nvals, dim, i;

    ptr = open;
    valptr = open+1;
    dim = 0;
    nvals = 0;
    do {
        ptr++;
        if ( *ptr == ',' ) {
            if (nvals == 2) {
                *ptr = '\0';
                 if ( !strcmp(valptr,"end") ) {
                     edge[dim] = -1;
                 } else {
                     i = atoi(valptr);
                     edge[dim] = i;
                 }
            } else if ( nvals == 1 ) {
                *ptr = '\0';
                 if ( !strcmp(valptr,"end") ) {
                     edge[dim] = -1;
                 } else {
                     i = atoi(valptr);
                     edge[dim] = i;
                 }
            } else if ( nvals == 0 ) {
                *ptr = '\0';
                 if ( !strcmp(valptr,"end") ) {
                     start[dim] = -1;
                     edge[dim]  = -1;
                 } else {
                     i = atoi(valptr);
                     start[dim] = i-1;
                     edge[dim]  = i;
                 }
            }
            dim++;
            valptr = ptr+1;
            nvals = 0;
        } else if ( *ptr == ':' ) {
            *ptr = '\0';
            if ( !strcmp(valptr,"end") ) {
                if ( nvals == 0 )
                    start[dim] = -1;
                else if ( nvals == 1 )
                    edge[dim] = -1;
                else if ( nvals == 2 )
                    edge[dim] = -1;
                else
                    Mex_Critical("Too many inputs to dim %d",dim+1);
            } else {
                i = atoi(valptr);
                if ( nvals == 0 )
                    start[dim] = i-1;
                else if ( nvals == 1 )
                    stride[dim] = i;
                else if ( nvals == 1 )
                    edge[dim] = i;
                else if ( nvals == 2 )
                    edge[dim] = i;
                else
                    Mex_Critical("Too many inputs to dim %d",dim+1);
            }
            nvals++;
            valptr = ptr+1;
        } else if ( *ptr == ')' || *ptr == '}' ) {
            *ptr = '\0';
            if ( !strcmp(valptr,"end") ) {
                if ( nvals == 0 ) {
                    start[dim] = -1;
                    edge[dim]  = -1;
                } else if ( nvals == 1 )
                    edge[dim] = -1;
                else if ( nvals == 2 )
                    edge[dim] = -1;
                else
                    Mex_Critical("Too many inputs to dim %d",dim+1);
            } else {
                i = atoi(valptr);
                if ( nvals == 0 ) {
                    start[dim] = i-1;
                    edge[dim]  = i;
                } else if ( nvals == 1 )
                    edge[dim] = i;
                else if ( nvals == 2 )
                    edge[dim] = i;
                else
                    Mex_Critical("Too many inputs to dim %d",dim+1);
            }
            nvals++;
            valptr = ptr+1;
        }
    } while ( ptr != close );
}

static int
slab_select_valid(int rank,int *start,int *stride,int *edge,matvar_t *matvar)
{
    int valid = 1, i, nmemb = 1;

    if ( (matvar->rank != rank) && (rank != 1) ) {
        valid = 0;
    } else if ( rank == 1 ) {
        for ( i = 0; i < matvar->rank; i++ )
            nmemb *= matvar->dims[i];
        if ( *stride < 1 ) {
            /* Check stride is at least 1 */
            Mex_Critical("stride must be positive");
            valid = 0;
        } else if ( *edge > nmemb ) {
            /* edge can't be bigger than the size of the dimension */
            Mex_Critical("edge out of bound");
            valid = 0;
        } else if ( *start >= nmemb || (*start > *edge && *edge > 0) ) {
            /* Start can't be bigger than the size of the dimension and
             * can't be greater than the edge unless edge == -1 => end
             */
            Mex_Critical("start out of bound");
            valid = 0;
        } else if ( *edge == -1 && *start == -1 ) {
            /* If edge == start == -1, then a single end was used */
            *edge = 1;
            *start = nmemb-1;
        } else if ( *edge == -1 && *stride == 1 ) {
            *edge = nmemb;
        } else if ( *edge == -1 ) {
            /* index of the form 1:stride:end */
            *edge = nmemb;
            *edge = floor((double)(*edge-*start-1) / (double)*stride)+1;
        } else if ( *edge > 0 ) {
            *edge = floor((double)(*edge-*start-1) / (double)*stride)+1;
        }
        nmemb = *edge;
    } else {
        for ( i = 0; i < rank && valid; i++ ) {
            if ( stride[i] < 1 ) {
                /* Check stride is at least 1 */
                Mex_Critical("stride must be positive");
                valid = 0;
                break;
            } else if ( edge[i] > matvar->dims[i] ) {
                /* edge can't be bigger than the size of the dimension */
                Mex_Critical("edge out of bound on dimension %d",i+1);
                valid = 0;
                break;
            } else if ( start[i] >= matvar->dims[i] || 
                        (start[i] > edge[i] && edge[i] > 0) ) {
                /* Start can't be bigger than the size of the dimension and
                 * can't be greater than the edge unless edge == -1 => end
                 */
                Mex_Critical("start out of bound on dimension %d",i+1);
                valid = 0;
                break;
            } else if ( edge[i] == -1 && start[i] == -1 ) {
                /* If edge == start == -1, then a single end was used */
                edge[i] = 1;
                start[i] = matvar->dims[i]-1;
            } else if ( edge[i] < 1 && stride[i] == 1) {
                /* index of the form 1:end or 1:1:end */
                edge[i] = matvar->dims[i];
            } else if ( edge[i] < 1 ) {
                /* index of the form 1:stride:end */
                edge[i] = floor((double)(matvar->dims[i]-start[i]-1) / (double)stride[i])+1;
            } else if ( edge[i] == (start[i]+1) ) {
                /* index of the form 3:3 */
                edge[i] = 1;
            } else if ( edge[i] > 0 ) {
                edge[i] = floor((double)(edge[i]-start[i]-1) / (double)stride[i])+1;
            }
            nmemb *= edge[i];
        }
    }
    if ( !valid )
        nmemb = 0;
    return nmemb;
}

static mat_t *
get_mat_file(char *matfile)
{
    mat_t *mat = NULL;
    mxArray *which[1], *args[1];
    int nlhs = 1, nrhs = 1,N;

    if ( !matfile ) return NULL;

    mat = NULL;
    if ( (mat = Mat_Open(matfile,MAT_ACC_RDONLY)) != NULL )
        return mat;

    args[0] = mxCreateString(matfile);

    nlhs = 1;
    nrhs = 1;
    mexCallMATLAB(nlhs,which,nrhs,args,"which");

    N = mxGetM(which[0])*mxGetN(which[0]);

    if ( N ) {
        char *name;
        name = (char *)malloc(N+1);
        mxGetString(which[0],name,N+1);
        mat = Mat_Open(name,MAT_ACC_RDONLY);
        free(name);
    }

    mxDestroyArray(which[0]);
    mxDestroyArray(args[0]);
        
    return mat;
}

static int
set_global(char *name)
{
    int err;
    char cmd[256];

    mat_snprintf(cmd,256,"global %s",name);
    err = mexEvalString(cmd);
    return err;
}

/* load_vars - Loads the specified variables from the mat file
 * mat  - MAT file
 * vars - NULL terminated array of variable names
 * RETURNS
 * The number of variables loaded
 */
static int
load_vars(mat_t *mat, char **vars)
{
    char *as = NULL, *temp = NULL, *open = NULL, *close = NULL, *field = NULL;
    char *next_tok_pos, next_tok, *varname;
    int err, nvars = 0, i = 0, j, done = 0;
    mxArray *array = NULL;
    matvar_t *matvar = NULL;
 
    while ( vars[i] != NULL ) {
        /* Check if user is renaming the variable */
        if ( (as = strchr(vars[i],'=')) ) {
            *as = '\0';
             as++;
        }
        varname = vars[i];
        next_tok_pos = get_next_token(varname);
        next_tok = *next_tok_pos;
        if ( next_tok_pos != varname )
            *next_tok_pos = '\0';
        else
            done = 1;
        matvar = Mat_VarReadInfo(mat,varname);
        if ( matvar == NULL ) {
            Mex_Critical("Couldn't find variable %s", varname);
            i++;
            continue;
        }
        while ( !done ) {
            /* Check If the user is selecting a subset of the dataset */
            if ( next_tok == '(' ) {
                int rank, *start, *stride, *edge,nmemb;

                if ( !isNumeric(matvar->class_type) ) {
                    Mex_Critical("Only numeric data can use partial I/O");
                    Mat_VarFree(matvar);
                    matvar = NULL;
                    i++;
                    break;
                }
                open    = next_tok_pos;
                close   = strchr(open+1,')');

                /* Get the next token after this selection */
                next_tok_pos = get_next_token(close+1);
                if ( next_tok_pos != (close+1) ) {
                    *next_tok_pos = '\0';
                    next_tok = *next_tok_pos;
                } else {
                    done = 1;
                }
                /* Make sure that the partial I/O is the last token */
                if ( !done ) {
                    Mex_Critical("Partial I/O must be the last operation in "
                                 "the expression");
                    Mat_VarFree(matvar);
                    matvar = NULL;
                    i++;
                    break;
                }
                /* Get the rank of the dataset */
                rank   = slab_get_rank(open,close);
                start  = malloc(rank*sizeof(int));
                stride = malloc(rank*sizeof(int));
                edge   = malloc(rank*sizeof(int));
                for ( j = 0; j < rank; j++ ) {
                    start[j]  = 0;
                    stride[j] = 1;
                    edge[j]   = 1;
                }
                /* Get the start,stride,edge using matlab syntax */
                slab_get_select(open,close,rank,start,stride,edge);
                /* Check if the users selection is valid and if so read the data */
                if ((nmemb = slab_select_valid(rank,start,stride,edge,matvar))) {
                    matvar->nbytes = nmemb*Mat_SizeOfClass(matvar->class_type);
                    matvar->data = malloc(matvar->nbytes);
                    if ( matvar->data == NULL ) {
                        Mex_Critical("Couldn't allocate memory for the data");
                        err = 1;
                    } else if ( rank == 1 ) {
                        Mat_VarReadDataLinear(mat,matvar,matvar->data,*start,
                                             *stride,*edge);
                        if (matvar->rank == 2 && matvar->dims[0] == 1) {
                           matvar->dims[1] = *edge;
                        } else if (matvar->rank == 2 && matvar->dims[1] == 1) {
                           matvar->dims[0] = *edge;
                        } else {
                           matvar->rank = 1;
                           matvar->dims[0] = *edge;
                        }
                    } else {
                        Mat_VarReadData(mat,matvar,matvar->data,start,
                                             stride,edge);
                        memcpy(matvar->dims,edge,rank*sizeof(int));
                    }
                }
                free(start);
                free(stride);
                free(edge);
            } else if ( next_tok == '.' ) {
                matvar_t *field;
    
                if ( matvar->class_type == MAT_C_STRUCT ) {
                    varname = next_tok_pos+1;
                    next_tok_pos = get_next_token(next_tok_pos+1);
                    if ( next_tok_pos != varname ) {
                        next_tok = *next_tok_pos;
                        *next_tok_pos = '\0';
                    } else {
                        done = 1;
                    }
                    /* FIXME: Handle structures > 1x1 */
                    field = Mat_VarGetStructField(matvar,varname,BY_NAME,0);
                    if ( field == NULL ) {
                        Mex_Critical("field %s was not found in structure %s",
                            varname,matvar->name);
                        Mat_VarFree(matvar);
                        matvar = NULL;
                        i++;
                        break;
                    }
                    field = Mat_VarDuplicate(field,1);
                    Mat_VarFree(matvar);
                    matvar = field;
                } else if ( matvar->class_type == MAT_C_CELL ) {
                    int ncells;
                    matvar_t *cell, **cells;

                    ncells = matvar->nbytes / matvar->data_size;
                    cells = matvar->data;
                    varname = next_tok_pos+1;
                    next_tok_pos = get_next_token(next_tok_pos+1);
                    if ( next_tok_pos != varname ) {
                        next_tok = *next_tok_pos;
                        *next_tok_pos = '\0';
                    } else {
                        done = 1;
                    }
                    for ( j = 0 ; j < ncells; j++ ) {
                        cell = Mat_VarGetCell(matvar,j);
                        if ( cell == NULL || cell->class_type != MAT_C_STRUCT ) {
                            Mex_Message("cell index %d is not a structure",j);
                            Mat_VarFree(matvar);
                            matvar = NULL;
                            i++;
                            break;
                        } else {
                            /* FIXME: Handle structures > 1x1 */
                            field = Mat_VarGetStructField(cell,varname,BY_NAME,0);
                            if ( field == NULL ) {
                                Mex_Critical("field %s was not found in "
                                    "structure %s",varname,matvar->name);
                                Mat_VarFree(matvar);
                                matvar = NULL;
                                i++;
                                break;
                            }
                            field = Mat_VarDuplicate(field,1);
                            Mat_VarFree(cell);
                            cells[j] = field;
                        }
                    }
                    if ( j != ncells )
                        break;
                } else {
                    Mex_Message("%s is not a structure", varname);
                    Mat_VarFree(matvar);
                    matvar = NULL;
                    i++;
                    break;
                }
            } else if ( next_tok == '{' ) {
                int rank, *start, *stride, *edge,nmemb;

                if ( matvar->class_type != MAT_C_CELL ) {
                    Mex_Critical("Only Cell Arrays can index with {}");
                    Mat_VarFree(matvar);
                    matvar = NULL;
                    i++;
                    break;
                }
                open    = next_tok_pos;
                close   = strchr(open+1,'}');

                /* Get the next token after this selection */
                next_tok_pos = get_next_token(close+1);
                if ( *next_tok_pos != '\0' ) {
                    next_tok = *next_tok_pos;
                    *next_tok_pos = '\0';
                } else {
                    done = 1;
                }
                /* Get the rank of the dataset */
                rank   = slab_get_rank(open,close);
                start  = malloc(rank*sizeof(int));
                stride = malloc(rank*sizeof(int));
                edge   = malloc(rank*sizeof(int));
                for ( j = 0; j < rank; j++ ) {
                    start[j]  = 0;
                    stride[j] = 1;
                    edge[j]   = 1;
                }
                /* Get the start,stride,edge using matlab syntax */
                slab_get_select(open,close,rank,start,stride,edge);
                /* Check if the users selection is valid and if so read the data */
                if ((nmemb = slab_select_valid(rank,start,stride,edge,matvar))) {
                    matvar_t **cells, *tmp;
                    if ( rank == 1 ) {
                        cells = Mat_VarGetCellsLinear(matvar,*start,
                                      *stride,*edge);
                        if (matvar->rank == 2 && matvar->dims[0] == 1) {
                           matvar->dims[1] = *edge;
                        } else if (matvar->rank == 2 && matvar->dims[1] == 1) {
                           matvar->dims[0] = *edge;
                        } else {
                           matvar->rank = 1;
                           matvar->dims[0] = *edge;
                        }
                    } else {
                        cells = Mat_VarGetCells(matvar,start,stride,edge);
                        memcpy(matvar->dims,edge,matvar->rank*sizeof(int));
                    }
                    if ( cells == NULL ) {
                        Mex_Critical("Error getting the indexed cells");
                        Mat_VarFree(matvar);
                        matvar = NULL;
                        i++;
                        break;
                    } else {
                        for ( j = 0; j < nmemb; j++ )
                            cells[j] = Mat_VarDuplicate(cells[j],1);
                        tmp = Mat_VarCreate(matvar->name,MAT_C_CELL,
                            MAT_T_CELL,matvar->rank,matvar->dims,cells,
                            MEM_CONSERVE);
                        Mat_VarFree(matvar);
                        matvar = tmp;
                    }
                } else {
                    Mex_Critical("Cell selection not valid");
                    Mat_VarFree(matvar);
                    matvar = NULL;
                    i++;
                    break;
                }
                free(start);
                free(stride);
                free(edge);
            }
        }
        if ( matvar == NULL )
            continue;
        /* If the user is renaming it, set a prefix, or a suffix apply it */
        if ( as ) {
            free(matvar->name);
            matvar->name = strdup_printf("%s",as);
        } else if ( prefix && suffix ) {
            temp = strdup_printf("%s%s%s",prefix,matvar->name,suffix);
            free(matvar->name);
            matvar->name = temp;
        } else if ( prefix ) {
            temp = strdup_printf("%s%s",prefix,matvar->name);
            free(matvar->name);
            matvar->name = temp;
        } else if ( suffix ) {
            temp = strdup_printf("%s%s",matvar->name,suffix);
            free(matvar->name);
            matvar->name = temp;
        }
        if ( list ) {
            Mex_Message("%-32s %-15s %-8s %-20s","Name","Size","Bytes","Class");
            print_matvar_info(matvar,NULL);
        } else {
            if ( next_tok != '(' )
                Mat_VarReadDataAll(mat,matvar);
            array = MatVarToMxArray(matvar);
            if ( (array != NULL) && !matvar->isGlobal ) {
                err = mexPutVariable("caller",matvar->name,array);
                mxDestroyArray(array);
                nvars++;
            } else if ( (array != NULL) && matvar->isGlobal ) {
                err = mexPutVariable("global",matvar->name,array);
                err = set_global(matvar->name);
                mxDestroyArray(array);
                nvars++;
            }
        }
        Mat_VarFree(matvar);
        matvar = NULL;
        i++;
    }
    return nvars;
}

/* load_all_mat - Loads all the variables from the mat file
 * mat  - MAT file
 * RETURNS
 * The number of variables loaded
 */
static int
load_all_mat(mat_t *mat)
{
    char *temp;
    int err, nvars = 0;
    mxArray *array = NULL;
    matvar_t *matvar = NULL;

    if ( list ) {
        Mex_Message("%-32s %-15s %-8s %-20s","Name","Size","Bytes","Class");
        while ( (matvar = Mat_VarReadNextInfo(mat)) != NULL ) {
            print_matvar_info(matvar,NULL);
            Mat_VarFree(matvar);
            matvar = NULL;
        }
    } else {
        while ( (matvar = Mat_VarReadNext(mat)) != NULL ) {
            if ( prefix != NULL && suffix != NULL ) {
                temp = strdup_printf("%s%s%s",prefix,matvar->name,suffix);
                free(matvar->name);
                matvar->name = temp;
            } else if ( prefix ) {
                temp = strdup_printf("%s%s",prefix,matvar->name);
                free(matvar->name);
                matvar->name = temp;
            } else if ( suffix ) {
                temp = strdup_printf("%s%s",matvar->name,suffix);
                free(matvar->name);
                matvar->name = temp;
            }
            array = MatVarToMxArray(matvar);
            if ( (array != NULL) && !matvar->isGlobal ) {
                err = mexPutVariable("caller",matvar->name,array);
                mxDestroyArray(array);
                nvars++;
            } else if ( (array != NULL) && matvar->isGlobal ) {
                err = mexPutVariable("global",matvar->name,array);
                err = set_global(matvar->name);
                mxDestroyArray(array);
                nvars++;
            }
            Mat_VarFree(matvar);
            matvar = NULL;
        }
    }

    return nvars;
}

void mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    const char *mex_name = "load5", *opts = "hlp:rs:v";
    char *matfname = NULL, *ext;
    int N, err, nvars;
    mat_t *mat = NULL;
    int c, option_index, format;

    prefix = NULL;
    suffix = NULL;
    mexoptind = 0;

    if ( nrhs < 1 )
        usage();
    if ( nlhs > 0 )
        usage();

    Mex_LogInit(mex_name);

    mexoptind = 0;
    list = 0;
    recursive = 0;
    while (-1!=(c=mexgetopt_long(nrhs,prhs,opts,long_options,&option_index))) {
        switch(c) {
            case 'h':
                help();
                return;
            case 'l':
                list = 1;
                break;
            case 'p':                  /*   Prefix  */
                if ( mexoptarg != NULL ) {
                    prefix = strdup(mexoptarg);
                } else if ( mxArrayoptarg != NULL ) {
                    N = mxGetM(mxArrayoptarg)*mxGetN(mxArrayoptarg);
                    prefix = malloc(N+1);
                    if ( prefix != NULL )
                        mxGetString(mxArrayoptarg,prefix,N+1);
                    else
                        Mex_Error("Couldn't allocate memory for --prefix argument");
                }
                break;
            case 'r':
                recursive = 1;
                break;
            case 's':                  /*   Suffix  */
                if ( mexoptarg != NULL ) {
                    suffix = strdup(mexoptarg);
                } else if ( mxArrayoptarg != NULL ) {
                    N = mxGetM(mxArrayoptarg)*mxGetN(mxArrayoptarg);
                    suffix = malloc(N+1);
                    if ( suffix != NULL )
                        mxGetString(mxArrayoptarg,suffix,N+1);
                    else
                        Mex_Error("Couldn't allocate memory for --suffix argument");
                }
                break;
            case 'v':
                mexPrintf("load5 v%d.%d.%d (compiled %s, %s for %s)\n",
                          LOAD5_MAJOR_VERSION,LOAD5_MINOR_VERSION,
                          LOAD5_RELEASE_LEVEL,__DATE__, __TIME__,
                          LOAD5_PLATFORM );
                return;
            case ':':                  /*   BADARG   */
            default:
                Mex_Error("Aborting from argument errors");
        }
    }

    if ( recursive && !list )
        Mex_Error("recursive must be used with the list option");

    if ( mexoptind >= nrhs )
        Mex_Error("No files found");

    N = get_vector_size(prhs[mexoptind])+1;
    matfname = (char *)malloc(N+1);
    if ( matfname == NULL )
        Mex_Error("Couldn't get mat filename");
    err = mxGetString(prhs[mexoptind++],matfname,N);

    if ( matfname == '\0' )
        Mex_Error("'' is not a valid filename");

    if ( NULL == (ext = strrchr(matfname,'.')) ) {
        char *temp;
        temp = strdup_printf("%s.mat",matfname);
        free(matfname);
        matfname = temp;
        mat = get_mat_file(matfname);
        format = SCATS_FT_MAT5;
    } else if ( !strcmp(ext,".mat") ) {
        mat = get_mat_file(matfname);
        format = SCATS_FT_MAT5;
    } else {
        Mex_Error("Format doesn't appear to be a mat file");
    }

    if ( mat == NULL )
        Mex_Error("Couldn't open mat file %s",matfname);

    free(matfname);

    if ( nrhs-mexoptind < 1 ) {
        if ( format == SCATS_FT_MAT5 )
            nvars = load_all_mat(mat);
    } else {
        char **varnames;
        int nvars, i;

        nvars = nrhs-mexoptind;
        varnames = (char **)malloc((nvars+1)*sizeof(char *));
        if ( !varnames ) {
            Mex_Critical("Couldn't get list of the variable names");
            Mat_Close(mat);
            return;
        }
        for ( i = 0; i < nvars; i++ ) {
            N = get_vector_size(prhs[mexoptind])+1;
            varnames[i] = (char *)malloc(N+1);
            if ( !varnames[i] ) {
                Mex_Critical("Couldn't get variable name for index %d",i);
                mexoptind++;
                nvars--;
                i--;
                continue;
            }
            err = mxGetString(prhs[mexoptind++],varnames[i],N);
        }
        varnames[nvars] = NULL;
        err = load_vars(mat,varnames);
        for ( i = 0; i < nvars; i++ )
            if ( varnames[i] )
                free(varnames[i]);
        free(varnames);
    }

    if ( format == SCATS_FT_MAT5 )
        Mat_Close(mat);

    if ( prefix != NULL ) {
        free(prefix);
        prefix = NULL;
    }
    if ( suffix != NULL ) {
        free(suffix);
        suffix = NULL;
    }

    return;
}
