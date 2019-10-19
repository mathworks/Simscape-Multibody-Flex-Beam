function sys = sm_flex_body_lib_fei_form_statespace(Nf, M, L, K, H)
% This function constructs the state-space matrices that calculate the
% forces resisting deformation.  It assembles them from the mass,
% stiffness, and other matrices that describe the flexible body.
%
% Nf is the number of interface frames
% M must be a numDofs*numDofs matrix
% L can be a numDofs*numDofs matrix or an empty matrix (L = 0 in that case)
% K must be a numDofs*numDofs matrix
% H can be a matrix with numDofs columns or an empty matrix

% Copyright 2017-2019 The MathWorks, Inc.

Nd = length(K);
Nb = 6*Nf;
Nm = Nd - Nb;

rb = 1:Nb;
rm = Nb+1:Nd;

% Process K input
assert( isequal(size(K), [Nd, Nd]), ...
    'Problem with size of K in sm_flex_body_lib_fei_form_statespace' );
Kbb = K(rb,rb);
Kbm = K(rb,rm);
Kmb = K(rm,rb);
Kmm = K(rm,rm);

% Process L input
if isempty(L)
    L = zeros(size(K));
end
assert( isequal(size(L), [Nd, Nd]), ...
    'Problem with size of L in sm_flex_body_lib_fei_form_statespace' );
Lbb = L(rb,rb);
Lbm = L(rb,rm);
Lmb = L(rm,rb);
Lmm = L(rm,rm);

% Process M input
assert( isequal(size(M), [Nd, Nd]), ...
    'Problem with size of M in sm_flex_body_lib_fei_form_statespace' );
Mbb = M(rb,rb);
Mbm = M(rb,rm);
Mmb = M(rm,rb);
Mmm = M(rm,rm);

% Process H input
if isempty(H)
    H = zeros(0,Nd);
end
assert( isequal(size(H,2), Nd), ...
    'Problem with size of H in sm_flex_body_lib_fei_form_statespace' );
Hb = H(:,rb);
Hm = H(:,rm);

% Form state-space system
Kmm2 = Mmm\Kmm;
Lmm2 = Mmm\Lmm;
Kmb2 = Mmm\Kmb;
Lmb2 = Mmm\Lmb;
Mmb2 = Mmm\Mmb;

sys.A = [ zeros(Nm,Nm) , eye(Nm,Nm) ; -Kmm2 , -Lmm2 ];
sys.B = [ zeros(Nm,3*Nb) ; -Kmb2 , -Lmb2 , -Mmb2 ];
sys.C = [ -(Kbm-Mbm*Kmm2) , -(Lbm-Mbm*Lmm2) ; Hm , zeros(size(Hm)) ];
sys.D = [ -(Kbb-Mbm*Kmb2) , -(Lbb-Mbm*Lmb2) , -(Mbb-Mbm*Mmb2) ; Hb , zeros(size(Hb)) , zeros(size(Hb)) ];

%sys = ss(A, B, C, D);

end
