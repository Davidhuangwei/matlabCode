% By popular demand, NuPlaceField has finally been renamed to PlaceField
%
% you can still use this one though

function [PlaceMap, OccupancyMap] = NuPlaceField(varargin)

if nargout==0
    PlaceField(varargin{:});
elseif nargout==1
    PlaceMap = PlaceField(varargin{:});
else
    [PlaceMap, OccupancyMap] = PlaceField(varargin{:});
end
