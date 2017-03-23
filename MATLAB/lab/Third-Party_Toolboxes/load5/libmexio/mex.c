/*
 * $Revision: 1.1.2.2 $ $State: Exp $
 * $Date: 2005/08/05 16:45:32 $
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
#include <mex.h>
#include <matrix.h>
#include <mexio.h>
#include <matio.h>

mxClassID mat_t_to_mxclass(int data_type)
{
    switch (data_type) {
        case MAT_T_DOUBLE:
            return mxDOUBLE_CLASS;
        case MAT_T_SINGLE:
            return mxSINGLE_CLASS;
        case MAT_T_INT32:
            return mxINT32_CLASS;
        case MAT_T_UINT32:
            return mxUINT32_CLASS;
        case MAT_T_INT16:
            return mxINT16_CLASS;
        case MAT_T_UINT16:
            return mxUINT16_CLASS;
        case MAT_T_INT8:
            return mxINT8_CLASS;
        case MAT_T_UINT8:
            return mxUINT8_CLASS;
        default:
            return mxUNKNOWN_CLASS;
    }
}

int isNumeric(int class_type)
{
    int is;
    switch(class_type) {
        case mxDOUBLE_CLASS:
        case mxSINGLE_CLASS:
        case mxINT32_CLASS:
        case mxUINT32_CLASS:
        case mxINT16_CLASS:
        case mxUINT16_CLASS:
        case mxINT8_CLASS:
        case mxUINT8_CLASS:
            is = 1;
            break;
        default:
            is = 0;
    }
    return is;
}

static int isSparse(int class_type)
{
    if ( class_type == mxSPARSE_CLASS )
        return 1;
    else
        return 0;
}

mxArray *
CreateArray(int rank,int *dims,int class_type,int isComplex,void *data)
{
    mxArray *array = NULL;
    mxComplexity mxcomplexity;
    int empty_dims[16] = {0,};

    if ( isComplex )
        mxcomplexity = mxCOMPLEX;
    else
        mxcomplexity = mxREAL;

    if ( isNumeric(class_type) ) {
        array = mxCreateNumericArray(rank,empty_dims,class_type,mxcomplexity);
        if ( array == NULL ) {
            Mex_Critical("Error creating numeric array");
        } else if ( 0 != mxSetDimensions(array,dims,rank) ) {
            Mex_Critical("Error setting array dimensions");
            mxDestroyArray(array);
            array = NULL;
        } else {
            mxSetData(array,data);
        }
#if 0
    else if ( isSparse(class_type) ) {
        sparse_t *sparse = data;

        array = mxCreateSparse(2,empty_dims,0,mxcomplexity);
        if ( array == NULL ) {
        } else if ( 0 != mxSetDimensions(array,dims,rank) ) {
        }
#endif
    }
    return array;
}

int get_vector_size(const mxArray *array)
{
    int M, N;
    M = mxGetM(array);
    N = mxGetN(array);
    if ( N < 1 || M < 1 )
        return 0;
    else if ( N == 1 )
        return M;
    else
        return N;
}

/* @brief Converts a matvar_t structure to an mxArray
 *
 * Converts the matvar_t structure to an mxArray structure.
 * @ingroup libmexio
 * @param matvar Pointer to the matvar_t structure
 * @returns
 */
