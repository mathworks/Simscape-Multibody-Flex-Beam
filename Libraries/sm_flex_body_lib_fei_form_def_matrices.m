function [M, L, K, H] = sm_flex_body_lib_fei_form_def_matrices( ...
    H, M, K, ksi, numFrames, dofIdxMap, rigidBodyFrame, sensedFeaDofs)
% This function constructs mass, stiffness, and other matrices used to
% calculate the force resisting deflection in a flexible element. The
% inputs to this function are commonly obtained from finite element
% software.
%
% H   : numFeaDofs*numCbModes matrix of CB modes or can be empty
% M   : numCbModes*numCbModes matrix
% K   : numCbModes*numCbModes matrix
% ksi : scalar or empty (in which case ksi = 0)
% numFrames : number of interface frames in the CB model
% dofIdxMap : numFrames x 6 matrix containing, for each interface frame,
%             the ux/uy/uz/tx/ty/tz indices in the FEA dof vector
% rigidBodyFrame : index of the interface frame to which
%                  the rigid body is attached
% sensedFeaDofs  : vector of FEA dof indices for dofs to be sensed

% Copyright 2017-2019 The MathWorks, Inc.

nd = 6;

numFeaDofs = size(H,1);  % Will be 0 if H is empty
numCbModes = length(K);  % max(size(K))

% Check inputs
assert( isempty(H) || isequal(size(H), [numFeaDofs, numCbModes]), ...
    'Problem with H in sm_flex_body_lib_fei_form_def_matrices' );
assert( isequal(size(M), [numCbModes, numCbModes]), ...
    'Problem with M in sm_flex_body_lib_fei_form_def_matrices' );
assert( isequal(size(K), [numCbModes, numCbModes]), ...
    'Problem with K in sm_flex_body_lib_fei_form_def_matrices' );
assert( isempty(ksi) || isscalar(ksi), ...
    'Problem with ksi in sm_flex_body_lib_fei_form_def_matrices' );
assert( numCbModes >= nd*numFrames, ...
    'Problem with numFrames in sm_flex_body_lib_fei_form_def_matrices' );
assert( isequal(size(dofIdxMap), [numFrames, nd]), ...
    'Problem with dofIdxMap in processStateSpaceSystemData' );
assert( 1 <= rigidBodyFrame && rigidBodyFrame <= numFrames, ...
    'Problem with rigidBodyFrame in sm_flex_body_lib_fei_form_def_matrices' );
assert( all(1 <= sensedFeaDofs & sensedFeaDofs <= numFeaDofs), ...
    'Problem with sensedFeaDofs in sm_flex_body_lib_fei_form_def_matrices' );

% If the ordering of frames in the FE tool is not consistent with the order
% of signals fed to the state-space block, use parameter dofIdxMap to swap
% the rows and columes of M, K, and H matrices so that they match.

dofIdxMap_trans = dofIdxMap';
dofIdxMap_vect = dofIdxMap_trans(:);
dofIdxMap_fullvect = [...
    dofIdxMap_vect;
    (length(dofIdxMap_vect)+1:size(M,2))'];

M1 = M;
M1 = M1(:,dofIdxMap_fullvect);
M1 = M1(dofIdxMap_fullvect,:);
M = M1;

dofIdxMap_fullvect = [...
    dofIdxMap_vect;
    (length(dofIdxMap_vect)+1:size(K,2))'];

K1 = K;
K1 = K1(:,dofIdxMap_fullvect);
K1 = K1(dofIdxMap_fullvect,:);
K = K1;

% Do not need to alter H - not tied to Simulink diagram

% Compute modal damping matrix
[eigvec, eigval] = eig(K, M);
eigval = diag(eigval);
[~, sortIdx] = sort(real(sqrt(eigval)));
modes = eigvec(:,sortIdx);
M2 = diag(modes'*M*modes);
K2 = diag(modes'*K*modes);

% Explicitly set rigid body mode frequencies to exactly 0.
K2(1:nd) = 0;
L = 2*ksi*sqrt(K2)./sqrt(M2)./M2;
L = M*modes*diag(L)*modes'*M;


% Matrix extracting sensed FEA dofs
if ~isempty(H)
    H = H(sensedFeaDofs,:);
end

end
