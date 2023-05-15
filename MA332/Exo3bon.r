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



lambda = 0
taux_service = 3
pas_lambda = 0.1

taux_utilisation = 0

file_theorique = array(dim=0)
taux_utilisation_theorique = array(dim=0)

file_pratique = array(dim=0)

plage = (taux_service/pas_lambda)-1
for (i in 1:plage) {
  lambda = lambda + pas_lambda
  taux_utilisation = lambda / taux_service
  q = (taux_utilisation/(1-taux_utilisation))
  taux_utilisation_theorique = append(taux_utilisation_theorique, taux_utilisation)
  file_theorique = append(file_theorique, q)
  
  max_t = 80
  nb_echantillon = 1000
  moy_clients_lambda = array(dim=0)
  
  for(t_actuel in 1:max_t) {
    moy_clients_t = array(dim=0)
    for(k in 1:nb_echantillon) {
      T = t_actuel
      instants = array(dim = 0)
      nb_clients_instant = array(dim = 0)
      
      nb_clients_actuel = 0
      t = 0
      
      while (t < T) {
        instants = append(instants, t)
        nb_clients_instant = append(nb_clients_instant, nb_clients_actuel)
        
        temps_arrivee = rexp(1, lambda)
        temps_service = rexp(1, taux_service)
        
        if (nb_clients_actuel > 0) {
          if (temps_arrivee < temps_service) {
            t = t + temps_arrivee
            nb_clients_actuel = nb_clients_actuel + 1
          } else {
            if (temps_arrivee != temps_service){
              nb_clients_actuel = nb_clients_actuel - 1
            }
            t = t + temps_service
          }  
        } else {
          t = t + temps_arrivee
          nb_clients_actuel = nb_clients_actuel + 1
        }
      }
      
      inter_temps = array(dim=0)
      for (i in 1:length(instants)) {
        inter_temps = append(inter_temps, instants[i+1]-instants[i])
      }
      inter_temps[length(instants)] = 0
      moy_clients = weighted.mean(nb_clients_instant, inter_temps)
      moy_clients_t = append(moy_clients_t, moy_clients)
    }
    moy_clients_lambda = append(moy_clients_lambda, cumsum(moy_clients_t)[length(moy_clients_t)]/length(moy_clients_t))
  }
  file_pratique = append(file_pratique, (cumsum(moy_clients_lambda)[length(moy_clients_lambda)]/length(moy_clients_lambda)))
  
}

plot(taux_utilisation_theorique, file_theorique, xlab="taux_utilisation", ylab="Q", main = "File M/M/1", col="blue", type="l")
lines(taux_utilisation_theorique, file_pratique, col="red", type="l", lwd = 2, lty = 2)
legend("topleft", legend=c("Moyenne théorique", "Moyenne mesurée"),col=c("blue", "red"), lty = 1:2, lwd=2)