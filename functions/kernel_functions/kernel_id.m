function [kernel_label] = kernel_id( kernel_name )
%KERNEL_ID return the kernel charc correspondent to kernel_name

% KTYPE   defines the kernel type
%         'linear'       | 'l': A*B'
%         'polynomial'   | 'p': sign(A*B'+1).*(A*B'+1).^P
%         'homogeneous'  | 'h': sign(A*B').*(A*B').^P
%         'exponential'  | 'e': exp(-(||A-B||)/P)
%         'radial_basis' | 'r': exp(-(||A-B||.^2)/(P*P))
%         'sigmoid'      | 's': sigm((sign(A*B').*(A*B'))/P)
%         'distance'     | 'd': ||A-B||.^P
%         'cityblock'    | 'c': ||A-B||_1

match = false;

kernel_label = 'ERROR';
 
if strcmp(kernel_name,'linear')
    kernel_label = 'l';
    match = true;
end

if strcmp(kernel_name,'polynomial')
    kernel_label = 'p';
    match = true;
end

if strcmp(kernel_name,'homogeneous')
    kernel_label = 'h';
    match = true;
end

if strcmp(kernel_name,'exponential')
    kernel_label = 'e';
    match = true;
end

if strcmp(kernel_name,'radial_basis')
    kernel_label = 'r';
    match = true;
end

if strcmp(kernel_name,'sigmoid')
    kernel_label = 's';
    match = true;
end

if strcmp(kernel_name,'distance')
    kernel_label = 'd';
    match = true;
end


if strcmp(kernel_name,'cityblock')
    kernel_label = 'c';
    match = true;
end

if ~match
    error('NO MATCH KERNEL TYPE');
end

end

