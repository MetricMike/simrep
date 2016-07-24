ask(:password, nil, echo: false)
server 'localhost', user: 'metricmike', password: fetch(:password), roles: %w{app db web}
