# Exercice 1 On  ́etudie l’arriv ́ee de v ́ehicules `a une barri`ere d’autoroute.
# Le temps est mesur ́e en secondes rss. Les arriv ́ees `a la barri`ere de p ́eage
# son enregistr ́ees, plusieurs jours d’affil ́ees, pendant des intervalles de temps
# rt0,t0 Tsavec T 3600 rss(une heure), pour une heure de r ́ef ́erence t0
# choisie. On note Nptqle nombre de v ́ehicules arriv ́es entre les instants t0 et
# t0 t, pour 0 ¤t ¤T. Apr`es un examen attentifs de ces s ́eries temporelles,
# il est d ́ecid ́e de mod ́eliser le processus d’arriv ́ees Nptqcomme un processus
# de Poisson de param`etre λ. Le param`etre optimal obtenu avec la m ́ethode
# du maximum de vraisemblance est λ 1
# 3
# s1.
# (i) Faire une simulation des arriv ́ees sur rt0,t0 Ts, v ́erifier la distribution
# exponentielle des intervalles inter-arriv ́ees et repr ́esenter le graphe de
# l’application t ÞÑNptqobtenu pour cette r ́ealisation particuli`ere.
# (ii) Calculer le nombre moyen d’arriv ́ees dans l’intervalle r0,Ts. Vous
# r ́ealiserez une moyenne d’ensemble sur plusieurs simulations. Vous
# v ́erifierez que le r ́esultat obtenu est en accord avec la th ́eorie (`a la
# pr ́ecision et au taux de confiance pr`es). Pouvez-vous obtenir un r ́esultat
# similaire avec moins de simulations, mais sur des intervalles rt0,t0 Ts
# plus long? Pourquoi?
# (iii) Vous allez maintenant v ́erifier la distribution uniforme des instants
# d’arriv ́ee lorsque le nombre total d’arriv ́ees NpTqest connu. Pour ce
# faire, vous consid ́ererez le cas T 60 et NpTq20. Vous proc ́ederez
# en deux temps :
# (a) v ́erifier que dans le cas g ́en ́eral, les instants d’arriv ́ees An sont
# bien distribu ́es selon une loi Γpλ,nq
# 2
# (b) v ́erifier que, si vous vous limitez aux simulations pour lesquelles
# Np60q20, les instants d’arriv ́ees An sont distribu ́es de mani`ere
# uniforme sur r0,60s

# Set the seed for reproducibility
set.seed(123)

# Define the time interval and the parameter lambda
T <- 3600 # seconds
lambda <- 1/3 # arrivals per second

# Simulate the inter-arrival times using an exponential distribution
interarrival_times <- rexp(1000, rate = lambda)

# Compute the arrival times from the inter-arrival times
arrival_times <- cumsum(interarrival_times)

# Plot the histogram of the inter-arrival times
hist(interarrival_times, breaks = 20, main = "Histogram of inter-arrival times", xlab = "Time (s)")

# Plot the arrival times as a function of time
plot(arrival_times, 1:length(arrival_times), type = "s", main = "Arrivals over time", xlab = "Time (s)", ylab = "Number of arrivals")

# Compute the average number of arrivals in the time interval [0, T]
num_sims <- 1000
num_arrivals <- numeric(num_sims)
for (i in 1:num_sims) {
  interarrival_times <- rexp(1000, rate = lambda)
  arrival_times <- cumsum(interarrival_times)
  num_arrivals[i] <- sum(arrival_times <= T)
}
mean_arrivals <- mean(num_arrivals)
cat("Average number of arrivals in [0, T] =", mean_arrivals, "\n")

# Compute the theoretical mean and variance of the number of arrivals in [0, T]
mean_theoretical <- lambda * T
var_theoretical <- lambda * T
cat("Theoretical mean and variance of arrivals in [0, T] =", mean_theoretical, var_theoretical, "\n")

# Compute the empirical mean and variance of the number of arrivals in [0, T]
mean_empirical <- mean(num_arrivals)
var_empirical <- var(num_arrivals)
cat("Empirical mean and variance of arrivals in [0, T] =", mean_empirical, var_empirical, "\n")
