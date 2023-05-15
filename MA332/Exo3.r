<<<<<<< HEAD

  # # On définit les valeurs que suit notre file
  # T = 20
  # lambda = 2
  # mu = 3
  # 
  # # Liste des valeurs qui seront sur le graphique
  # instants = array(dim = 0)
  # nb_clients = array(dim = 0)
  # 
  # # Variable temporaire pour la file
  # nbActualClient = 0
  # t = 0
  # 
  # while (t < T) {
  #   instants = append(instants, t)
  #   nb_clients = append(nb_clients, nbActualClient)
  #   
  #   temps_arrivee = rexp(1, lambda)
  #   temps_service = rexp(1, mu)
  #   
  #   if (nbActualClient > 0) {
  #     if (temps_arrivee < temps_service) {
  #       t = t + temps_arrivee
  #       nbActualClient = nbActualClient + 1
  #     } else {
  #       if (temps_arrivee != temps_service){
  #         nbActualClient = nbActualClient - 1
  #       }
  #       t = t + temps_service
  #     }  
  #   } else {
  #     t = t + temps_arrivee
  #     nbActualClient = nbActualClient + 1
  #   }
  # }
  # 
  # plot(instants, nb_clients, xlab="T (min)", ylab="N(T)", type="s")



lambda <- 2
T <- 20*60
mu <- 3
arrivals <- cumsum(rexp(n = T * lambda, rate = lambda))
service_times <- rexp(n = T * lambda, rate = mu)

queue <- c()
buffer <- c()
server <- 0
time <- 0
i <- 1

while (time <= T) {
  if (length(queue) > 0 && server == 0) {
    server <- queue[1]
    queue <- queue[-1]
  }
  
  if (i <= length(arrivals) && arrivals[i] < time) {
    queue <- c(queue, service_times[i])
    buffer <- c(buffer, length(queue) + ifelse(server == 0, 0, 1))
    i <- i + 1
  }
  
  if (server > 0) {
    server <- max(server - 1, 0)
  }
  
  time <- time + 1
}

time_vector <- 1:length(buffer)
plot(time_vector, buffer, type = "l", xlab = "Temps", ylab = "Nombre de clients dans la file (buffer et serveur)")

=======
set.seed(0)
# Paramètres du modèle
temps_total = 20
lambda = 2
mu = 3

# Initialisation
liste_temps = array(dim = 0)
nombre_clients = array(dim = 0)

# Variable temporaire pour la file
nombre_clients_actuel = 0
temps = 0

# Simulation
while (temps < temps_total) {
  liste_temps = append(liste_temps, temps)
  nombre_clients = append(nombre_clients, nombre_clients_actuel)
  
  temps_arrivee = rexp(1, lambda)
  temps_service = rexp(1, mu)
  
  if (nombre_clients_actuel > 0) {
    if (temps_arrivee < temps_service) {
      temps = temps + temps_arrivee
      nombre_clients_actuel = nombre_clients_actuel + 1
    } else {
      if (temps_arrivee != temps_service){
        nombre_clients_actuel = nombre_clients_actuel - 1
      }
      temps = temps + temps_service
    }  
  } else {
    temps = temps + temps_arrivee
    nombre_clients_actuel = nombre_clients_actuel + 1
  }
}

# Graphique
plot(liste_temps,nombre_clients, type = "s", xlab = "Temps", ylab = "Nombre de clients dans la file")




