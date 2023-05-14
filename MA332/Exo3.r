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

# Question 3
rho <- seq(0.1, 0.9, by = 0.1)
Q <- numeric(length(rho))
for(i in 1:length(rho)){
  n_sim <- 1000 # Nombre de simulations
  n_clients <- numeric(n_sim)
  for(j in 1:n_sim){
    # Simulation
    t <- 0
    n <- 0
    while(t < T){
      alpha <- rho[i]*lambda*(1-n/1)
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
    # Nombre de clients dans le système en régime stationnaire
    n_clients[j] <- n
  }
  # Calcul de Q en régime stationnaire
  Q[i] <- mean(n_clients)/rho[i] -
