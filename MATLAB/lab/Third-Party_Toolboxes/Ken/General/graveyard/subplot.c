/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:21 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "subplot.h"

/*
 * The function "Msubplot" is the implementation version of the "subplot"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/subplot.m"
 * (lines 1-232). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function theAxis = subplot(nrows, ncols, thisPlot)
 */
static mxArray * Msubplot(int nargout_,
                          mxArray * nrows,
                          mxArray * ncols,
                          mxArray * thisPlot) {
    mxArray * theAxis = mclGetUninitializedArray();
    mxArray * PERC_OFFSET_B = mclGetUninitializedArray();
    mxArray * PERC_OFFSET_L = mclGetUninitializedArray();
    mxArray * PERC_OFFSET_R = mclGetUninitializedArray();
    mxArray * PERC_OFFSET_T = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * ax = mclGetUninitializedArray();
    mxArray * code = mclGetUninitializedArray();
    mxArray * col = mclGetUninitializedArray();
    mxArray * col_offset = mclGetUninitializedArray();
    mxArray * create_axis = mclGetUninitializedArray();
    mxArray * def_pos = mclGetUninitializedArray();
    mxArray * delay_destroy = mclGetUninitializedArray();
    mxArray * got_one = mclGetUninitializedArray();
    mxArray * handle = mclGetUninitializedArray();
    mxArray * height = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mxArray * intersect = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mxArray * kill_siblings = mclGetUninitializedArray();
    mxArray * narg = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nargout = mclInitialize(mlfScalar(nargout_));
    mxArray * nextstate = mclGetUninitializedArray();
    mxArray * pos_size = mclGetUninitializedArray();
    mxArray * position = mclGetUninitializedArray();
    mxArray * row = mclGetUninitializedArray();
    mxArray * row_offset = mclGetUninitializedArray();
    mxArray * sibpos = mclGetUninitializedArray();
    mxArray * sibs = mclGetUninitializedArray();
    mxArray * tmp = mclGetUninitializedArray();
    mxArray * tol = mclGetUninitializedArray();
    mxArray * totalheight = mclGetUninitializedArray();
    mxArray * totalwidth = mclGetUninitializedArray();
    mxArray * units = mclGetUninitializedArray();
    mxArray * width = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, nrows, ncols, thisPlot, NULL));
    mclValidateInputs("subplot", 3, &nrows, &ncols, &thisPlot);
    mclCopyArray(&nrows);
    mclCopyArray(&ncols);
    mclCopyArray(&thisPlot);
    /*
     * %SUBPLOT Create axes in tiled positions.
     * %   H = SUBPLOT(m,n,p), or SUBPLOT(mnp), breaks the Figure window
     * %   into an m-by-n matrix of small axes, selects the p-th axes for 
     * %   for the current plot, and returns the axis handle.  The axes 
     * %   are counted along the top row of the Figure window, then the
     * %   second row, etc.  For example,
     * % 
     * %       SUBPLOT(2,1,1), PLOT(income)
     * %       SUBPLOT(2,1,2), PLOT(outgo)
     * % 
     * %   plots income on the top half of the window and outgo on the
     * %   bottom half.
     * % 
     * %   SUBPLOT(m,n,p), if the axis already exists, makes it current.
     * %   SUBPLOT(H), where H is an axis handle, is another way of making
     * %   an axis current for subsequent plotting commands.
     * %
     * %   SUBPLOT('position',[left bottom width height]) creates an
     * %   axis at the specified position in normalized coordinates (in 
     * %   in the range from 0.0 to 1.0).
     * %
     * %   If a SUBPLOT specification causes a new axis to overlap an
     * %   existing axis, the existing axis is deleted.  For example,
     * %   the statement SUBPLOT(1,2,1) deletes all existing axes overlapping
     * %   the left side of the Figure window and creates a new axis on that
     * %   side.
     * %
     * %   SUBPLOT(111) is an exception to the rules above, and is not
     * %   identical in behavior to SUBPLOT(1,1,1).  For reasons of backwards
     * %   compatibility, it is a special case of subplot which does not
     * %   immediately create an axes, but instead sets up the figure so that
     * %   the next graphics command executes CLF RESET in the figure
     * %   (deleting all children of the figure), and creates a new axes in
     * %   the default position.  This syntax does not return a handle, so it
     * %   is an error to specify a return argument.  The delayed CLF RESET
     * %   is accomplished by setting the figure's NextPlot to 'replace'.
     * 
     * %   Copyright (c) 1984-98 by The MathWorks, Inc.
     * %   $Revision: 5.14 $  $Date: 1998/10/20 19:26:58 $
     * 
     * % we will kill all overlapping axes siblings if we encounter the mnp
     * % or m,n,p specifier (excluding '111').
     * % But if we get the 'position' or H specifier, we won't check for and
     * % delete overlapping siblings:
     * narg = nargin;
     */
    mlfAssign(&narg, nargin_);
    /*
     * kill_siblings = 0;
     */
    mlfAssign(&kill_siblings, mlfScalar(0.0));
    /*
     * create_axis = 1;
     */
    mlfAssign(&create_axis, mlfScalar(1.0));
    /*
     * delay_destroy = 0;
     */
    mlfAssign(&delay_destroy, mlfScalar(0.0));
    /*
     * tol = sqrt(eps);
     */
    mlfAssign(&tol, mlfSqrt(mlfEps()));
    /*
     * if narg == 0 % make compatible with 3.5, i.e. subplot == subplot(111)
     */
    if (mlfTobool(mlfEq(narg, mlfScalar(0.0)))) {
        /*
         * nrows = 111;
         */
        mlfAssign(&nrows, mlfScalar(111.0));
        /*
         * narg = 1;
         */
        mlfAssign(&narg, mlfScalar(1.0));
    /*
     * end
     */
    }
    /*
     * 
     * %check for encoded format
     * handle = '';
     */
    mlfAssign(&handle, mxCreateString(""));
    /*
     * position = '';
     */
    mlfAssign(&position, mxCreateString(""));
    /*
     * if narg == 1
     */
    if (mlfTobool(mlfEq(narg, mlfScalar(1.0)))) {
        /*
         * % The argument could be one of 3 things:
         * % 1) a 3-digit number 100 < num < 1000, of the format mnp
         * % 2) a 3-character string containing a number as above
         * % 3) an axis handle
         * code = nrows;
         */
        mlfAssign(&code, nrows);
        /*
         * 
         * % turn string into a number:
         * if(isstr(code)) code = str2double(code); end
         */
        if (mlfTobool(mlfIsstr(code))) {
            mlfAssign(&code, mlfStr2double(code));
        }
        /*
         * 
         * % number with a fractional part can only be an identifier:
         * if(rem(code,1) > 0)
         */
        if (mlfTobool(mlfGt(mlfRem(code, mlfScalar(1.0)), mlfScalar(0.0)))) {
            /*
             * handle = code;
             */
            mlfAssign(&handle, code);
            /*
             * if ~strcmp(get(handle,'type'),'axes')
             */
            if (mlfTobool(
                  mlfNot(
                    mlfStrcmp(
                      mlfGet(handle, mxCreateString("type"), NULL),
                      mxCreateString("axes"))))) {
                /*
                 * error('Requires valid axes handle for input.')
                 */
                mlfError(
                  mxCreateString("Requires valid axes handle for input."));
            /*
             * end
             */
            }
            /*
             * create_axis = 0;
             */
            mlfAssign(&create_axis, mlfScalar(0.0));
        /*
         * % all other numbers will be converted to mnp format:
         * else
         */
        } else {
            /*
             * thisPlot = rem(code, 10);
             */
            mlfAssign(&thisPlot, mlfRem(code, mlfScalar(10.0)));
            /*
             * ncols = rem( fix(code-thisPlot)/10,10);
             */
            mlfAssign(
              &ncols,
              mlfRem(
                mlfMrdivide(mlfFix(mlfMinus(code, thisPlot)), mlfScalar(10.0)),
                mlfScalar(10.0)));
            /*
             * nrows = fix(code/100);
             */
            mlfAssign(&nrows, mlfFix(mlfMrdivide(code, mlfScalar(100.0))));
            /*
             * if nrows*ncols < thisPlot
             */
            if (mlfTobool(mlfLt(mlfMtimes(nrows, ncols), thisPlot))) {
                /*
                 * error('Index exceeds number of subplots.');
                 */
                mlfError(mxCreateString("Index exceeds number of subplots."));
            /*
             * end
             */
            }
            /*
             * kill_siblings = 1;
             */
            mlfAssign(&kill_siblings, mlfScalar(1.0));
            /*
             * if(code == 111)
             */
            if (mlfTobool(mlfEq(code, mlfScalar(111.0)))) {
                /*
                 * create_axis   = 0;
                 */
                mlfAssign(&create_axis, mlfScalar(0.0));
                /*
                 * delay_destroy = 1;
                 */
                mlfAssign(&delay_destroy, mlfScalar(1.0));
            /*
             * else
             */
            } else {
                /*
                 * create_axis   = 1;
                 */
                mlfAssign(&create_axis, mlfScalar(1.0));
                /*
                 * delay_destroy = 0;
                 */
                mlfAssign(&delay_destroy, mlfScalar(0.0));
            /*
             * end
             */
            }
        /*
         * end
         */
        }
    /*
     * elseif narg == 2
     */
    } else if (mlfTobool(mlfEq(narg, mlfScalar(2.0)))) {
        /*
         * % The arguments MUST be the string 'position' and a 4-element vector:
         * if(strcmp(lower(nrows), 'position'))
         */
        if (mlfTobool(mlfStrcmp(mlfLower(nrows), mxCreateString("position")))) {
            /*
             * pos_size = size(ncols);
             */
            mlfAssign(&pos_size, mlfSize(mclValueVarargout(), ncols, NULL));
            /*
             * if(pos_size(1) * pos_size(2) == 4)
             */
            if (mlfTobool(
                  mlfEq(
                    mlfMtimes(
                      mlfIndexRef(pos_size, "(?)", mlfScalar(1.0)),
                      mlfIndexRef(pos_size, "(?)", mlfScalar(2.0))),
                    mlfScalar(4.0)))) {
                /*
                 * position = ncols;
                 */
                mlfAssign(&position, ncols);
            /*
             * else
             */
            } else {
                /*
                 * error(['subplot(''position'',',...
                 */
                mlfError(
                  mlfHorzcat(
                    mxCreateString("subplot('position',"),
                    mxCreateString(
                      " [left bottom width height]) is what works"),
                    NULL));
            /*
             * ' [left bottom width height]) is what works'])
             * end
             */
            }
        /*
         * else
         */
        } else {
            /*
             * error('Unknown command option')
             */
            mlfError(mxCreateString("Unknown command option"));
        /*
         * end
         */
        }
        /*
         * kill_siblings = 1; % Kill overlaps here also.
         */
        mlfAssign(&kill_siblings, mlfScalar(1.0));
    /*
     * elseif narg == 3
     */
    } else if (mlfTobool(mlfEq(narg, mlfScalar(3.0)))) {
        /*
         * % passed in subplot(m,n,p) -- we should kill overlaps
         * % here too:
         * kill_siblings = 1;
         */
        mlfAssign(&kill_siblings, mlfScalar(1.0));
    /*
     * end
     */
    }
    /*
     * 
     * % if we recovered an identifier earlier, use it:
     * if(~isempty(handle))
     */
    if (mlfTobool(mlfNot(mlfIsempty(handle)))) {
        /*
         * set(get(0,'CurrentFigure'),'CurrentAxes',handle);
         */
        mclAssignAns(
          &ans,
          mlfNSet(
            0,
            mlfGet(mlfScalar(0.0), mxCreateString("CurrentFigure"), NULL),
            mxCreateString("CurrentAxes"),
            handle,
            NULL));
    /*
     * % if we haven't recovered position yet, generate it from mnp info:
     * elseif(isempty(position))
     */
    } else if (mlfTobool(mlfIsempty(position))) {
        /*
         * if (min(thisPlot) < 1)
         */
        if (mlfTobool(
              mlfLt(mlfMin(NULL, thisPlot, NULL, NULL), mlfScalar(1.0)))) {
            /*
             * error('Illegal plot number.')
             */
            mlfError(mxCreateString("Illegal plot number."));
        /*
         * elseif (max(thisPlot) > ncols*nrows)
         */
        } else if (mlfTobool(
                     mlfGt(
                       mlfMax(NULL, thisPlot, NULL, NULL),
                       mlfMtimes(ncols, nrows)))) {
            /*
             * error('Index exceeds number of subplots.')
             */
            mlfError(mxCreateString("Index exceeds number of subplots."));
        /*
         * else
         */
        } else {
            /*
             * % This is the percent offset from the subplot grid of the plotbox.
             * PERC_OFFSET_L = 2*0.09;
             */
            mlfAssign(
              &PERC_OFFSET_L, mlfMtimes(mlfScalar(2.0), mlfScalar(0.09)));
            /*
             * PERC_OFFSET_R = 2*0.045;
             */
            mlfAssign(
              &PERC_OFFSET_R, mlfMtimes(mlfScalar(2.0), mlfScalar(0.045)));
            /*
             * PERC_OFFSET_B = PERC_OFFSET_L;
             */
            mlfAssign(&PERC_OFFSET_B, PERC_OFFSET_L);
            /*
             * PERC_OFFSET_T = PERC_OFFSET_R;
             */
            mlfAssign(&PERC_OFFSET_T, PERC_OFFSET_R);
            /*
             * if nrows > 2
             */
            if (mlfTobool(mlfGt(nrows, mlfScalar(2.0)))) {
                /*
                 * PERC_OFFSET_T = 0.9*PERC_OFFSET_T;
                 */
                mlfAssign(
                  &PERC_OFFSET_T, mlfMtimes(mlfScalar(0.9), PERC_OFFSET_T));
                /*
                 * PERC_OFFSET_B = 0.9*PERC_OFFSET_B;
                 */
                mlfAssign(
                  &PERC_OFFSET_B, mlfMtimes(mlfScalar(0.9), PERC_OFFSET_B));
            /*
             * end
             */
            }
            /*
             * if ncols > 2
             */
            if (mlfTobool(mlfGt(ncols, mlfScalar(2.0)))) {
                /*
                 * PERC_OFFSET_L = 0.9*PERC_OFFSET_L;
                 */
                mlfAssign(
                  &PERC_OFFSET_L, mlfMtimes(mlfScalar(0.9), PERC_OFFSET_L));
                /*
                 * PERC_OFFSET_R = 0.9*PERC_OFFSET_R;
                 */
                mlfAssign(
                  &PERC_OFFSET_R, mlfMtimes(mlfScalar(0.9), PERC_OFFSET_R));
            /*
             * end
             */
            }
            /*
             * 
             * row = (nrows-1) -fix((thisPlot-1)/ncols);
             */
            mlfAssign(
              &row,
              mlfMinus(
                mlfMinus(nrows, mlfScalar(1.0)),
                mlfFix(
                  mlfMrdivide(mlfMinus(thisPlot, mlfScalar(1.0)), ncols))));
            /*
             * col = rem (thisPlot-1, ncols);
             */
            mlfAssign(&col, mlfRem(mlfMinus(thisPlot, mlfScalar(1.0)), ncols));
            /*
             * 
             * % For this to work the default axes position must be in normalized coordinates
             * if ~strcmp(get(gcf,'defaultaxesunits'),'normalized')
             */
            if (mlfTobool(
                  mlfNot(
                    mlfStrcmp(
                      mlfGet(
                        mlfGcf(), mxCreateString("defaultaxesunits"), NULL),
                      mxCreateString("normalized"))))) {
                /*
                 * warning('DefaultAxesUnits not normalized.')
                 */
                mclPrintAns(
                  &ans,
                  mlfWarning(
                    NULL, mxCreateString("DefaultAxesUnits not normalized.")));
                /*
                 * tmp = axes;
                 */
                mlfAssign(&tmp, mlfNAxes(1, NULL));
                /*
                 * set(axes,'units','normalized')
                 */
                mclPrintAns(
                  &ans,
                  mlfNSet(
                    0,
                    mlfNAxes(1, NULL),
                    mxCreateString("units"),
                    mxCreateString("normalized"),
                    NULL));
                /*
                 * def_pos = get(tmp,'position');
                 */
                mlfAssign(
                  &def_pos, mlfGet(tmp, mxCreateString("position"), NULL));
                /*
                 * delete(tmp)
                 */
                mlfDelete(tmp, NULL);
            /*
             * else
             */
            } else {
                /*
                 * def_pos = get(gcf,'DefaultAxesPosition');
                 */
                mlfAssign(
                  &def_pos,
                  mlfGet(
                    mlfGcf(), mxCreateString("DefaultAxesPosition"), NULL));
            /*
             * end
             */
            }
            /*
             * col_offset = def_pos(3)*(PERC_OFFSET_L+PERC_OFFSET_R)/ ...
             */
            mlfAssign(
              &col_offset,
              mlfMrdivide(
                mlfMtimes(
                  mlfIndexRef(def_pos, "(?)", mlfScalar(3.0)),
                  mlfPlus(PERC_OFFSET_L, PERC_OFFSET_R)),
                mlfMinus(mlfMinus(ncols, PERC_OFFSET_L), PERC_OFFSET_R)));
            /*
             * (ncols-PERC_OFFSET_L-PERC_OFFSET_R);
             * row_offset = def_pos(4)*(PERC_OFFSET_B+PERC_OFFSET_T)/ ...
             */
            mlfAssign(
              &row_offset,
              mlfMrdivide(
                mlfMtimes(
                  mlfIndexRef(def_pos, "(?)", mlfScalar(4.0)),
                  mlfPlus(PERC_OFFSET_B, PERC_OFFSET_T)),
                mlfMinus(mlfMinus(nrows, PERC_OFFSET_B), PERC_OFFSET_T)));
            /*
             * (nrows-PERC_OFFSET_B-PERC_OFFSET_T);
             * totalwidth = def_pos(3) + col_offset;
             */
            mlfAssign(
              &totalwidth,
              mlfPlus(mlfIndexRef(def_pos, "(?)", mlfScalar(3.0)), col_offset));
            /*
             * totalheight = def_pos(4) + row_offset;
             */
            mlfAssign(
              &totalheight,
              mlfPlus(mlfIndexRef(def_pos, "(?)", mlfScalar(4.0)), row_offset));
            /*
             * width = totalwidth/ncols*(max(col)-min(col)+1)-col_offset;
             */
            mlfAssign(
              &width,
              mlfMinus(
                mlfMtimes(
                  mlfMrdivide(totalwidth, ncols),
                  mlfPlus(
                    mlfMinus(
                      mlfMax(NULL, col, NULL, NULL),
                      mlfMin(NULL, col, NULL, NULL)),
                    mlfScalar(1.0))),
                col_offset));
            /*
             * height = totalheight/nrows*(max(row)-min(row)+1)-row_offset;
             */
            mlfAssign(
              &height,
              mlfMinus(
                mlfMtimes(
                  mlfMrdivide(totalheight, nrows),
                  mlfPlus(
                    mlfMinus(
                      mlfMax(NULL, row, NULL, NULL),
                      mlfMin(NULL, row, NULL, NULL)),
                    mlfScalar(1.0))),
                row_offset));
            /*
             * position = [def_pos(1)+min(col)*totalwidth/ncols ...
             */
            mlfAssign(
              &position,
              mlfHorzcat(
                mlfPlus(
                  mlfIndexRef(def_pos, "(?)", mlfScalar(1.0)),
                  mlfMrdivide(
                    mlfMtimes(mlfMin(NULL, col, NULL, NULL), totalwidth),
                    ncols)),
                mlfPlus(
                  mlfIndexRef(def_pos, "(?)", mlfScalar(2.0)),
                  mlfMrdivide(
                    mlfMtimes(mlfMin(NULL, row, NULL, NULL), totalheight),
                    nrows)),
                width,
                height,
                NULL));
            /*
             * def_pos(2)+min(row)*totalheight/nrows ...
             * width height];
             * if width <= 0.5*totalwidth/ncols
             */
            if (mlfTobool(
                  mlfLe(
                    width,
                    mlfMrdivide(
                      mlfMtimes(mlfScalar(0.5), totalwidth), ncols)))) {
                /*
                 * position(1) = def_pos(1)+min(col)*(def_pos(3)/ncols);
                 */
                mlfIndexAssign(
                  &position,
                  "(?)",
                  mlfScalar(1.0),
                  mlfPlus(
                    mlfIndexRef(def_pos, "(?)", mlfScalar(1.0)),
                    mlfMtimes(
                      mlfMin(NULL, col, NULL, NULL),
                      mlfMrdivide(
                        mlfIndexRef(def_pos, "(?)", mlfScalar(3.0)), ncols))));
                /*
                 * position(3) = 0.7*(def_pos(3)/ncols)*(max(col)-min(col)+1);
                 */
                mlfIndexAssign(
                  &position,
                  "(?)",
                  mlfScalar(3.0),
                  mlfMtimes(
                    mlfMtimes(
                      mlfScalar(0.7),
                      mlfMrdivide(
                        mlfIndexRef(def_pos, "(?)", mlfScalar(3.0)), ncols)),
                    mlfPlus(
                      mlfMinus(
                        mlfMax(NULL, col, NULL, NULL),
                        mlfMin(NULL, col, NULL, NULL)),
                      mlfScalar(1.0))));
            /*
             * end
             */
            }
            /*
             * if height <= 0.5*totalheight/nrows
             */
            if (mlfTobool(
                  mlfLe(
                    height,
                    mlfMrdivide(
                      mlfMtimes(mlfScalar(0.5), totalheight), nrows)))) {
                /*
                 * position(2) = def_pos(2)+min(row)*(def_pos(4)/nrows);
                 */
                mlfIndexAssign(
                  &position,
                  "(?)",
                  mlfScalar(2.0),
                  mlfPlus(
                    mlfIndexRef(def_pos, "(?)", mlfScalar(2.0)),
                    mlfMtimes(
                      mlfMin(NULL, row, NULL, NULL),
                      mlfMrdivide(
                        mlfIndexRef(def_pos, "(?)", mlfScalar(4.0)), nrows))));
                /*
                 * position(4) = 0.7*(def_pos(4)/nrows)*(max(row)-min(row)+1);
                 */
                mlfIndexAssign(
                  &position,
                  "(?)",
                  mlfScalar(4.0),
                  mlfMtimes(
                    mlfMtimes(
                      mlfScalar(0.7),
                      mlfMrdivide(
                        mlfIndexRef(def_pos, "(?)", mlfScalar(4.0)), nrows)),
                    mlfPlus(
                      mlfMinus(
                        mlfMax(NULL, row, NULL, NULL),
                        mlfMin(NULL, row, NULL, NULL)),
                      mlfScalar(1.0))));
            /*
             * end
             */
            }
        /*
         * end
         */
        }
    /*
     * end
     */
    }
    /*
     * 
     * % kill overlapping siblings if mnp specifier was used:
     * nextstate = get(gcf,'nextplot');
     */
    mlfAssign(&nextstate, mlfGet(mlfGcf(), mxCreateString("nextplot"), NULL));
    /*
     * if strncmp(nextstate,'replace',7), nextstate = 'add'; end
     */
    if (mlfTobool(
          mlfStrncmp(nextstate, mxCreateString("replace"), mlfScalar(7.0)))) {
        mlfAssign(&nextstate, mxCreateString("add"));
    }
    /*
     * if(kill_siblings)
     */
    if (mlfTobool(kill_siblings)) {
        /*
         * if delay_destroy
         */
        if (mlfTobool(delay_destroy)) {
            /*
             * if nargout
             */
            if (mlfTobool(nargout)) {
                /*
                 * error('Function called with too many output arguments')
                 */
                mlfError(
                  mxCreateString(
                    "Function called with too many output arguments"));
            /*
             * else
             */
            } else {
                /*
                 * set(gcf,'NextPlot','replace'); return,
                 */
                mclAssignAns(
                  &ans,
                  mlfNSet(
                    0,
                    mlfGcf(),
                    mxCreateString("NextPlot"),
                    mxCreateString("replace"),
                    NULL));
                goto return_;
            /*
             * end
             */
            }
        /*
         * end
         */
        }
        /*
         * sibs = datachildren(gcf);
         */
        mlfAssign(&sibs, mlfDatachildren(mlfGcf()));
        /*
         * got_one = 0;
         */
        mlfAssign(&got_one, mlfScalar(0.0));
        /*
         * for i = 1:length(sibs)
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), mlfLength(sibs), NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * % Be aware that handles in this list might be destroyed before
             * % we get to them, because of other objects' DeleteFcn callbacks...
             * if(ishandle(sibs(i)) & strcmp(get(sibs(i),'Type'),'axes'))
             */
            mxArray * a_ = mclInitialize(
                             mlfIshandle(mlfIndexRef(sibs, "(?)", i)));
            if (mlfTobool(a_)
                && mlfTobool(
                     mlfAnd(
                       a_,
                       mlfStrcmp(
                         mlfGet(
                           mlfIndexRef(sibs, "(?)", i),
                           mxCreateString("Type"),
                           NULL),
                         mxCreateString("axes"))))) {
                mxDestroyArray(a_);
                /*
                 * units = get(sibs(i),'Units');
                 */
                mlfAssign(
                  &units,
                  mlfGet(
                    mlfIndexRef(sibs, "(?)", i),
                    mxCreateString("Units"),
                    NULL));
                /*
                 * set(sibs(i),'Units','normalized')
                 */
                mclPrintAns(
                  &ans,
                  mlfNSet(
                    0,
                    mlfIndexRef(sibs, "(?)", i),
                    mxCreateString("Units"),
                    mxCreateString("normalized"),
                    NULL));
                /*
                 * sibpos = get(sibs(i),'Position');
                 */
                mlfAssign(
                  &sibpos,
                  mlfGet(
                    mlfIndexRef(sibs, "(?)", i),
                    mxCreateString("Position"),
                    NULL));
                /*
                 * set(sibs(i),'Units',units);
                 */
                mclAssignAns(
                  &ans,
                  mlfNSet(
                    0,
                    mlfIndexRef(sibs, "(?)", i),
                    mxCreateString("Units"),
                    units,
                    NULL));
                /*
                 * intersect = 1;
                 */
                mlfAssign(&intersect, mlfScalar(1.0));
                /*
                 * if(     (position(1) >= sibpos(1) + sibpos(3)-tol) | ...
                 */
                {
                    mxArray * a_ = mclInitialize(
                                     mlfGe(
                                       mlfIndexRef(
                                         position, "(?)", mlfScalar(1.0)),
                                       mlfMinus(
                                         mlfPlus(
                                           mlfIndexRef(
                                             sibpos, "(?)", mlfScalar(1.0)),
                                           mlfIndexRef(
                                             sibpos, "(?)", mlfScalar(3.0))),
                                         tol)));
                    if (mlfTobool(a_)) {
                        /*
                         * (sibpos(1) >= position(1) + position(3)-tol) | ...
                         */
                        mlfAssign(&a_, mlfScalar(1));
                    } else {
                        mlfAssign(
                          &a_,
                          mlfOr(
                            a_,
                            mlfGe(
                              mlfIndexRef(sibpos, "(?)", mlfScalar(1.0)),
                              mlfMinus(
                                mlfPlus(
                                  mlfIndexRef(position, "(?)", mlfScalar(1.0)),
                                  mlfIndexRef(position, "(?)", mlfScalar(3.0))),
                                tol))));
                    }
                    if (mlfTobool(a_)) {
                        mlfAssign(&a_, mlfScalar(1));
                    } else {
                        mlfAssign(
                          &a_,
                          mlfOr(
                            a_,
                            mlfGe(
                              mlfIndexRef(position, "(?)", mlfScalar(2.0)),
                              mlfMinus(
                                mlfPlus(
                                  mlfIndexRef(sibpos, "(?)", mlfScalar(2.0)),
                                  mlfIndexRef(sibpos, "(?)", mlfScalar(4.0))),
                                tol))));
                    }
                    if (mlfTobool(a_)
                        || mlfTobool(
                             mlfOr(
                               a_,
                               mlfGe(
                                 mlfIndexRef(sibpos, "(?)", mlfScalar(2.0)),
                                 mlfMinus(
                                   mlfPlus(
                                     mlfIndexRef(
                                       position, "(?)", mlfScalar(2.0)),
                                     mlfIndexRef(
                                       position, "(?)", mlfScalar(4.0))),
                                   tol))))) {
                        mxDestroyArray(a_);
                        /*
                         * (position(2) >= sibpos(2) + sibpos(4)-tol) | ...
                         * (sibpos(2) >= position(2) + position(4)-tol))
                         * intersect = 0;
                         */
                        mlfAssign(&intersect, mlfScalar(0.0));
                    } else {
                        mxDestroyArray(a_);
                    }
                /*
                 * end
                 */
                }
                /*
                 * if intersect
                 */
                if (mlfTobool(intersect)) {
                    /*
                     * if got_one | any(abs(sibpos - position) > tol)
                     */
                    if (mlfTobool(got_one)
                        || mlfTobool(
                             mlfOr(
                               got_one,
                               mlfAny(
                                 mlfGt(
                                   mlfAbs(mlfMinus(sibpos, position)), tol),
                                 NULL)))) {
                        /*
                         * delete(sibs(i));
                         */
                        mlfDelete(mlfIndexRef(sibs, "(?)", i), NULL);
                    /*
                     * else
                     */
                    } else {
                        /*
                         * got_one = 1;
                         */
                        mlfAssign(&got_one, mlfScalar(1.0));
                        /*
                         * set(gcf,'CurrentAxes',sibs(i));
                         */
                        mclAssignAns(
                          &ans,
                          mlfNSet(
                            0,
                            mlfGcf(),
                            mxCreateString("CurrentAxes"),
                            mlfIndexRef(sibs, "(?)", i),
                            NULL));
                        /*
                         * if strcmp(nextstate,'new')
                         */
                        if (mlfTobool(
                              mlfStrcmp(nextstate, mxCreateString("new")))) {
                            /*
                             * create_axis = 1;
                             */
                            mlfAssign(&create_axis, mlfScalar(1.0));
                        /*
                         * else
                         */
                        } else {
                            /*
                             * create_axis = 0;
                             */
                            mlfAssign(&create_axis, mlfScalar(0.0));
                        /*
                         * end
                         */
                        }
                    /*
                     * end
                     */
                    }
                /*
                 * end
                 */
                }
            } else {
                mxDestroyArray(a_);
            }
        /*
         * end
         * end
         */
        }
        /*
         * set(gcf,'NextPlot',nextstate);
         */
        mclAssignAns(
          &ans,
          mlfNSet(0, mlfGcf(), mxCreateString("NextPlot"), nextstate, NULL));
    /*
     * end
     */
    }
    /*
     * 
     * % create the axis:
     * if create_axis
     */
    if (mlfTobool(create_axis)) {
        /*
         * if strcmp(nextstate,'new'), figure, end
         */
        if (mlfTobool(mlfStrcmp(nextstate, mxCreateString("new")))) {
            mclPrintAns(&ans, mlfNFigure(0, NULL));
        }
        /*
         * ax = axes('units','normal','Position', position);
         */
        mlfAssign(
          &ax,
          mlfNAxes(
            1,
            mxCreateString("units"),
            mxCreateString("normal"),
            mxCreateString("Position"),
            position,
            NULL));
        /*
         * set(ax,'units',get(gcf,'defaultaxesunits'))
         */
        mclPrintAns(
          &ans,
          mlfNSet(
            0,
            ax,
            mxCreateString("units"),
            mlfGet(mlfGcf(), mxCreateString("defaultaxesunits"), NULL),
            NULL));
    /*
     * else 
     */
    } else {
        /*
         * ax = gca; 
         */
        mlfAssign(&ax, mlfGca(NULL));
    /*
     * end
     */
    }
    /*
     * 
     * 
     * % return identifier, if requested:
     * if(nargout > 0)
     */
    if (mlfTobool(mlfGt(nargout, mlfScalar(0.0)))) {
        /*
         * theAxis = ax;
         */
        mlfAssign(&theAxis, ax);
    /*
     * end
     */
    }
    return_:
    mclValidateOutputs("subplot", 1, nargout_, &theAxis);
    mxDestroyArray(PERC_OFFSET_B);
    mxDestroyArray(PERC_OFFSET_L);
    mxDestroyArray(PERC_OFFSET_R);
    mxDestroyArray(PERC_OFFSET_T);
    mxDestroyArray(ans);
    mxDestroyArray(ax);
    mxDestroyArray(code);
    mxDestroyArray(col);
    mxDestroyArray(col_offset);
    mxDestroyArray(create_axis);
    mxDestroyArray(def_pos);
    mxDestroyArray(delay_destroy);
    mxDestroyArray(got_one);
    mxDestroyArray(handle);
    mxDestroyArray(height);
    mxDestroyArray(i);
    mxDestroyArray(intersect);
    mxDestroyArray(kill_siblings);
    mxDestroyArray(narg);
    mxDestroyArray(nargin_);
    mxDestroyArray(nargout);
    mxDestroyArray(ncols);
    mxDestroyArray(nextstate);
    mxDestroyArray(nrows);
    mxDestroyArray(pos_size);
    mxDestroyArray(position);
    mxDestroyArray(row);
    mxDestroyArray(row_offset);
    mxDestroyArray(sibpos);
    mxDestroyArray(sibs);
    mxDestroyArray(thisPlot);
    mxDestroyArray(tmp);
    mxDestroyArray(tol);
    mxDestroyArray(totalheight);
    mxDestroyArray(totalwidth);
    mxDestroyArray(units);
    mxDestroyArray(width);
    return theAxis;
}