# Question 2
T <- seq(0, 500, by = 5)
file_simple <- function(temps_total){
  temps_arrivee <- array(dim = 1)
  temps_service <- array(dim = 1)
  
  # Remplir le tableau des temps d'arrivée
  temps_arrivee[1] <- rexp(1, lambda)
  t <- temps_arrivee[1]
  i <- 2
  while(t < temps_total){
    tmp <- rexp(1, lambda)
    if (tmp + t < temps_total)
      temps_arrivee <- append(temps_arrivee, tmp + t)
    t <- tmp + t
    i <- i + 1
  }
  
  # Remplir le tableau des temps de service
  temps_service[1] <- rexp(1, mu)
  t <- temps_service[1]
  i <- 2
  while(t < temps_total){
    tmp <- rexp(1, mu)
    if (tmp + t < temps_total)
      temps_service <- append(temps_service, tmp + t)
    t <- tmp + t
    i <- i + 1
  }
  
  # Initialiser les vecteurs à tracer
  N <- array(dim = 1)
  temps <- array(dim = 1)
  N[1] <- 0
  temps[1] <- 0
  
  # Construire les vecteurs à tracer à partir des temps d'arrivée et de service
  i <- 1
  j <- 1
  k <- 2
  while (!is.na(temps_arrivee[i]) && !is.na(temps_service[j])){
    
    # Un client arrive
    if (temps_arrivee[i] < temps_service[j]){
      temps <- append(temps, temps_arrivee[i])
      N <- append(N, N[k-1] + 1)
      i <- i + 1
    }
    
    # Un client est servi
    else if (temps_arrivee[i] > temps_service[j]){
      temps <- append(temps, temps_service[j])
      if (N[k-1] > 0)
        N <- append(N, N[k-1] - 1)
      else
        N <- append(N, N[k-1])
      j <- j + 1
    }
    
    # Service se termine en même temps que l'arrivée d'un client
    else if (temps_arrivee[i] == temps_service[j]){
      temps <- append(temps, temps_arrivee[i])
      N <- append(N, N[k-1])
      i <- i + 1
      j <- j + 1
    }
    
    k <- k + 1
  }
  
  # Terminer de parcourir les temps de service et d'arrivée
  while (!is.na(temps_arrivee[i])){
    temps <- append(temps, temps_arrivee[i])
    N <- append(N, N[k-1] + 1)
    i <- i + 1
    k <- k + 1
  }
  while (!is.na(temps_service[j])){
    temps <- append(temps, temps_service[j])
    if (N[k-1] > 0)
      N <- append(N, N[k-1] - 1)
    else
      N <- append(N, N[k-1])
    j <- j + 1
    k <- k + 1
  }
  
  # Dernier point à t = temps_total
  N <- append(N, N[k-1])
  temps <- append(temps, temps_total)
  
  interTime = array(dim=0)
  for (i in 1:length(temps)) {
    interTime = append(interTime, temps[i+1] - temps[i])
  }
  interTime[length(temps)] = 0
  return (weighted.mean(N, interTime))
}


moyenne_mm1 <- function(temps_total, nb_tests){
  q <- 0
  for (i in 1:nb_tests){
    q <- q + file_simple(temps_total)
  }
  return (q/nb_tests)
}
moy <- rep(0, length(T))
for (i in 1:length(T)) {
  if(i!=0){
    moy[i] <- moyenne_mm1(T[i],100);
  }
}
moy[0] <- 0;
rho = lambda / mu
theorique = (rho/(1-rho))
plot(T, moy, xlab="T (min)", ylab="Nombre de client moyen", main = "File M/M/1", col="blue", type="l")
lines(T, array(data=(theorique),dim=length(T)), col="red", type="l", lwd = 2, lty = 2)
legend("bottomright", legend=c("Moyenne mesurée", "Moyenne théorique"),col=c("blue", "red"), lty = 1:2, lwd=2)




# Affichage des résultats
cbind(T, mean_clients) # Nombre moyen de clients dans le système en fonction de T


# Question 3a
# Parameters
lambda <- seq(0.001, 2, by = 0.01)
mu <- 3

# Function to calculate Q and W
calculate_Q_W <- function(lambda, mu) {
  nrep <- 10 #1000
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

# Plot the results using base R plot function
plot(results$lambda, results$Q, type = "l", col = "red", ylim = c(0, max(results$Q, results$W)), 
     xlab = "Temps d'arrivée (lambda)", 
     ylab = "Nombre de client (Q) / Temps passé dans la queue (W)", 
     main = "Performance du system de queue")
lines(results$lambda, results$W, col = "blue")
legend("topright", legend = c("Q", "W"), col = c("red", "blue"), lty = 1, bty = "n")




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
>>>>>>> 52ed9c80bb42e5da22acc1e1789afce2fe0d6097
