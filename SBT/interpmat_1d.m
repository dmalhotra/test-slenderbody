function L = interpmat_1d(t,s)
% INTERPMAT_1D   interpolation matrix from nodes in 1D to target nodes
%
% L = interpmat_1d(t,s) returns interpolation matrix taking values on nodes s
%  to target nodes t. Computed in Helsing style.

% bits taken from qplp/interpmatrix.m from 2013.
% Barnett 7/17/16. Auto-centering & scaling for stability 12/23/21.

if nargin==0, test_interpmat_1d; return; end

cen = (max(s)+min(s))/2; hwid = (max(s)-min(s))/2;   % affine s to [-1,1]
s = (s-cen)/hwid;
t = (t-cen)/hwid;

p = numel(s); q = numel(t); s = s(:); t = t(:);       % all col vecs
n = p; % set the polynomial order we go up to (todo: check why bad if not p)
V = ones(p,n); for j=2:n, V(:,j) = V(:,j-1).*s; end   % polyval matrix on nodes
R = ones(q,n); for j=2:n, R(:,j) = R(:,j-1).*t; end   % polyval matrix on targs
L = (V'\R')'; % backwards-stable way to do it (Helsing) See corners/interpdemo.m

%%%%%%
function test_interpmat_1d
off = 1.3;           % test centering and scaling
sc = 0.01;
x = sc*gauss(16) + off;
f = @(x) sin(x + 0.7);
data = f(x);            % func on smooth (src) nodes
t = sc*(2*rand(1000,1) - 1) + off;    % cover same interval as the x lie
uex = f(t);     % col vec
L = interpmat_1d(t,x);
u = L * data;
fprintf('max abs err for interp in [a,b] : %.3g\n',max(abs(u - uex)))
fprintf('interp mat inf-norm = %.3g;   max element size = %.3g\n',norm(L,inf),max(abs(L(:))))