/*
 * The function "mlfNSubplot" contains the nargout interface for the "subplot"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/subplot.m"
 * (lines 1-232). This interface is only produced if the M-function uses the
 * special variable "nargout". The nargout interface allows the number of
 * requested outputs to be specified via the nargout argument, as opposed to
 * the normal interface which dynamically calculates the number of outputs
 * based on the number of non-NULL inputs it receives. This function processes
 * any input arguments and passes them to the implementation version of the
 * function, appearing above.
 */
mxArray * mlfNSubplot(int nargout,
                      mxArray * nrows,
                      mxArray * ncols,
                      mxArray * thisPlot) {
    mxArray * theAxis = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, nrows, ncols, thisPlot);
    theAxis = Msubplot(nargout, nrows, ncols, thisPlot);
    mlfRestorePreviousContext(0, 3, nrows, ncols, thisPlot);
    return mlfReturnValue(theAxis);
}

/*
 * The function "mlfSubplot" contains the normal interface for the "subplot"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/subplot.m"
 * (lines 1-232). This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
mxArray * mlfSubplot(mxArray * nrows, mxArray * ncols, mxArray * thisPlot) {
    int nargout = 1;
    mxArray * theAxis = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, nrows, ncols, thisPlot);
    theAxis = Msubplot(nargout, nrows, ncols, thisPlot);
    mlfRestorePreviousContext(0, 3, nrows, ncols, thisPlot);
    return mlfReturnValue(theAxis);
}

/*
 * The function "mlfVSubplot" contains the void interface for the "subplot"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/subplot.m"
 * (lines 1-232). The void interface is only produced if the M-function uses
 * the special variable "nargout", and has at least one output. The void
 * interface function specifies zero output arguments to the implementation
 * version of the function, and in the event that the implementation version
 * still returns an output (which, in MATLAB, would be assigned to the "ans"
 * variable), it deallocates the output. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
void mlfVSubplot(mxArray * nrows, mxArray * ncols, mxArray * thisPlot) {
    mxArray * theAxis = mclUnassigned();
    mlfEnterNewContext(0, 3, nrows, ncols, thisPlot);
    theAxis = Msubplot(0, nrows, ncols, thisPlot);
    mlfRestorePreviousContext(0, 3, nrows, ncols, thisPlot);
    mxDestroyArray(theAxis);
}

/*
 * The function "mlxSubplot" contains the feval interface for the "subplot"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/subplot.m"
 * (lines 1-232). The feval function calls the implementation version of
 * subplot through this function. This function processes any input arguments
 * and passes them to the implementation version of the function, appearing
 * above.
 */
void mlxSubplot(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: subplot Line: 1 Column: "
            "0 The function \"subplot\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: subplot Line: 1 Column:"
            " 0 The function \"subplot\" was called with m"
            "ore than the declared number of inputs (3)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0] = Msubplot(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}