mxArray *
MatVarToMxArray( matvar_t *matvar)
{
    mxArray *array = NULL;
    mxComplexity complexity = mxREAL;
    
    if ( matvar == NULL )
        return NULL;

    switch ( matvar->class_type ) {
        case mxDOUBLE_CLASS:
        case mxSINGLE_CLASS:
        case mxINT32_CLASS:
        case mxUINT32_CLASS:
        case mxINT16_CLASS:
        case mxUINT16_CLASS:
        case mxINT8_CLASS:
        case mxUINT8_CLASS:
            if ( matvar->isComplex )
                complexity = mxCOMPLEX;

            array = mxCreateNumericArray(matvar->rank,matvar->dims,
                      matvar->class_type,complexity);
            if ( !array ) {
                Mex_Critical("Failed creating array for %s", matvar->name);
                break;
            }
            if ( matvar->nbytes == 0 )
                break;
            else if ( matvar->data == NULL )
                break;
            if ( matvar->isComplex ) {
                int nbytes = matvar->nbytes/2;
                memcpy(mxGetData(array),matvar->data,nbytes);
                memcpy(mxGetImagData(array),(mat_uint8_t *)matvar->data+nbytes,
                       nbytes);
            } else {
                memcpy(mxGetData(array),matvar->data,matvar->nbytes);
            }
            break;
        case mxCHAR_CLASS:
        {
            mxChar *mxcharptr;
            int i; 

            array = mxCreateCharArray(matvar->rank,matvar->dims);
            if ( !array ) {
                Mex_Critical("Error creating the character array %s",
                    matvar->name);
                break;
            }
            if ( matvar->nbytes == 0 )
                break;
            else if ( matvar->data == NULL )
                break;
            mxcharptr = mxGetChars(array);
            for ( i = 0; i < matvar->nbytes; i++ )
                 mxcharptr[i] = (mat_uint16_t)(*((char *)matvar->data+i));
            break;
        }
        case mxSTRUCT_CLASS:
        {
            matvar_t **fields = (matvar_t **)matvar->data;
            int nfields = 0, i, fieldnum, nmemb = 1, memb_idx;
            char **fieldnames;
            mxArray *arrayfield;

            for ( i = 0; i < matvar->rank; i++ )
                nmemb *= matvar->dims[i];

            if ( matvar->nbytes == 0 )
                break;
            nfields = matvar->nbytes / (nmemb*matvar->data_size);
            fieldnames = malloc(nfields*sizeof(char *));
            if ( fieldnames == NULL )
                break;
            for ( i = 0; i < nfields; i++ )
                fieldnames[i] = strdup(fields[i]->name);

            array = mxCreateStructArray(matvar->rank,matvar->dims,nfields,
                      (const char **)fieldnames);
            free(fieldnames);
            if ( !array ) {
                Mex_Critical("Error creating the strucutre %s",matvar->name);
                break;
            }
            if ( matvar->data == NULL )
                break;
            for ( memb_idx = 0; memb_idx < nmemb; memb_idx++ ) {
                for ( i = 0; i < nfields; i++ ) {
                    arrayfield = MatVarToMxArray(*fields);
                    if ( (arrayfield == NULL) && ((*fields)->rank != 0)) {
                        /*
                         * MatVarToMxArray returned NULL and *fields is not an
                         * empty array.
                         */
                        Mex_Critical("Error making struct field %s at index %d",
                            (*fields)->name,memb_idx);
                        fields++;
                        continue;
                    }
                    fieldnum = mxGetFieldNumber(array,(*fields)->name);
                    if ( fieldnum != -1 )
                        mxSetFieldByNumber(array,memb_idx,fieldnum,arrayfield);
                    fields++;
                }
            }

            break;
        }
        case mxCELL_CLASS:
        {
            matvar_t **cells = (matvar_t **)matvar->data;
            int ncells = 0, i;
            mxArray *arraycell;

            ncells = matvar->nbytes / matvar->data_size;

            array = mxCreateCellArray(matvar->rank,matvar->dims);
            if ( !array ) {
                Mex_Critical("Error creating the cell %s",matvar->name);
                break;
            }
            if ( matvar->nbytes == 0 )
                break;
            else if ( matvar->data == NULL )
                break;
            for ( i = 0; i < ncells; i++ ) {
                arraycell = MatVarToMxArray(cells[i]);
                if ( !arraycell ) {
                    Mex_Critical("Error retrieving cell field %s", cells[i]->name);
                    continue;
                }
                mxSetCell(array,i,arraycell);
            }

            break;
        }
        case mxFUNCTION_CLASS:
        {
            matvar_t **functions = (matvar_t **)matvar->data;
            matvar_t  *function_handle,*field;
            int nfunctions = 0, i, err;
            mxArray *func;
            const char *fields[3] = {"function","type","file"};

            nfunctions = matvar->nbytes / matvar->data_size;

            if ( matvar->nbytes == 0 )
                break;
            else if ( matvar->data == NULL )
                break;
            if ( nfunctions == 1 ) {
                function_handle = Mat_VarGetStructField(*functions,
                    "function_handle",BY_NAME,0);
                if ( function_handle != NULL ) {
                    field = Mat_VarGetStructField(function_handle,
                        "function",BY_NAME,0);
                    func = MatVarToMxArray(field);
                }
                mexCallMATLAB(1,&array,1,&func,"str2func");
            } else {
                mxArray *cell;
                cell = mxCreateCellArray(matvar->rank,matvar->dims);
                if ( !cell ) {
                    Mex_Critical("Error creating function_handle %s",
                        matvar->name);
                    break;
                }
                for ( i = 0; i < nfunctions; i++ ) {
                    function_handle = Mat_VarGetStructField(functions[i],
                        "function_handle",BY_NAME,0);
                    if ( function_handle != NULL ) {
                        field = Mat_VarGetStructField(function_handle,
                            "function",BY_NAME,0);
                        func = MatVarToMxArray(field);
                        mxSetCell(cell,i,func);
                    }
                }
                mexCallMATLAB(1,&array,1,&cell,"str2func");
            }
            break;
        }
        case mxSPARSE_CLASS:
        {
            sparse_t *sparse;

            if ( matvar->isComplex )
                complexity = mxCOMPLEX;

            if ( matvar->nbytes == 0 )
                break;
            else if ( matvar->data == NULL )
                break;
            sparse = matvar->data;
            array = mxCreateSparse(matvar->dims[0],matvar->dims[1],
                        sparse->nzmax,complexity);
            if ( array == NULL ) {
                Mex_Critical("Error creating sparse matrix %s",matvar->name);
            } else {
                if ( sparse->ndata != sparse->nzmax )
                    Mex_Critical("Number of data elements is not equal to nzmax");
                else if (sparse->nir != sparse->nzmax)
                    Mex_Critical("Number of Ir elements is not equal to nzmax");
                else {
                    memcpy(mxGetIr(array),sparse->ir,sparse->nzmax*sizeof(int));
                    memcpy(mxGetData(array),sparse->data,
                           sparse->nzmax*sizeof(double));
                }
                if ( sparse->njc != (matvar->dims[1]+1) )
                    Mex_Critical("Number of Jc elements is not equal to "
                                   "number of columns + 1");
                else
                    memcpy(mxGetJc(array),sparse->jc,sparse->njc*sizeof(int));
            }
            break;
        }
    }
    return array;
}
