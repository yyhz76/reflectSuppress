% single image reflection suppression via gradient thresholding and solving
% PDE using discrete cosine transform(DCT)

% Input:
% Im      - the input image
% h       - the gradient thresholding parameter
% epsilon - the epsilon in Eq.(3) in the paper

% Output:
% T - the dereflected image


% Sample run:

% Im = imread('./figures/train2.jpg');
% T = reflectSuppress(Im, 0.033, 1e-8);
% subplot(1,2,1); imshow(Im); subplot(1,2,2); imshow(T);


function T = reflectSuppress(Im, h, epsilon)     % move epsilon out of inputs
    
    Y = im2double(Im);     
    [m, n, r] = size(Y);
    T = zeros(m,n,r); 
    Y_Laplacian_2 = zeros(m,n,r);
    
    for dim = 1:r
        GRAD = grad(Y(:,:,dim));
        GRAD_x = GRAD(:,:,1);
        GRAD_y = GRAD(:,:,2);
        GRAD_norm = sqrt(GRAD_x.^2 + GRAD_y.^2);
        GRAD_norm_thresh = wthresh(GRAD_norm, 'h', h);                     % gradient thresholding
        ind = (GRAD_norm_thresh == 0);
        GRAD_x(ind) = 0;
        GRAD_y(ind) = 0;
        GRAD_thresh(:,:,1) = GRAD_x;
        GRAD_thresh(:,:,2) = GRAD_y;                                       
        Y_Laplacian_2(:,:,dim) = div(grad(div( GRAD_thresh)));             % compute L(div(delta_h(Y)))
    end
        
    rhs = Y_Laplacian_2 + epsilon * Y;     
        
    for dim = 1:r
        T(:,:,dim) = PoissonDCT_variant(rhs(:,:,dim), 1, 0, epsilon);      % solve the PDE using DCT 
    end

end




% solve the equation  (mu*L^2 - lambda*L + epsilon)*u = rhs via DCT
% where L means Laplacian operator 
function u = PoissonDCT_variant(rhs, mu, lambda, epsilon)   

[M,N]=size(rhs);

k=1:M;
l=1:N;
k=k';
eN=ones(1,N);
eM=ones(M,1);
k=cos(pi/M*(k-1));
l=cos(pi/N*(l-1));
k=kron(k,eN);
l=kron(eM,l);

kappa=2*(k+l-2);
const = mu * kappa.^2 - lambda * kappa + epsilon;
u=dct2(rhs);
u=u./const;
u=idct2(u);                       % refer to Theorem 1 in the paper

return
end



% compute the gradient of a 2D image array

function B=grad(A)

[m,n]=size(A);
B=zeros(m,n,2);

Ar=zeros(m,n);
Ar(:,1:n-1)=A(:,2:n);
Ar(:,n)=A(:,n);


Au=zeros(m,n);
Au(1:m-1,:)=A(2:m,:);
Au(m,:)=A(m,:);

B(:,:,1)=Ar-A;     
B(:,:,2)=Au-A;     

end


% compute the divergence of gradient
% Input A is a matrix of size m*n*2
% A(:,:,1) is the derivative along the x direction
% A(:,:,2) is the derivative along the y direction

function B=div(A)  

[m,n,~]=size(A);
B=zeros(m,n);

T=A(:,:,1);
T1=zeros(m,n);
T1(:,2:n)=T(:,1:n-1);

B=B+T-T1;

T=A(:,:,2);
T1=zeros(m,n);
T1(2:m,:)=T(1:m-1,:);

B=B+T-T1;
end