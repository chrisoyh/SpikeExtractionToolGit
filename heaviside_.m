% Workaround to include heaviside function in the compilation. Heaviside is
% part of the symbolic math toolbox, and it is not supported for use with
% MATLAB Compiler
function Y = heaviside_(X)
%HEAVISIDE    Step function.
%    HEAVISIDE(X) is 0 for X < 0 and 1 for X > 0.
%    The value HEAVISIDE(0) is 0.5 by default. It
%    can be changed to any value v by the call 
%    sympref('HeavisideAtOrigin', v).
%
%    HEAVISIDE(X) is not a function in the strict sense.
%    See also DIRAC.

%   Copyright 1993-2017 The MathWorks, Inc.
if nargin > 0
    X = convertStringsToChars(X);
end

persistent hAtOrigin;

if isa(X,'char') && strcmp(X, 'Clear') 
   % sympref calls heaviside with the argument
   % 'Clear' when 'HeavisideAtOrigin' is changed
   hAtOrigin = zeros(0);
   return;
else
   % support only sym, double, and single
   if ~(isa(X, 'double') || isa(X, 'single') || isa(X, 'sym'))
      error('Invalid data type. Argument must be single, double, or sym.');
   end
end
Y = zeros(size(X),'like',X);
Y(X > 0) = 1;
if any(X(:)==0) 
   if isempty(hAtOrigin)
      try
         hAtOrigin = cast(sympref('HeavisideAtOrigin'),'like',X);
      catch 
         error('Function call ''heaviside(0)'' yields a symbolic object. Use ''sympref("HeavisideAtOrigin", v)'' with some numeric value v to change ''heaviside(0)'' to v.');
      end
   end
   Y(X==0) = hAtOrigin;
end
Y(isnan(X) | imag(X) ~= 0 ) = NaN;
