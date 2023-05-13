# Matrice de transition
P <- matrix(c(0.85, 0.15, 0, 0, 0.1, 0.9, 0.33, 0.67, 0.15, 0.2, 0.65, 0, 0, 0, 0, 1), nrow = 4, byrow = TRUE)

# Vecteur d'état initial
X <- c(1, 0, 0, 0)

# Nombre de semaines
T <- 5

# Calcul théorique
X_t <- X %*% (P^T)

# Simulation
N <- 100000 # nombre de simulations
X_sim <- matrix(NA, nrow = N, ncol = 4)
X_sim[1,] <- X
for (i in 2:N) {
  X_sim[i,] <- X_sim[i-1,] %*% P
}

# Proportions finales dans la population
prop_mort <- sum(X_t[1:3,4])
prop_vaccine <- X_t[1,2] + X_t[2,2] + X_t[3,2]
prop_sain <- X_t[1,1] + X_t[2,1] + X_t[3,1]
prop_malade <- 1 - (prop_mort + prop_vaccine + prop_sain)

# Proportions finales dans la population (simulation)
prop_mort_sim <- sum(X_sim[N,1:3] %*% c(0,0,0,1))
prop_vaccine_sim <- sum(X_sim[N,1:2] %*% c(0,1,0,0))
prop_sain_sim <- sum(X_sim[N,1:3] %*% c(1,0,0,0))
prop_malade_sim <- 1 - (prop_mort_sim + prop_vaccine_sim + prop_sain_sim)

# Affichage des résultats
cat("Proportions finales (calcul théorique) : \n")
cat(paste("Mortes : ", round(prop_mort, 2), "\n"))
cat(paste("Vaccinées/immunisées : ", round(prop_vaccine, 2), "\n"))
cat(paste("Saines : ", round(prop_sain, 2), "\n"))
cat(paste("Malades : ", round(prop_malade, 2), "\n"))
cat("\n")
cat("Proportions finales (simulation) : \n")
cat(paste("Mortes : ", round(prop_mort_sim, 2), "\n"))
cat(paste("Vaccinées/immunisées : ", round(prop_vaccine_sim, 2), "\n"))
cat(paste("Saines : ", round(prop_sain_sim, 2), "\n"))
cat(paste("Malades : ", round(prop_malade_sim, 2), "\n"))


set.seed(123)
n_simulations <- 100000
results <- numeric(n_simulations)

for (i in 1:n_simulations) {
  current_state <- 0 # Robert est sain
  while (current_state != 1 & current_state != 3) {
    if (current_state == 0) {
      # Sain
      if (runif(1) < 0.15) {
        # Tombe malade
        current_state <- 2
      } else if (runif(1) < 0.2) {
        # Se fait vacciner
        current_state <- 1
      }
    } else {
      # Infecté
      if (runif(1) < 0.1) {
        # Meurt
        current_state <- 3
      } else if (runif(1) < 1/3) {
        # Devient vacciné/guéri
        current_state <- 1
      }
    }
  }
  results[i] <- current_state
}

mean(results == 3) # Proportion de morts parmi les simulations
