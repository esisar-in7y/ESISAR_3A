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

instant_arrivee <- cumsum(rexp(N_T, lambda))  # Calcul des instants d'arrivée

# Vérification de la loi Gamma avec un test de Kolmogorov-Smirnov
ks.test(instant_arrivee, pgamma, shape = N_T, scale = 1/lambda)

lambda <- N_T / T  # Paramètre de la loi de Poisson

# Répéter la simulation jusqu'à obtenir N_T arrivées
repeat {
  instant_arrivee <- cumsum(rexp(N_T, lambda))
  if (instant_arrivee[N_T] <= T) break
}

# Vérification de la distribution uniforme
hist(instant_arrivee, breaks = seq(0, T, by = 1), freq = FALSE,
     main = "Distribution des instants d'arrivée", xlab = "Temps (s)")
abline(h = 1/T, col = "red")
