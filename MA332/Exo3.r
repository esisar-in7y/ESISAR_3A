# Paramètres du modèle
lambda <- 2 # Taux d'arrivée
mu <- 3 # Taux de service

# Durée de la simulation
T <- 20

# Initialisation
t <- 0
n <- 0 # Nombre de clients dans la file (buffer + serveur)
X <- data.frame(t, n)

# Simulation
while(t < T){
  # Calcul des taux d'arrivée et de service
  alpha <- lambda*(1-n/1)
  beta <- mu*n
  
  # Événement suivant
  u <- runif(1)
  if(u < alpha/(alpha+beta)){
    # Arrivée d'un client
    t <- t + rexp(1, rate = alpha+beta)
    n <- n + 1
  }else{
    # Départ d'un client
    t <- t + rexp(1, rate = alpha+beta)
    n <- n - 1
  }
  
  # Enregistrement de l'état du système
  X <- rbind(X, data.frame(t, n))
}

# Graphique
plot(X$t, X$n, type = "s", xlab = "Temps", ylab = "Nombre de clients dans la file")

# Question 2
T <- seq(10, 100, by = 10)
mean_clients <- numeric(length(T))
for(i in 1:length(T)){
  n_sim <- 100 # Nombre de simulations
  n_clients <- numeric(n_sim)
  for(j in 1:n_sim){
    # Simulation
    t <- 0
    n <- 0
    while(t < T[i]){
      alpha <- lambda*(1-n/1)
      beta <- mu*n
      u <- runif(1)
      if(u < alpha/(alpha+beta)){
        t <- t + rexp(1, rate = alpha+beta)
        n <- n + 1
      }else{
        t <- t + rexp(1, rate = alpha+beta)
        n <- n - 1
      }
    }
    # Nombre de clients dans le système à la fin de la simulation
    n_clients[j] <- n
  }
  mean_clients[i] <- mean(n_clients)
}
# Affichage des résultats
cbind(T, mean_clients) # Nombre moyen de clients dans le système en fonction de T


# Parameters
lambda <- seq(0.001, 2, by = 0.01)
mu <- 3

# Function to calculate Q and W
calculate_Q_W <- function(lambda, mu) {
  nrep <- 1000
  sum_Q <- 0
  sum_W <- 0
  
  for (i in 1:nrep) {
    t <- 0
    n <- 0
    Q <- 0
    W <- 0
    arrivals <- rexp(1, lambda)
    departures <- Inf
    
    while (t < 1000) {
      if (arrivals < departures) {
        n <- n + 1
        t <- arrivals
        Q <- Q + (n - 1)
        W <- W + (n - 1) / lambda
        arrivals <- arrivals + rexp(1, lambda)
      } else {
        n <- n - 1
        t <- departures
        if (n > 0) {
          departures <- t + rexp(1, mu)
        } else {
          departures <- Inf
        }
      }
    }
    
    sum_Q <- sum_Q + Q / t
    sum_W <- sum_W + W / t
  }
  
  Q <- sum_Q / nrep
  W <- sum_W / nrep
  
  return(list(Q = Q, W = W))
}

# Calculate Q and W for different values of lambda
results <- data.frame(lambda = lambda, Q = NA, W = NA)

for (i in 1:length(lambda)) {
  temp <- calculate_Q_W(lambda[i], mu)
  results$Q[i] <- temp$Q
  results$W[i] <- temp$W
}

# Plot the results
library(ggplot2)

ggplot(results, aes(x = lambda)) +
  geom_line(aes(y = Q, colour = "Q")) +
  geom_line(aes(y = W, colour = "W")) +
  scale_colour_manual(values = c("Q" = "red", "W" = "blue")) +
  xlab("Arrival rate (lambda)") +
  ylab("Number of customers (Q) / Time spent in system (W)") +
  ggtitle("Queueing System Performance") +
  theme(plot.title = element_text(hjust = 0.5))

       
# Question 3b
rho_values <- seq(0.1, 0.95, by = 0.05)
T <- 1000
T_values <- seq(100, T, by = 100)

# Fonction pour simuler la file M/M/1
mm1_simulation <- function(lambda, mu, T) {
  # Initialisation
  n <- 0
  n_arrivals <- 0
  n_departures <- 0
  arrivals <- rexp(1, rate = lambda)
  departures <- Inf
  
  # Simulation
  while (arrivals <= T || departures <= T) {
    if (arrivals < departures) {
      n_arrivals <- n_arrivals + 1
      n <- n + 1
      arrivals <- arrivals + rexp(1, rate = lambda)
    } else {
      n_departures <- n_departures + 1
      n <- n - 1
      if (n >= 1) {
        departures <- departures + rexp(1, rate = mu)
      } else {
        departures <- Inf
      }
    }
  }
  
  # Calcul de la moyenne du nombre de clients dans le système
  mean_clients <- (1 / T) * sum(cumsum(c(rep(1, n_arrivals), rep(-1, n_departures)))) 
  
  return(mean_clients)
}

# Fonction pour calculer le paramètre opérationnel
op_param <- function(lambda, mu, T) {
  Q_T <- rep(0, length(T))
  for (i in 1:length(T)) {
    Q_T[i] <- mm1_simulation(lambda, mu, T[i])
  }
  
  return(mean(Q_T))
}

# Calcul et représentation graphique du paramètre opérationnel en fonction de rho
op_rho <- rep(0, length(rho_values))
for (i in 1:length(rho_values)) {
  lambda <- rho_values[i] * 2
  mu <- 3
  op_rho[i] <- op_param(lambda, mu, T)
}

plot(rho_values, op_rho, type = "l", xlab = "rho", ylab = "Opérationnel")
