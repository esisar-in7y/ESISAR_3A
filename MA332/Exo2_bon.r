# sain vacc inf mort
P = matrix(c(0.65, 0.20, 0.15, 0.00,  # État 0 (sain)
             0.00, 1.00, 0.00, 0.00,  # État 1 (vacciné)
             0.00, 1/3*0.9,  2/3*0.9,  0.10,  # État 2 (infecté)
             0.00, 0.00, 0.00, 1.00), # État 3 (mort)
           nrow = 4, ncol = 4, byrow = TRUE)

# Paramètres
n_sims = 10          # Nombre de simulations
n_weeks = 5            # Nombre de semaines à simuler
initial_population = c(1000, 0, 0, 0)  # Population initiale : 1000 sains, 0 vaccinés, 1 infecté, 0 morts

# Fonction pour simuler la propagation de la maladie
simulate_propagation <- function(P, initial_population, n_weeks) {
  population <- initial_population
  for (i in 1:n_weeks) {
    population <- population %*% P
    cat(population,"\n")
  }
  return (population)
}

# Effectuer les simulations
simulations <- replicate(n_sims, simulate_propagation(P, initial_population, n_weeks))

# Calculer les moyennes pour chaque état
mean_sain <- mean(simulations[,1,])/10
mean_vaccine <- mean(simulations[,2,])/10
mean_infecte <- mean(simulations[,3,])/10
mean_mort <- mean(simulations[,4,])/10

# Afficher les résultats
cat("Moyenne des individus sains après", n_weeks, "semaines :", mean_sain, "\n")
cat("Moyenne des individus vaccinés après", n_weeks, "semaines :", mean_vaccine, "\n")
cat("Moyenne des individus infectés après", n_weeks, "semaines :", mean_infecte, "\n")
cat("Moyenne des individus morts après", n_weeks, "semaines :", mean_mort, "\n")


# Q3

simulate_experience <- function(P) {
  state <- 0
  time <- 0
  while (state != 1 && state != 3) {
    state <- sample(0:3, size=1, prob=P[state + 1,])
    time <- time + 1
  }
  return(time)
}

n_experiences <- 10000
times <- replicate(n_experiences, simulate_experience(P))
mean_time <- mean(times)
cat("temps median:",mean_time," semaines \n")


#Q4

n_experiences <- 10000
n_deaths <- 0
for (i in 1:n_experiences) {
  state <- 0
  while (state != 1 && state != 3) {
    state <- sample(0:3, size=1, prob=P[state + 1,])
  }
  if (state == 3) {
    n_deaths <- n_deaths + 1
  }
}
prop_deaths <- n_deaths / n_experiences
cat("probabilité mort:",prop_deaths*100,"%\n")

