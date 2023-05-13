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
