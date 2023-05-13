
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

