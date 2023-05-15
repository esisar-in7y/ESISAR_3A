# Fixer la graine pour la reproductibilité
set.seed(123)

# Définir l'intervalle de temps et le paramètre lambda
T <- 3600 # secondes
lambda <- 1/3 # arrivées par seconde

# Simuler les temps entre arrivées en utilisant une distribution exponentielle
temps_entre_arrivees <- rexp(1000, rate = lambda)

# Calculer les temps d'arrivée à partir des temps entre arrivées
temps_arrivees <- cumsum(temps_entre_arrivees)

# Tracer l'histogramme des temps entre arrivées
hist(temps_entre_arrivees, breaks = 20, main = "Histogramme des temps entre arrivées", xlab = "Temps (s)")

# Tracer les temps d'arrivée en fonction du temps
plot(temps_arrivees, 1:length(temps_arrivees), type = "s", main = "Arrivées au fil du temps", xlab = "Temps (s)", ylab = "Nombre d'arrivées")

# Calculer le nombre moyen d'arrivées dans l'intervalle de temps [0, T]
num_simulations <- 1000
num_arrivees <- numeric(num_simulations)
for (i in 1:num_simulations) {
  temps_entre_arrivees <- rexp(2000, rate = lambda)
  temps_arrivees <- cumsum(temps_entre_arrivees)
  num_arrivees[i] <- sum(temps_arrivees <= T)
}
moyenne_arrivees <- mean(num_arrivees)
cat("Nombre moyen d'arrivées dans [0, T] =", moyenne_arrivees, "\n")

# Calculer la moyenne et la variance théoriques du nombre d'arrivées dans [0, T]
moyenne_theorique <- lambda * T
variance_theorique <- lambda * T
cat("Moyenne et variance théoriques des arrivées dans [0, T] =", moyenne_theorique, variance_theorique, "\n")

# Calculer la moyenne et la variance empiriques du nombre d'arrivées dans [0, T]
moyenne_empirique <- mean(num_arrivees)
variance_empirique <- var(num_arrivees)
cat("Moyenne et variance empiriques des arrivées dans [0, T] =", moyenne_empirique, variance_empirique, "\n")


# (iii)
# A
# Fixer T et N(T)

# Définir l'intervalle de temps et le paramètre lambda
T <- 60 # secondes
num_arrivees <- 20
num_simulations <- 100
An <- matrix(nrow=num_arrivees, ncol=num_simulations)

for (i in 1:num_simulations) {
  temps_entre_arrivees <- rexp(num_arrivees, rate = lambda)
  temps_arrivees <- cumsum(temps_entre_arrivees)
  An[, i] <- temps_arrivees
}

simu_utiles = list(2,5,10,20);
for (n in simu_utiles) {
  An_density <- density(An[n, ])
  plot(An_density, main = paste("An =", n),
       xlab = "Temps d'arrivée", ylab = "Densité")
  lines(An_density$x, dgamma(An_density$x, n, rate = lambda), col = "red")
}
uniform_arrivals <- matrix(nrow=num_arrivees, ncol=num_simulations)

for (i in 1:num_simulations) {
  uniform_arrivals[, i] <- sort(runif(num_arrivees, min = 0, max = T))
}

for (n in simu_utiles) {
  uniform_density <- density(uniform_arrivals[n, ])
  plot(uniform_density, main = paste("Uniform Arrivals n =", n),
       xlab = "Temps d'arrivée", ylab = "Densité")
  lines(uniform_density$x, dgamma(uniform_density$x, n, rate = lambda), col = "red")
}

#B
num_arrivees <- 20
An <- matrix(nrow=num_arrivees, ncol=num_simulations)

for (i in 1:num_simulations) {
  # Simuler les temps entre arrivées en utilisant une distribution exponentielle
  temps_entre_arrivees <- rexp(1000, rate = lambda)
  # Calculer les temps d'arrivée à partir des temps entre arrivées
  temps_arrivees <- cumsum(temps_entre_arrivees)
  temps_arrivees_20 <- temps_arrivees[temps_arrivees <= T]
  
  if (length(temps_arrivees_20) == num_arrivees) {
    An[, i] <- temps_arrivees_20
  }
}

# Supprimer les colonnes vides dans la matrice An
An <- An[, colSums(is.na(An)) != nrow(An)]

# Tracé de la densité empirique de An et de la loi uniforme U([0:T])
densitya <- density(An)
x <- -1000:T+1000
plot(x, dunif(x, min=0, max=T), col="red",
     type="s",xlim=c(-100,T+100))
lines(densitya, type="s")

