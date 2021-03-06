function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
K = size(Theta2, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


a1 = [ones(m, 1) X]';
z2 = Theta1 * a1;
a2 = [ones(1, m); sigmoid(z2)];
a3 = sigmoid(Theta2 * a2);

h_theta = a3';


for k = 1:K
	yk = y == k;
	h_theta_k = h_theta(:,k);
	J += sum(-yk' * log(h_theta_k) - (1 - yk') * log(1 - h_theta_k))/m;
endfor

Theta1_r = Theta1(:,2:input_layer_size+1)(:);
Theta2_r = Theta2(:,2:hidden_layer_size+1)(:);

J += lambda * (sum(Theta1_r.^2) + sum(Theta2_r .^2) )/(2*m);

% J = sum(-y1' * log(h_theta) - (1 - y1') * log(1 - h_theta))/m


Delta_1 = zeros(size(Theta1));
Delta_2 = zeros(size(Theta2));

Theta2_0 = (Theta2(:,2:size(Theta2,2)));


t = 1;
for t = 1:m
	X_t = X(t,:);
	a1_t = [1, X_t]';
	z2_t = Theta1 * a1_t;

	a2_t = [1 ; sigmoid(z2_t)];
	a3_t = sigmoid(Theta2 * a2_t);
	h_theta_t = a3_t;

	y_t = zeros(num_labels, 1);
	y_t(y(t)) = 1;

	delta_3 = a3_t - y_t;
	delta_2 = (Theta2_0' * delta_3) .* sigmoidGradient(z2_t);
		
	Delta_1 = Delta_1 + delta_2 * a1_t';
	Delta_2 = Delta_2 + delta_3 * a2_t';

endfor


Theta1_grad = Delta_1 / m;
Theta2_grad = Delta_2 / m;


Reg_1 = Theta1 * lambda / m;
Reg_2 = Theta2 * lambda / m;

Reg_1(:,1) = 0;
Reg_2(:,1) = 0;


Theta1_grad = Theta1_grad + Reg_1;
Theta2_grad = Theta2_grad + Reg_2;

% /Users/Snackovich/projects/octave/machine-learning-octave/machine-learning-ex4/ex4






% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
